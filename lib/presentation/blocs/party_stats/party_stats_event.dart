part of 'party_stats_bloc.dart';

@immutable
sealed class PartyStatsEvent {}

class FetchPartysStatsEventNetwork extends PartyStatsEvent {
  final int? boothId;
  final int? wardId;
  final int? constituencyId;
  FetchPartysStatsEventNetwork({
    this.boothId,
    this.constituencyId,
    this.wardId,
  });
}

class FetchPartysStatsEventLocal extends PartyStatsEvent {
  final int? boothId;
  final int? wardId;
  final int? constituencyId;
  final List<VoterDetails>? allVoters;
  final List<PoliticalGroups>? politicalGroups;
  FetchPartysStatsEventLocal({
    this.boothId,
    this.constituencyId,
    this.wardId,
    this.allVoters,
    this.politicalGroups
  });
}
