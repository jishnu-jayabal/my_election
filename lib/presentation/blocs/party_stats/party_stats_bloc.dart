import 'package:bloc/bloc.dart';
import 'package:election_mantra/api/models/party_census_stats.dart';
import 'package:election_mantra/api/models/political_groups.dart';
import 'package:election_mantra/api/models/voter_details.dart';
import 'package:election_mantra/core/api_bridge.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'party_stats_event.dart';
part 'party_stats_state.dart';

class PartyStatsBloc extends Bloc<PartyStatsEvent, PartyStatsState> {
  final ApiBridge _apiBridge = GetIt.I<ApiBridge>();
  PartyStatsBloc() : super(PartyStatsInitial()) {
    on<FetchPartysStatsEventNetwork>((event, emit) async {
      try {
        emit(PartyStatsLoading());
        PartyCensusStats partyCensusStats = await _apiBridge
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

    on<FetchPartysStatsEventLocal>((event, emit) async {
      try {
        emit(PartyStatsLoading());

        final allVoters = event.allVoters ?? [];
        final allParties = event.politicalGroups ?? [];

        if (allVoters.isEmpty || allParties.isEmpty) {
          emit(
            PartyStatsSuccess(
              partyCensusStats: PartyCensusStats(
                total: {},
                voted: {},
                notVoted: {},
              ),
            ),
          );
          return;
        }

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

        final totalCount = filteredVoters.length;
        if (totalCount == 0) {
          emit(
            PartyStatsSuccess(
              partyCensusStats: PartyCensusStats(
                total: {},
                voted: {},
                notVoted: {},
              ),
            ),
          );
          return;
        }

        final totalMap = <String, PartyCountDetail>{};
        final votedMap = <String, PartyCountDetail>{};
        final notVotedMap = <String, PartyCountDetail>{};

        for (final party in allParties) {
          final partyVoters =
              filteredVoters.where((v) => v.party == party.name).toList();
          final votedCount = partyVoters.where((v) => v.voted).length;
          final notVotedCount = partyVoters.where((v) => !v.voted).length;

          totalMap[party.name] = PartyCountDetail(
            party: party.name,
            count: partyVoters.length,
            percentage: (partyVoters.length / totalCount) * 100,
            color: party.color,
          );

          votedMap[party.name] = PartyCountDetail(
            party: party.name,
            count: votedCount,
            percentage: (votedCount / totalCount) * 100,
            color: party.color,
          );

          notVotedMap[party.name] = PartyCountDetail(
            party: party.name,
            count: notVotedCount,
            percentage: (notVotedCount / totalCount) * 100,
            color: party.color,
          );
        }

        emit(
          PartyStatsSuccess(
            partyCensusStats: PartyCensusStats(
              total: totalMap,
              voted: votedMap,
              notVoted: notVotedMap,
            ),
          ),
        );
      } catch (e) {
        emit(PartyStatsFailed(msg: e.toString()));
      }
    });
  }
}
