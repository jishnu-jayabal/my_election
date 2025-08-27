part of 'party_stats_bloc.dart';

@immutable
sealed class PartyStatsEvent {}

class FetchPartysStatsEvent extends PartyStatsEvent {
  final int? boothId;
  final int? wardId;
  final int? constituencyId;
  FetchPartysStatsEvent({this.boothId, this.constituencyId, this.wardId});
}
