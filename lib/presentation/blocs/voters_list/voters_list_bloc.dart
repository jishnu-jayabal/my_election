import 'package:bloc/bloc.dart';
import 'package:election_mantra/api/models/filter_model.dart';
import 'package:election_mantra/api/models/voter_details.dart';
import 'package:election_mantra/core/api_bridge.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'voters_list_event.dart';
part 'voters_list_state.dart';

class VotersListBloc extends Bloc<VotersListEvent, VotersListState> {
  List<VoterDetails> _allVoters = [];
  Map<String, List<VoterDetails>> houseWise = {};
  final ApiBridge _apiBridge = GetIt.I<ApiBridge>();
  VotersListBloc() : super(VotersListInitial()) {
    on<SearchVoterListEvent>((event, emit) async {
      try {
        emit(VotersListLoading());

        final query = event.searchTerm!.trim().toLowerCase();

        final filteredVoters =
            _allVoters.where((voter) {
              return voter.name.toLowerCase().contains(query) ||
                  voter.guardianName.toLowerCase().contains(query) ||
                  voter.houseName.toLowerCase().contains(query) ||
                  voter.voterId.toLowerCase().contains(query);
            }).toList();

        final grouped = _groupByHouse(filteredVoters);

        emit(VotersListSuccess(voters: filteredVoters, houseWise: grouped));
      } catch (e) {
        emit(VotersListFailure(msg: e.toString()));
      }
    });

    on<SearchHouseListEvent>((event, emit) async {
      try {
        emit(VotersListLoading());

        final query = event.searchTerm!.trim().toLowerCase();

        // find all voters that match house name
        final filtered =
            _allVoters.where((voter) {
              return voter.houseName.toLowerCase().contains(query);
            }).toList();

        // group by house
        final grouped = _groupByHouse(filtered);

        emit(VotersListSuccess(voters: filtered, houseWise: grouped));
      } catch (e) {
        emit(VotersListFailure(msg: "House search failed: $e"));
      }
    });

    on<FetchVotersListEvent>((event, emit) async {
      try {
        emit(VotersListLoading());
        _allVoters = await _apiBridge.getVoters(
          boothId: event.boothId,
          constituencyId: event.constituencyId,
          wardId: event.wardId,
        );

        final grouped = _groupByHouse(_allVoters);
        emit(VotersListSuccess(voters: _allVoters, houseWise: grouped));
      } catch (e) {
        emit(VotersListFailure(msg: e.toString()));
      }
    });

    on<FetchVoterListByFilterEventNetwork>((event, emit) async {
      try {
        emit(VotersListLoading());
        List<VoterDetails> voters = await _apiBridge.getVotersByFilter(
          boothId: event.boothId,
          constituencyId: event.constituencyId,
          wardId: event.wardId,
          filter: event.filter,
        );

        final grouped = _groupByHouse(voters);

        emit(VotersListSuccess(voters: voters, houseWise: grouped));
      } catch (e) {
        emit(VotersListFailure(msg: e.toString()));
      }
    });

    on<FetchVoterListByFilterEventLocal>((event, emit) async {
      try {
        emit(VotersListLoading());

        List<VoterDetails> voters =
            _allVoters.where((v) {
              bool matches = true;

              // status → pending / completed (based on updated_by field)
              if (event.filter.status != null) {
                if (event.filter.status == "completed") {
                  matches &= (v.updatedBy != null && v.updatedBy!.isNotEmpty);
                } else if (event.filter.status == "pending") {
                  matches &= (v.updatedBy == null || v.updatedBy!.isEmpty);
                }
              }

              // affiliation / party
              if (event.filter.affiliation != null) {
                matches &=
                    v.party.toLowerCase() ==
                    event.filter.affiliation!.toLowerCase();
              }

              // religion
              if (event.filter.religion != null) {
                matches &=
                    v.religion.toLowerCase() ==
                    event.filter.religion!.toLowerCase();
              }

              // gender
              if (event.filter.gender != null) {
                matches &=
                    v.gender.toLowerCase() ==
                    event.filter.gender!.toLowerCase();
              }

              // age group
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
                    matches &= age >= 60;
                    break;
                  case "Unknown":
                    matches &= v.age == null;
                    break;
                }
              }

              return matches;
            }).toList();
        final grouped = _groupByHouse(voters);

        emit(VotersListSuccess(voters: voters, houseWise: grouped));
      } catch (e) {
        emit(VotersListFailure(msg: "Local filter failed: $e"));
      }
    });

    on<ReplcaeVoterDetailsevent>((event, emit) async {
      try {
        final indexInAll = _allVoters.indexWhere(
          (v) => v.id == event.voterDetails.id,
        );
        if (indexInAll != -1) {
          _allVoters[indexInAll] = event.voterDetails;
        }

        if (state is VotersListSuccess) {
          final currentList = (state as VotersListSuccess).voters;
          final indexInVisible = currentList.indexWhere(
            (v) => v.id == event.voterDetails.id,
          );

          List<VoterDetails> updatedVisible = List.from(currentList);

          if (indexInVisible != -1) {
            updatedVisible[indexInVisible] = event.voterDetails;
          }

          final grouped = _groupByHouse(updatedVisible);

          emit(VotersListSuccess(voters: updatedVisible, houseWise: grouped));
        } else {
          final grouped = _groupByHouse(_allVoters);
          emit(
            VotersListSuccess(
              voters: List.from(_allVoters),
              houseWise: grouped,
            ),
          );
        }
      } catch (e) {
        emit(VotersListFailure(msg: "Failed to replace voter: $e"));
      }
    });
  }

  Map<String, List<VoterDetails>> _groupByHouse(List<VoterDetails> voters) {
    final Map<String, List<VoterDetails>> grouped = {};

    for (var voter in voters) {
      final house =
          voter.houseName.trim().isEmpty ? "Unknown House" : voter.houseName;
      grouped.putIfAbsent(house, () => []);
      grouped[house]!.add(voter);
    }

    // Optional: sort each house’s voters by serial number
    for (var list in grouped.values) {
      list.sort((a, b) => a.serialNo.compareTo(b.serialNo));
    }

    return grouped;
  }
}
