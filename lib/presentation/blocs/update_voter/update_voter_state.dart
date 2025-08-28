part of 'update_voter_bloc.dart';

@immutable
sealed class UpdateVoterState {}

final class UpdateVoterInitial extends UpdateVoterState {}


final class UpdateVoterLoading extends UpdateVoterState {}


final class UpdateVoterSuccess extends UpdateVoterState {
  final VoterDetails voterUpdated;
  UpdateVoterSuccess({
    required this.voterUpdated
  });
}

final class UpdateVoterFailed extends UpdateVoterState {
  final String msg;
  UpdateVoterFailed({required this.msg});
}