part of 'age_group_stats_bloc.dart';

@immutable
sealed class AgeGroupStatsEvent {}


class FetchAgeGroupStatsEvent extends AgeGroupStatsEvent {
  final int? boothId;
  final int? wardId;
  final int? constituencyId;
  FetchAgeGroupStatsEvent({this.boothId, this.constituencyId, this.wardId});
}
