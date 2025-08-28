import 'package:bloc/bloc.dart';
import 'package:election_mantra/api/models/party_census_stats.dart';
import 'package:election_mantra/core/api_bridge.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'party_stats_event.dart';
part 'party_stats_state.dart';

class PartyStatsBloc extends Bloc<PartyStatsEvent, PartyStatsState> {
  final ApiBridge _apiBridge = GetIt.I<ApiBridge>();
  PartyStatsBloc() : super(PartyStatsInitial()) {
    on<PartyStatsEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchPartysStatsEvent>((event, emit) async {
      try {
        emit(PartyStatsLoading());
        Map<String, PartyCensusStats> partyCensusStats = await _apiBridge
            .getPartySupportCount(
              boothId: event.boothId,
              constituencyId: event.constituencyId,
              wardId: event.wardId,
            );
        emit(PartyStatsSuccess(partyCensusStats: partyCensusStats));
      } catch (e) {
        emit(PartyStatsFailed(msg: e.toString()));
      }
    });
  }
}
