import 'package:get_it/get_it.dart';
import 'package:herrera_system/core/network/api_client.dart';
import 'package:herrera_system/data/repository/auth_repository.dart';
import 'package:herrera_system/data/repository/token_repository.dart';
import 'package:herrera_system/presentation/providers/auth_provider.dart';
import 'package:herrera_system/services/auth_services.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(),
    dispose: (client) => client.dispose(),
  );

  //Register repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<TokenRepository>(() => TokenRepository());

  //Register services
  getIt.registerLazySingleton<AuthServices>(
    () => AuthServices(getIt<AuthRepository>(), getIt<TokenRepository>()),
  );

  //Register providers
  getIt.registerLazySingleton<AuthProvider>(
    () => AuthProvider(getIt<AuthServices>()),
  );
}
