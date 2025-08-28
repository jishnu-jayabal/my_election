part of 'startup_bloc.dart';

@immutable
sealed class StartupState {}

final class StartupInitial extends StartupState {}


final class StartupLoading extends StartupState {}


final class StartupSuccess extends StartupState {
  final List<Education> education;
  final List<VoterType> voterType;
  final List<VoterConcern> voterConcern;
  final List<StayingStatus> stayingStatus;
  final List<Gender> genders;
  StartupSuccess({required this.education
  ,required this.genders,
  required this.voterType,
  required this.voterConcern,
  required this.stayingStatus,
  });
}

final class StartupFailed extends StartupState {
  final String msg;
  StartupFailed({required this.msg});
}