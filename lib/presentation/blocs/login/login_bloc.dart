import 'dart:async';
import 'package:election_mantra/api/models/user.dart';
import 'package:election_mantra/core/api_bridge.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';


part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends HydratedBloc<LoginEvent, LoginState> {
  final ApiBridge _apiBridge = GetIt.I<ApiBridge>();

  LoginBloc() : super(LoginInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<CheckIfAlreadyLoggedIn>(_onCheckIfAlreadyLoggedIn);
    on<LogoutEvent>(_onLogout);
    on<LoginProcessCompleteEvent>(onLoginProcessComplete);
  }

  FutureOr<void> onLoginProcessComplete(event, emit) async {
    final user = await _apiBridge.getUserProfile();

    if (user != null) {
      emit(LoginSuccessState(user: user));
    } else {
      emit(
        LoginFailedState(error: 'User profile not found after verification.'),
      );
    }
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    try {
      await _apiBridge.sendOtp(event.phoneNumber);
      emit(OtpSentState(phoneNumber: event.phoneNumber));
    } catch (e) {
      emit(LoginFailedState(error: 'Failed to send OTP: ${e.toString()}'));
    }
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoadingState());
    try {
      await _apiBridge.verifyOtp(event.otp);

      final user = await _apiBridge.getUserProfile();

      if (user != null) {
        emit(LoginSuccessState(user: user));
      } else {
        emit(
          LoginFailedState(error: 'User profile not found after verification.'),
        );
      }
    } catch (e) {
      emit(LoginFailedState(error: 'OTP verification failed: ${e.toString()}'));
    }
  }

  void _onCheckIfAlreadyLoggedIn(
    CheckIfAlreadyLoggedIn event,
    Emitter<LoginState> emit,
  ) {
    if (state is LoginSuccessState) {
      emit(state);
    } else {
      emit(LoginInitial());
    }
  }

  void _onLogout(LogoutEvent event, Emitter<LoginState> emit) {
    _apiBridge.signOut(); // Clear backend/session
    clear(); // This clears the persisted state
    emit(LoginInitial());
  }

  @override
  LoginState? fromJson(Map<String, dynamic> json) {
    try {
      return LoginSuccessState.fromJson(json);
    } catch (_) {
      return LoginInitial();
    }
  }

  @override
  Map<String, dynamic>? toJson(LoginState state) {
    if (state is LoginSuccessState) {
      return state.toJson();
    }
    return null;
  }
}
