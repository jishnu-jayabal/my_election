part of 'religion_group_stats_bloc.dart';

@immutable
sealed class ReligionGroupStatsEvent {}


class FetchReligionGroupStatsEvent extends ReligionGroupStatsEvent {
  final int? boothId;
  final int? wardId;
  final int? constituencyId;
  FetchReligionGroupStatsEvent({this.boothId, this.constituencyId, this.wardId});
}
