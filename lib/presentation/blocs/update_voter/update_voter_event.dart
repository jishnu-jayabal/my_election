part of 'update_voter_bloc.dart';

@immutable
sealed class UpdateVoterEvent {}

class UpdateVoterDetailsEvent extends UpdateVoterEvent{
  final VoterDetails voterDetails;
  UpdateVoterDetailsEvent({required this.voterDetails});
}