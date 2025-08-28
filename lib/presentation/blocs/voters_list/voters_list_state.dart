part of 'voters_list_bloc.dart';

@immutable
sealed class VotersListState {}

final class VotersListInitial extends VotersListState {}

final class VotersListLoading extends VotersListState{}

final class VotersListSuccess extends VotersListState{
  final List<VoterDetails> voters;
  final Map<String, List<VoterDetails>> houseWise;
  VotersListSuccess(
    {required this.voters,required this.houseWise}
  );
}

final class VotersListFailure extends VotersListState{
  final String msg;
  VotersListFailure({required this.msg});
}