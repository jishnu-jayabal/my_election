part of 'voters_recent_bloc.dart';

@immutable
sealed class VotersRecentState {}

final class VotersRecentInitial extends VotersRecentState {}

final class VotersRecentLoading extends VotersRecentState{}

final class VotersRecentSuccess extends VotersRecentState{
  final List<VoterDetails> voters;
  VotersRecentSuccess(
    {required this.voters}
  );
}

final class VotersRecentFailure extends VotersRecentState{
  final String msg;
  VotersRecentFailure({required this.msg});
}