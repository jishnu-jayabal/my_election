import 'dart:async';
import 'package:election_mantra/app_routes.dart';
import 'package:election_mantra/core/constant/palette.dart';
import 'package:election_mantra/core/theme/pin_theme.dart';
import 'package:election_mantra/presentation/blocs/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pinput/pinput.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final otpController = TextEditingController();
  String? fullPhoneNumber;
  bool otpSent = false;

  Timer? _resendOtpTimer;
  int _resendSeconds = 30;


  @override
  void dispose() {
    _resendOtpTimer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  void startResendOtpTimer() {
    setState(() => _resendSeconds = 30);
    _resendOtpTimer?.cancel();
    _resendOtpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds == 0) {
        timer.cancel();
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  void onSendOtp(BuildContext context) {
    if (fullPhoneNumber == null || fullPhoneNumber!.isEmpty) {
      showSnackBar('Enter a valid phone number');
      return;
    }

    context.read<LoginBloc>().add(SendOtpEvent(phoneNumber: fullPhoneNumber!));
    startResendOtpTimer();
  }

  void onVerifyOtp(BuildContext context) {
    final otp = otpController.text.trim();

    if (otp.isEmpty) {
      showSnackBar('Please enter OTP');
      return;
    }

    context.read<LoginBloc>().add(VerifyOtpEvent(otp: otp));
  }

  void onChangeNumber() {
    setState(() {
      otpSent = false;
      fullPhoneNumber = null;
      otpController.clear();
      _resendOtpTimer?.cancel();
      _resendSeconds = 30;
    });
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: Palette.primary,
      ),
    );
  }

  Widget buildPhoneField() {
    return IntlPhoneField(
      decoration: InputDecoration(
        labelText: 'Phone Number',
        labelStyle: TextStyle(color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Palette.primary, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
      ),
      initialCountryCode: 'IN',
      keyboardType: TextInputType.phone,
      style: const TextStyle(fontSize: 16),
      onChanged: (phone) {
        fullPhoneNumber = phone.completeNumber;
      },
    );
  }

  Widget buildOtpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Back button and phone number display
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Palette.primary),
                onPressed: onChangeNumber,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Sending OTP to: $fullPhoneNumber',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        
        // OTP input title
        const Text(
          'Enter OTP',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Palette.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        
        // Pinput widget
        Pinput(
          length: 6,
          controller: otpController,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          submittedPinTheme: submittedPinTheme,
          pinAnimationType: PinAnimationType.scale,
          onCompleted: (pin) => onVerifyOtp(context),
          showCursor: true,
          cursor: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                width: 22,
                height: 2,
                color: Palette.primary,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildResendOtpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_resendSeconds == 0)
          TextButton(
            onPressed: () => onSendOtp(context),
            style: TextButton.styleFrom(
              foregroundColor: Palette.primary,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              'Resend OTP',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          )
        else
          Center(
            child: Text(
              'Resend OTP in $_resendSeconds seconds',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
      ],
    );
  }

  Widget buildSubmitButton(LoginState state) {
    if (state is LoginLoadingState) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Palette.primary),
        ),
      );
    }

    return ElevatedButton(
      onPressed: () {
        if (!otpSent) {
          onSendOtp(context);
        } else {
          onVerifyOtp(context);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Palette.primary,
        foregroundColor: Palette.white,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      child: Text(otpSent ? 'Verify OTP' : 'Send OTP'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              // Background logo
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Palette.primary.withOpacity(0.1),
                        Palette.white.withOpacity(0.9),
                      ],
                    ),
                  ),
                ),
              ),

              // Main content
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),

                    // Header section
                    Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Palette.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.phone_iphone_outlined,
                            size: 48,
                            color: Palette.primary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Login with Phone',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Palette.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Enter your phone number to receive OTP',
                          style: TextStyle(fontSize: 14, color: Palette.black),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Form in a card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (!otpSent) buildPhoneField(),
                            if (otpSent) buildOtpSection(),
                            const SizedBox(height: 16),
                            BlocConsumer<LoginBloc, LoginState>(
                              listener: (context, state) {
                                if (state is OtpSentState) {
                                  setState(() => otpSent = true);
                                  showSnackBar('OTP sent successfully');
                                }
                                if (state is LoginSuccessState) {
                                  Navigator.pushReplacementNamed(context, AppRoutes.boothDashboard);
                                } else if (state is LoginFailedState) {
                                  showSnackBar(state.error);
                                }
                              },
                              builder: (context, state) => buildSubmitButton(state),
                            ),
                            if (otpSent) buildResendOtpSection(),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Terms and conditions
                    if (!otpSent)
                      const Text(
                        'By continuing, you agree to our Terms of Service and Privacy Policy',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}