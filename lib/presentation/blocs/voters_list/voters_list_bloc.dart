import 'package:bloc/bloc.dart';
import 'package:election_mantra/api/models/filter_model.dart';
import 'package:election_mantra/api/models/voter.dart';
import 'package:election_mantra/core/api_bridge.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'voters_list_event.dart';
part 'voters_list_state.dart';

class VotersListBloc extends Bloc<VotersListEvent, VotersListState> {
  final ApiBridge _apiBridge = GetIt.I<ApiBridge>();
  VotersListBloc() : super(VotersListInitial()) {
    on<VotersListEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchVotersListEvent>((event, emit) async {
      try {
        emit(VotersListLoading());
        List<VoterDetails> voters = await _apiBridge.getVoters(
          boothId: event.boothId,
          constituencyId: event.constituencyId,
          wardId: event.wardId,
        );
        emit(VotersListSuccess(voters: voters));
      } catch (e) {
        emit(VotersListFailure(msg: e.toString()));
      }
    });

    on<FetchVoterListByFilterEvent>((event, emit) async {
      try {
        emit(VotersListLoading());
        List<VoterDetails> voters = await _apiBridge.getVotersByFilter(
          boothId: event.boothId,
          constituencyId: event.constituencyId,
          wardId: event.wardId,
          filter: event.filter
        );
        emit(VotersListSuccess(voters: voters));
      } catch (e) {
        emit(VotersListFailure(msg: e.toString()));
      }
    });
  }
}
