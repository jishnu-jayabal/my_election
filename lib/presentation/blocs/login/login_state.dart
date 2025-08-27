part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

/// Initial state (user not logged in or app just launched).
final class LoginInitial extends LoginState {}

/// Indicates a loading operation (e.g., sending OTP, verifying).
final class LoginLoadingState extends LoginState {}

/// State when OTP has been successfully sent.
final class OtpSentState extends LoginState {
  final String phoneNumber;

  OtpSentState({required this.phoneNumber});
}


/// State when user is successfully logged in.
final class LoginSuccessState extends LoginState {
  final User user;

  LoginSuccessState({required this.user});

  Map<String, dynamic> toJson() => user.toJson();

  factory LoginSuccessState.fromJson(Map<String, dynamic> json) {
    return LoginSuccessState(user: User.fromJson(json));
  }
}

/// State when login or verification fails.
final class LoginFailedState extends LoginState {
  final String error;

  LoginFailedState({required this.error});
}
