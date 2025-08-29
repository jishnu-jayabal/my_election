part of 'house_list_bloc.dart';

@immutable
abstract class HouseListState {}

class HouseListInitial extends HouseListState {}

class HouseListLoading extends HouseListState {}


class HouseListSuccess extends HouseListState {
  final Map<String, List<VoterDetails>> houseWise;
  final Map<String, bool> expandedState;

  HouseListSuccess({
    required this.houseWise,
    required this.expandedState,
  });
}

