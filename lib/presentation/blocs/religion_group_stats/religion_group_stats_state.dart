part of 'religion_group_stats_bloc.dart';

@immutable
sealed class ReligionGroupStatsState {}

final class ReligionGroupStatsInitial extends ReligionGroupStatsState {}

final class ReligionGroupStatsLoading extends ReligionGroupStatsState {}

final class ReligionGroupStatsSuccess extends ReligionGroupStatsState {
  final List<ReligionGroupStats> religionGroupStats;
  ReligionGroupStatsSuccess({required this.religionGroupStats});
}

final class ReligionGroupStatsFailed extends ReligionGroupStatsState {
  final String msg;
  ReligionGroupStatsFailed({required this.msg});
}