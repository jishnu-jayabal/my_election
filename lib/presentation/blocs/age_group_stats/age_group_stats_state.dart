part of 'age_group_stats_bloc.dart';

@immutable
sealed class AgeGroupStatsState {}

final class AgeGroupStatsInitial extends AgeGroupStatsState {}

final class AgeGroupStatsLoading extends AgeGroupStatsState {}

final class AgeGroupStatsSuccess extends AgeGroupStatsState {
  final List<AgeGroupStats> ageGroupStats;
  AgeGroupStatsSuccess({required this.ageGroupStats});
}

final class AgeGroupStatsFailed extends AgeGroupStatsState {
  final String msg;
  AgeGroupStatsFailed({required this.msg});
}