import 'package:bloc/bloc.dart';
import 'package:election_mantra/api/models/religion.dart';
import 'package:election_mantra/api/models/religion_group_stats.dart';
import 'package:election_mantra/api/models/voter_details.dart';
import 'package:election_mantra/core/api_bridge.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'religion_group_stats_event.dart';
part 'religion_group_stats_state.dart';

class ReligionGroupStatsBloc
    extends Bloc<ReligionGroupStatsEvent, ReligionGroupStatsState> {
  final ApiBridge _apiBridge = GetIt.I<ApiBridge>();
  ReligionGroupStatsBloc() : super(ReligionGroupStatsInitial()) {
    on<FetchReligionGroupStatsEventNetwork>((event, emit) async {
      try {
        emit(ReligionGroupStatsLoading());
        List<ReligionGroupStats> religionGroupStats = await _apiBridge
            .getReligionGroupStatsCount(
              boothId: event.boothId,
              constituencyId: event.constituencyId,
              wardId: event.wardId,
            );
        emit(ReligionGroupStatsSuccess(religionGroupStats: religionGroupStats));
      } catch (e) {
        emit(ReligionGroupStatsFailed(msg: e.toString()));
      }
    });
    on<FetchReligionGroupStatsLocal>((event, emit) async {
      try {
        emit(ReligionGroupStatsLoading());

        final allVoters = event.allVoters ?? [];

        // Total voters
        final total = allVoters.length;

        // Example: Fetch religions from config
        final religions =
           event.religions ?? []; // List<Religion> with {name, value, color}

        List<ReligionGroupStats> result = [];
        int knownTotal = 0;
        Religion? otherReligion;

        for (var religion in religions) {
          if (religion.value == "other") {
            otherReligion = religion;
            continue; // skip for now
          }

          // Count voters for this religion
          final count =
              allVoters.where((v) => v.religion == religion.value).length;
          knownTotal += count;

          result.add(
            ReligionGroupStats(
              label: religion.name,
              count: count,
              color: religion.color,
              percentage: total > 0 ? (count / total) * 100 : 0,
            ),
          );
        }

        // Handle "Other" religion
        if (otherReligion != null) {
          final otherCount = total - knownTotal;
          result.add(
            ReligionGroupStats(
              label: otherReligion.name,
              count: otherCount,
              color: otherReligion.color,
              percentage: total > 0 ? (otherCount / total) * 100 : 0,
            ),
          );
        }

        emit(ReligionGroupStatsSuccess(religionGroupStats: result));
      } catch (e) {
        emit(ReligionGroupStatsFailed(msg: e.toString()));
      }
    });
  }
}
