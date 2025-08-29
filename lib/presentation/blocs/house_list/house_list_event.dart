part of 'house_list_bloc.dart';

@immutable
abstract class HouseListEvent {}

class FetchHouseListEventLocal extends HouseListEvent {
  final List<VoterDetails> voters;
  FetchHouseListEventLocal({required this.voters});
}

class SearchHouseListEvent extends HouseListEvent {
  final String? searchTerm;
  SearchHouseListEvent({this.searchTerm});
}

class ToggleHouseExpansionEvent extends HouseListEvent {
  final String houseName;
  ToggleHouseExpansionEvent({required this.houseName});
}

class UpdateVoterInHouseListEvent extends HouseListEvent {
  final VoterDetails voter;
  UpdateVoterInHouseListEvent({required this.voter});
}
