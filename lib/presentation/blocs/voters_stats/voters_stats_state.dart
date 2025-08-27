part of 'voters_stats_bloc.dart';

@immutable
sealed class VotersStatsState {}

final class VotersStatsInitial extends VotersStatsState {}

final class VotersStatsLoading extends VotersStatsState {}

final class VotersStatsSuccess extends VotersStatsState {
  final VoterCensusStats voterCensusStats;
  VotersStatsSuccess({required this.voterCensusStats});
}

final class VotersStatsFailed extends VotersStatsState {
  final String msg;
  VotersStatsFailed({required this.msg});
}