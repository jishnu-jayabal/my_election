part of 'voters_list_bloc.dart';

@immutable
sealed class VotersListEvent {}

class FetchVotersListEvent extends VotersListEvent {
  final int? boothId;
  final int? wardId;
  final int? constituencyId;
  FetchVotersListEvent({this.boothId, this.constituencyId, this.wardId});
}

class SearchVoterListEvent extends VotersListEvent {
  final String? searchTerm;
  SearchVoterListEvent({
    required this.searchTerm,
  });
}

class SearchHouseListEvent extends VotersListEvent {
  final String? searchTerm;
  SearchHouseListEvent({
    required this.searchTerm,
  });
}

class FetchVoterListByFilterEventNetwork extends VotersListEvent {
  final int? boothId;
  final int? wardId;
  final int? constituencyId;
  final FilterModel filter;
  FetchVoterListByFilterEventNetwork({
    required this.boothId,
    required this.constituencyId,
    required this.wardId,
    required this.filter,
  });
}

class FetchVoterListByFilterEventLocal extends VotersListEvent {
  final int? boothId;
  final int? wardId;
  final int? constituencyId;
  final FilterModel filter;
  FetchVoterListByFilterEventLocal({
    required this.boothId,
    required this.constituencyId,
    required this.wardId,
    required this.filter,
  });
}

class ReplcaeVoterDetailsevent extends VotersListEvent {
  final VoterDetails voterDetails;
  ReplcaeVoterDetailsevent({required this.voterDetails});
}
