import 'package:election_mantra/app_routes.dart';
import 'package:election_mantra/core/dependency.dart';
import 'package:election_mantra/presentation/blocs/age_group_stats/age_group_stats_bloc.dart';
import 'package:election_mantra/presentation/blocs/login/login_bloc.dart';
import 'package:election_mantra/presentation/blocs/party_list/party_list_bloc.dart';
import 'package:election_mantra/presentation/blocs/party_stats/party_stats_bloc.dart';
import 'package:election_mantra/presentation/blocs/religion/religion_bloc.dart';
import 'package:election_mantra/presentation/blocs/religion_group_stats/religion_group_stats_bloc.dart';
import 'package:election_mantra/presentation/blocs/voters_list/voters_list_bloc.dart';
import 'package:election_mantra/presentation/blocs/voters_recent/voters_recent_bloc.dart';
import 'package:election_mantra/presentation/blocs/voters_stats/voters_stats_bloc.dart';
import 'package:election_mantra/presentation/cubit/cubit/filter_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true);
  } catch (e) {
    print("Firebase initialization error: $e");
  }
  await setupDependency();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getTemporaryDirectory()).path,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
      BlocProvider<VotersListBloc>(create: (context) => VotersListBloc()),
      BlocProvider<VotersRecentBloc>(create: (context) => VotersRecentBloc()),
      BlocProvider<VotersStatsBloc>(create: (context) => VotersStatsBloc()),
      BlocProvider<PartyStatsBloc>(create: (context) => PartyStatsBloc()),
      BlocProvider<PartyListBloc>(create: (context) => PartyListBloc()),
      BlocProvider<AgeGroupStatsBloc>(create: (context) => AgeGroupStatsBloc()),
      BlocProvider<ReligionGroupStatsBloc>(create: (context) => ReligionGroupStatsBloc()),
      BlocProvider<ReligionBloc>(create: (context) => ReligionBloc()),
      BlocProvider<FilterCubit>(create: (context) => FilterCubit()),
      ],
      child: MaterialApp(
        title: 'Election Mantra',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
