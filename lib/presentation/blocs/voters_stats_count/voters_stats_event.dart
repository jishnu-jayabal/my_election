part of 'voters_stats_bloc.dart';

@immutable
sealed class VotersStatsEvent {}

class FetchVotersStatsEventNetwork extends VotersStatsEvent {
  final int? boothId;
  final int? wardId;
  final int? constituencyId;
  FetchVotersStatsEventNetwork({this.boothId, this.constituencyId, this.wardId});
}

class FetchVotersStatsEventLocal extends VotersStatsEvent {
  final int? boothId;
  final int? wardId;
  final int? constituencyId;
  final List<VoterDetails>? allVoters;
  FetchVotersStatsEventLocal({
    this.boothId,
    this.constituencyId,
    this.wardId,
    this.allVoters,
  });
}
