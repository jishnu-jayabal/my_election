part of 'voters_stats_bloc.dart';

@immutable
sealed class VotersStatsEvent {}

class FetchVotersStatsEvent extends VotersStatsEvent {
  final int? boothId;
  final int? wardId;
  final int? constituencyId;
  FetchVotersStatsEvent({this.boothId, this.constituencyId, this.wardId});
}
