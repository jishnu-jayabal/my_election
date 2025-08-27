import 'package:election_mantra/app_routes.dart';
import 'package:election_mantra/core/constant/assets.dart';
import 'package:election_mantra/core/constant/palette.dart';
import 'package:election_mantra/presentation/blocs/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LoginBloc>(context).add(CheckIfAlreadyLoggedIn());

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          Navigator.pushReplacementNamed(context, AppRoutes.boothDashboard);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      },
      child: Scaffold(
        backgroundColor: Palette.primary, // Change background color if needed
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(), // Pushes icon to center
              Center(child: Image.asset(Assets.logo)),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.only(bottom: 32),
                child: CircularProgressIndicator(
                  color: Palette.textPrimary,
                ), // Loading at bottom
              ),
            ],
          ),
        ),
      ),
    );
  }
}
