part of 'party_stats_bloc.dart';

@immutable
sealed class PartyStatsState {}

final class PartyStatsInitial extends PartyStatsState {}

final class PartyStatsLoading extends PartyStatsState {}

final class PartyStatsSuccess extends PartyStatsState {
  final PartyCensusStats partyCensusStats;
  PartyStatsSuccess({required this.partyCensusStats});
}

final class PartyStatsFailed extends PartyStatsState {
  final String msg;
  PartyStatsFailed({required this.msg});
}