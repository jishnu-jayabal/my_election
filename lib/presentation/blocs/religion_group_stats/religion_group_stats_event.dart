part of 'religion_group_stats_bloc.dart';

@immutable
sealed class ReligionGroupStatsEvent {}


class FetchReligionGroupStatsEventNetwork extends ReligionGroupStatsEvent {
  final int? boothId;
  final int? wardId;
  final int? constituencyId;
  FetchReligionGroupStatsEventNetwork({this.boothId, this.constituencyId, this.wardId});
}

class FetchReligionGroupStatsLocal extends ReligionGroupStatsEvent {
  final int? boothId;
  final int? wardId;
  final int? constituencyId;
  final List<VoterDetails>? allVoters;
  final List<Religion>? religions;
  FetchReligionGroupStatsLocal({
    this.boothId,
    this.constituencyId,
    this.wardId,
    this.allVoters,
    this.religions
  });
}
