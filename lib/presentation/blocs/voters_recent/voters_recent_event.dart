part of 'voters_recent_bloc.dart';

@immutable
sealed class VotersRecentEvent {}

class FetchVotersRecentEvent extends VotersRecentEvent {
  final int? boothId;
  final int? wardId;
  final int? constituencyId;
  FetchVotersRecentEvent(
    {
      this.boothId,
      this.constituencyId,
      this.wardId
    }
  );
}

