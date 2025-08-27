import 'package:bloc/bloc.dart';
import 'package:election_mantra/api/models/voter.dart';
import 'package:election_mantra/core/api_bridge.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'voters_recent_event.dart';
part 'voters_recent_state.dart';

class VotersRecentBloc extends Bloc<VotersRecentEvent, VotersRecentState> {
  final ApiBridge _apiBridge = GetIt.I<ApiBridge>();
  VotersRecentBloc() : super(VotersRecentInitial()) {
    on<FetchVotersRecentEvent>((event, emit) async {
      try {
        emit(VotersRecentLoading());
        List<VoterDetails> voters = await _apiBridge.getVoters(
          boothId: event.boothId,
          constituencyId: event.constituencyId,
          wardId: event.wardId,
          limit: 5
        );
        emit(VotersRecentSuccess(voters: voters));
      } catch (e) {
        emit(VotersRecentFailure(msg: e.toString()));
      }
    });
  }
}
