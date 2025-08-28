import 'package:bloc/bloc.dart';
import 'package:election_mantra/api/models/voters_census_stats.dart';
import 'package:election_mantra/core/api_bridge.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'voters_stats_event.dart';
part 'voters_stats_state.dart';

class VotersStatsBloc extends Bloc<VotersStatsEvent, VotersStatsState> {
    final ApiBridge _apiBridge = GetIt.I<ApiBridge>();
  VotersStatsBloc() : super(VotersStatsInitial()) {
    on<VotersStatsEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchVotersStatsEvent>((event,emit) async{
      try {
        emit(VotersStatsLoading());
        VoterCensusStats voterCensusStats = await _apiBridge.getVoterCensusStatsCount(
          boothId: event.boothId,
          constituencyId: event.constituencyId,
          wardId: event.wardId
        );
        emit(VotersStatsSuccess(voterCensusStats: voterCensusStats));
      }catch(e){
        emit(VotersStatsFailed(msg: e.toString()));
      }
    });
  }
}
