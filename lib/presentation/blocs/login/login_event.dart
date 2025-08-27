part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

/// Triggered to send an OTP to the given phone number.
final class SendOtpEvent extends LoginEvent {
  final String phoneNumber;

  SendOtpEvent({required this.phoneNumber});
}

/// Triggered when the user submits the OTP for verification.
final class VerifyOtpEvent extends LoginEvent {
  final String otp;

  VerifyOtpEvent({required this.otp});
}

/// Triggered when the user logs out.
final class LogoutEvent extends LoginEvent {}

/// Triggered at app start to check if the user is already logged in.
final class CheckIfAlreadyLoggedIn extends LoginEvent {}


final class LoginProcessCompleteEvent extends LoginEvent {}
