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


class FetchVoterListByFilterEvent extends VotersListEvent {
    final int? boothId;
  final int? wardId;
  final int? constituencyId;
  final FilterModel filter;
  FetchVoterListByFilterEvent({
    required this.boothId,
    required this.constituencyId,
    required this.wardId,
    required this.filter});
}
