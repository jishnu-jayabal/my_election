part of 'voters_list_bloc.dart';

@immutable
sealed class VotersListEvent {}

class FetchVotersListEvent extends VotersListEvent {
  final int? boothId;
  final int? wardId;
  final int? constituencyId;
  FetchVotersListEvent(
    {
      this.boothId,
      this.constituencyId,
      this.wardId
    }
  );
}
