part of 'startup_bloc.dart';

@immutable
sealed class StartupEvent {}

class FetchStartupEvent extends StartupEvent{}