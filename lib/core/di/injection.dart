import 'package:get_it/get_it.dart';
import 'package:herrera_system/core/network/api_client.dart';
import 'package:herrera_system/data/repository/auth_repository.dart';
import 'package:herrera_system/data/repository/business_profile_repository.dart';
import 'package:herrera_system/data/repository/inventory_movements_repository.dart';
import 'package:herrera_system/data/repository/inventory_repository.dart';
import 'package:herrera_system/data/repository/precio_repository.dart';
import 'package:herrera_system/data/repository/token_repository.dart';
import 'package:herrera_system/presentation/providers/auth_provider.dart';
import 'package:herrera_system/presentation/providers/business_profile_provider.dart';
import 'package:herrera_system/presentation/providers/inventory_movements_provider.dart';
import 'package:herrera_system/presentation/providers/inventory_provider.dart';
import 'package:herrera_system/presentation/providers/precio_provider.dart';
import 'package:herrera_system/services/auth_services.dart';
import 'package:herrera_system/services/business_profile_service.dart';

import 'package:herrera_system/presentation/providers/inventory_movements_provider.dart';

import 'package:herrera_system/services/inventory_movements_service.dart';
import 'package:herrera_system/services/inventory_service.dart';
import 'package:herrera_system/services/precio_service.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(),
    dispose: (client) => client.dispose(),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<TokenRepository>(() => TokenRepository());
  getIt.registerLazySingleton<BusinessProfileRepository>(
    () => BusinessProfileRepository(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<InventoryRepository>(
    () => InventoryRepository(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<InventoryMovementsRepository>(
    () => InventoryMovementsRepository(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<PrecioRepository>(
    () => PrecioRepository(getIt<ApiClient>(), getIt<TokenRepository>()),
  );

  getIt.registerLazySingleton<AuthServices>(
    () => AuthServices(getIt<AuthRepository>(), getIt<TokenRepository>()),
  );
  getIt.registerLazySingleton<BusinessProfileService>(
    () => BusinessProfileService(getIt<BusinessProfileRepository>()),
  );
  getIt.registerLazySingleton<InventoryService>(
    () => InventoryService(getIt<InventoryRepository>()),
  );
  getIt.registerLazySingleton<InventoryMovementsService>(
    () => InventoryMovementsService(getIt<InventoryMovementsRepository>()),
  );
  getIt.registerLazySingleton<PrecioService>(
    () => PrecioService(getIt<PrecioRepository>()),
  );

  getIt.registerLazySingleton<AuthProvider>(
    () => AuthProvider(getIt<AuthServices>()),
  );
  getIt.registerLazySingleton<BusinessProfileProvider>(
    () => BusinessProfileProvider(getIt<BusinessProfileService>()),
  );
  getIt.registerLazySingleton<InventoryProvider>(
    () => InventoryProvider(getIt<InventoryService>()),
  );
  getIt.registerLazySingleton<InventoryMovementsProvider>(
    () => InventoryMovementsProvider(getIt<InventoryMovementsService>()),
  );
  getIt.registerFactory<PrecioProvider>(
    () => PrecioProvider(getIt<PrecioService>()),
  );
}
