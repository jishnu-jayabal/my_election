import 'package:election_mantra/api/repository/user_repository.dart';
import 'package:election_mantra/api/service/firebase/firebase_user_service.dart';
import 'package:election_mantra/core/api_bridge.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependency() async {
  getIt.registerFactory<UserRepository>(() => FirebaseUserService());
  getIt.registerFactory<ApiBridge>(() => ApiBridge());
}
