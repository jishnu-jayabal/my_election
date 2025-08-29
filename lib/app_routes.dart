import 'package:election_mantra/api/models/voter_details.dart';
import 'package:election_mantra/presentation/pages/age_wise_page.dart';
import 'package:election_mantra/presentation/pages/booth_agent_dashboard_page.dart';
import 'package:election_mantra/presentation/pages/edit_voter_details_page.dart';
import 'package:election_mantra/presentation/pages/login_page.dart';
import 'package:election_mantra/presentation/pages/religion_wise_page.dart';
import 'package:election_mantra/presentation/pages/splash_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const boothDashboard = '/boothDashboard';
  static const editVoterDetails = '/editVoterDetails';
  static const ageWiseStatsView = '/ageWiseStatsView';
  static const religionWiseStatsView = '/religionWiseStatsView';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case boothDashboard:
        return MaterialPageRoute(builder: (_) => BoothAgentDashboard());
      case ageWiseStatsView:
        return MaterialPageRoute(builder: (_) => const AgeWisePage());
      case religionWiseStatsView:
        return MaterialPageRoute(builder: (_) => const ReligionWisePage());
      case editVoterDetails:
        final args = settings.arguments as EditVoterDetailsArguments;
        return MaterialPageRoute(
          builder: (_) => EditVoterDetailsPage(voter: args.voter),
        );
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}

// Create an arguments class
class EditVoterDetailsArguments {
  final VoterDetails voter;

  EditVoterDetailsArguments({required this.voter});
}
