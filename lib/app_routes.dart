import 'package:election_mantra/presentation/pages/booth_agent_dashboard_page.dart';
import 'package:election_mantra/presentation/pages/login_page.dart';
import 'package:election_mantra/presentation/pages/splash_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  //common

  static const splash = '/';
  static const login = '/login';
  static const boothDashboard = '/boothDashboard';

  static final routes = <String, WidgetBuilder>{
    //common
    splash: (context) => const SplashPage(),
    login: (context) => const LoginPage(),
    boothDashboard:(context)=> BoothAgentDashboard(),
  };
}
