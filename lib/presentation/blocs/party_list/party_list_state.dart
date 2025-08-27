part of 'party_list_bloc.dart';

@immutable
sealed class PartyListState {}

final class PartyListInitial extends PartyListState {}


final class PartyListLoading extends PartyListState {}

final class PartyListSuccess extends PartyListState {
  final List<PoliticalGroups> politicalGroups;
  PartyListSuccess({required this.politicalGroups});
}

final class PartyListFailed extends PartyListState {
  final String msg;
  PartyListFailed({required this.msg});
}