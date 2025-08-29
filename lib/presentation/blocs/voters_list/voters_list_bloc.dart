import 'package:bloc/bloc.dart';
import 'package:election_mantra/api/models/filter_model.dart';
import 'package:election_mantra/api/models/voter_details.dart';
import 'package:election_mantra/core/api_bridge.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'voters_list_event.dart';
part 'voters_list_state.dart';

class VotersListBloc extends Bloc<VotersListEvent, VotersListState> {
  List<VoterDetails> allVoters = []; // Master full list
  List<VoterDetails> _visibleVoters =
      []; // Currently displayed (filtered/search)
  final ApiBridge _apiBridge = GetIt.I<ApiBridge>();

  VotersListBloc() : super(VotersListInitial()) {
    /// Fetch all voters
    on<FetchVotersListEvent>((event, emit) async {
      try {
        emit(VotersListLoading());
        allVoters = await _apiBridge.getVoters(
          boothId: event.boothId,
          constituencyId: event.constituencyId,
          wardId: event.wardId,
        );
        _visibleVoters = List.from(allVoters);
        emit(VotersListSuccess(voters: _visibleVoters));
      } catch (e) {
        emit(VotersListFailure(msg: e.toString()));
      }
    });

    /// Search voters by name/ID/house/guardian
    on<SearchVoterListEvent>((event, emit) {
      final query = event.searchTerm?.trim().toLowerCase() ?? "";
      _visibleVoters =
          allVoters.where((voter) {
            return voter.name.toLowerCase().contains(query) ||
                voter.guardianName.toLowerCase().contains(query) ||
                voter.houseName.toLowerCase().contains(query) ||
                voter.voterId.toLowerCase().contains(query);
          }).toList();
      emit(VotersListSuccess(voters: _visibleVoters));
    });

    on<ReplcaeVoterDetailsevent>((event, emit) {
      if (state is! VotersListSuccess) return;
      final currentState = state as VotersListSuccess;

      // Update master list
      final indexInAll = allVoters.indexWhere(
        (v) => v.id == event.voterDetails.id,
      );
      if (indexInAll != -1) allVoters[indexInAll] = event.voterDetails;

      // Update visible list
      final updatedVisible =
          currentState.voters
              .map(
                (v) => v.id == event.voterDetails.id ? event.voterDetails : v,
              )
              .toList();

      emit(currentState.copyWith(voters: updatedVisible));
    });

    /// Network filter
    on<FetchVoterListByFilterEventNetwork>((event, emit) async {
      try {
        emit(VotersListLoading());
        List<VoterDetails> voters = await _apiBridge.getVotersByFilter(
          boothId: event.boothId,
          constituencyId: event.constituencyId,
          wardId: event.wardId,
          filter: event.filter,
        );
        _visibleVoters = List.from(voters);
        emit(VotersListSuccess(voters: _visibleVoters));
      } catch (e) {
        emit(VotersListFailure(msg: "Network filter failed: $e"));
      }
    });

    /// Local filter
    on<FetchVoterListByFilterEventLocal>((event, emit) async {
      try {
        emit(VotersListLoading());

        List<VoterDetails> voters =
            allVoters.where((v) {
              bool matches = true;

              if (event.filter.status != null) {
                if (event.filter.status == "completed") {
                  matches &= (v.updatedBy != null && v.updatedBy!.isNotEmpty);
                } else if (event.filter.status == "pending") {
                  matches &= (v.updatedBy == null || v.updatedBy!.isEmpty);
                }
              }

              if (event.filter.affiliation != null) {
                matches &=
                    v.party.toLowerCase() ==
                    event.filter.affiliation!.toLowerCase();
              }

              if (event.filter.religion != null) {
                matches &=
                    v.religion.toLowerCase() ==
                    event.filter.religion!.toLowerCase();
              }

              if (event.filter.gender != null) {
                matches &=
                    v.gender.toLowerCase() ==
                    event.filter.gender!.toLowerCase();
              }

              if (event.filter.ageGroup != null) {
                final age = v.age ?? 0;
                switch (event.filter.ageGroup) {
                  case "18-25":
                    matches &= age >= 18 && age <= 25;
                    break;
                  case "26-40":
                    matches &= age >= 26 && age <= 40;
                    break;
                  case "41-60":
                    matches &= age >= 41 && age <= 60;
                    break;
                  case "61+":
                    matches &= age >= 61;
                    break;
                  case "Unknown":
                    matches &= v.age == null;
                    break;
                }
              }

              return matches;
            }).toList();

        _visibleVoters = voters;
        emit(VotersListSuccess(voters: _visibleVoters));
      } catch (e) {
        emit(VotersListFailure(msg: "Local filter failed: $e"));
      }
    });
  }
}
