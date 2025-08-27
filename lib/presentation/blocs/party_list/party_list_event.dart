part of 'party_list_bloc.dart';

@immutable
sealed class PartyListEvent {}

class FetchPartyListEvent extends PartyListEvent{}