part of 'religion_bloc.dart';

@immutable
sealed class ReligionState {}

final class ReligionInitial extends ReligionState {}


final class ReligionLoading extends ReligionState {}

final class ReligionSuccess extends ReligionState {
  final List<Religion> religions;
  ReligionSuccess({required this.religions});
}

final class ReligionFailed extends ReligionState {
  final String msg;
  ReligionFailed({required this.msg});
}