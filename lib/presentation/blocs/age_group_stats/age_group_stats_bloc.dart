import 'package:bloc/bloc.dart';
import 'package:election_mantra/api/models/age_group_stats.dart';
import 'package:election_mantra/core/api_bridge.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'age_group_stats_event.dart';
part 'age_group_stats_state.dart';

class AgeGroupStatsBloc extends Bloc<AgeGroupStatsEvent, AgeGroupStatsState> {
      final ApiBridge _apiBridge = GetIt.I<ApiBridge>();
  AgeGroupStatsBloc() : super(AgeGroupStatsInitial()) {
    
     on<FetchAgeGroupStatsEvent>((event,emit) async{
      try {
        emit(AgeGroupStatsLoading());
         List<AgeGroupStats> ageGroupStats = await _apiBridge.getAgeGroupStatsCount(
          boothId: event.boothId,
          constituencyId: event.constituencyId,
          wardId: event.wardId
        );
        emit(AgeGroupStatsSuccess(ageGroupStats: ageGroupStats));
      }catch(e){
        emit(AgeGroupStatsFailed(msg: e.toString()));
      }
    });
  }
}
