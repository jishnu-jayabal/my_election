import 'package:bloc/bloc.dart';
import 'package:election_mantra/api/models/political_groups.dart';
import 'package:election_mantra/api/models/voter_details.dart';
import 'package:election_mantra/api/models/voters_census_stats.dart';
import 'package:election_mantra/core/api_bridge.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'voters_stats_event.dart';
part 'voters_stats_state.dart';

class VotersStatsBloc extends Bloc<VotersStatsEvent, VotersStatsState> {
  final ApiBridge _apiBridge = GetIt.I<ApiBridge>();
  VotersStatsBloc() : super(VotersStatsInitial()) {
    on<FetchVotersStatsEventNetwork>((event, emit) async {
      try {
        emit(VotersStatsLoading());
        VoterCensusStats voterCensusStats = await _apiBridge
            .getVoterCensusStatsCount(
              boothId: event.boothId,
              constituencyId: event.constituencyId,
              wardId: event.wardId,
            );
        emit(VotersStatsSuccess(voterCensusStats: voterCensusStats));
      } catch (e) {
        emit(VotersStatsFailed(msg: e.toString()));
      }
    });
    on<FetchVotersStatsEventLocal>((event, emit) async {
      try {
        emit(VotersStatsLoading());

        final allVoters = event.allVoters ?? [];

        // Filter voters by booth, ward, constituency if provided
        final filteredVoters =
            allVoters.where((voter) {
              final boothMatch =
                  event.boothId == null || voter.bhagNo == event.boothId;

              final constituencyMatch =
                  event.constituencyId == null ||
                  voter.assembly == event.constituencyId;
              return boothMatch && constituencyMatch;
            }).toList();

        final total = filteredVoters.length;
        final completed =
            filteredVoters.where((v) => v.updatedBy!.isNotEmpty).length;
        final pending = total - completed;

        emit(
          VotersStatsSuccess(
            voterCensusStats: VoterCensusStats(
              totalVoters: total,
              completedVoters: completed,
              pendingVoters: pending,
            ),
          ),
        );
      } catch (e) {
        emit(VotersStatsFailed(msg: e.toString()));
      }
    });
  }
}
