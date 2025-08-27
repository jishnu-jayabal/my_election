import 'package:bloc/bloc.dart';
import 'package:election_mantra/api/models/religion_group_stats.dart';
import 'package:election_mantra/core/api_bridge.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'religion_group_stats_event.dart';
part 'religion_group_stats_state.dart';

class ReligionGroupStatsBloc
    extends Bloc<ReligionGroupStatsEvent, ReligionGroupStatsState> {
  final ApiBridge _apiBridge = GetIt.I<ApiBridge>();
  ReligionGroupStatsBloc() : super(ReligionGroupStatsInitial()) {
    on<ReligionGroupStatsEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchReligionGroupStatsEvent>((event, emit) async {
      try {
        emit(ReligionGroupStatsLoading());
        List<ReligionGroupStats> religionGroupStats = await _apiBridge.getReligionGroupStats(
          boothId: event.boothId,
          constituencyId: event.constituencyId,
          wardId: event.wardId,
        );
        emit(ReligionGroupStatsSuccess(religionGroupStats: religionGroupStats));
      } catch (e) {
        emit(ReligionGroupStatsFailed(msg: e.toString()));
      }
    });
  }
}
