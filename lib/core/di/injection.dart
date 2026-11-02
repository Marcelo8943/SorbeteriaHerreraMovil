import 'package:get_it/get_it.dart';
import 'package:herrera_system/core/network/api_client.dart';
import 'package:herrera_system/data/repository/auth_repository.dart';
import 'package:herrera_system/data/repository/business_profile_repository.dart';
import 'package:herrera_system/data/repository/dashboard_repository.dart';
import 'package:herrera_system/data/repository/inventory_movements_repository.dart';
import 'package:herrera_system/data/repository/inventory_repository.dart';
import 'package:herrera_system/data/repository/orders_repository.dart';
import 'package:herrera_system/data/repository/logs_repository.dart';
import 'package:herrera_system/data/repository/precio_repository.dart';
import 'package:herrera_system/data/repository/roles_repository.dart';
import 'package:herrera_system/data/repository/restocks_repository.dart';
import 'package:herrera_system/data/repository/sales_repository.dart';
import 'package:herrera_system/data/repository/token_repository.dart';
import 'package:herrera_system/data/repository/user_repository.dart';
import 'package:herrera_system/presentation/providers/auth_provider.dart';
import 'package:herrera_system/presentation/providers/business_profile_provider.dart';
import 'package:herrera_system/presentation/providers/dashboard_provider.dart';
import 'package:herrera_system/presentation/providers/inventory_movements_provider.dart';
import 'package:herrera_system/presentation/providers/inventory_provider.dart';
import 'package:herrera_system/presentation/providers/orders_provider.dart';
import 'package:herrera_system/presentation/providers/logs_provider.dart';
import 'package:herrera_system/presentation/providers/precio_provider.dart';
import 'package:herrera_system/presentation/providers/roles_provider.dart';
import 'package:herrera_system/presentation/providers/restocks_provider.dart';
import 'package:herrera_system/presentation/providers/sales_provider.dart';
import 'package:herrera_system/presentation/providers/user_form_provider.dart';
import 'package:herrera_system/presentation/providers/user_provider.dart';
import 'package:herrera_system/services/auth_services.dart';
import 'package:herrera_system/services/business_profile_service.dart';
import 'package:herrera_system/services/dashboard_service.dart';
import 'package:herrera_system/services/inventory_movements_service.dart';
import 'package:herrera_system/services/inventory_service.dart';
import 'package:herrera_system/services/orders_service.dart';
import 'package:herrera_system/services/logs_service.dart';
import 'package:herrera_system/services/precio_service.dart';
import 'package:herrera_system/services/roles_service.dart';
import 'package:herrera_system/services/restocks_service.dart';
import 'package:herrera_system/services/sales_service.dart';
import 'package:herrera_system/services/user_service.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<ApiClient>(
    () =>
        ApiClient(authTokenProvider: () => getIt<TokenRepository>().getToken()),
    dispose: (client) => client.dispose(),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<TokenRepository>(() => TokenRepository());
  getIt.registerLazySingleton<BusinessProfileRepository>(
    () => BusinessProfileRepository(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<DashboardRepository>(
    () => DashboardRepository(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<InventoryRepository>(
    () => InventoryRepository(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<OrdersRepository>(
    () => OrdersRepository(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<LogsRepository>(
    () => LogsRepository(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<InventoryMovementsRepository>(
    () => InventoryMovementsRepository(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<PrecioRepository>(
    () => PrecioRepository(getIt<ApiClient>(), getIt<TokenRepository>()),
  );

  getIt.registerLazySingleton<UserRepository>(
    () => UserRepository(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<RolesRepository>(
    () => RolesRepository(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<RestocksRepository>(
    () => RestocksRepository(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<SalesRepository>(
    () => SalesRepository(getIt<ApiClient>()),
  );

  //Register services
  getIt.registerLazySingleton<AuthServices>(
    () => AuthServices(getIt<AuthRepository>(), getIt<TokenRepository>()),
  );
  getIt.registerLazySingleton<BusinessProfileService>(
    () => BusinessProfileService(getIt<BusinessProfileRepository>()),
  );
  getIt.registerLazySingleton<DashboardService>(
    () => DashboardService(getIt<DashboardRepository>()),
  );
  getIt.registerLazySingleton<InventoryService>(
    () => InventoryService(getIt<InventoryRepository>()),
  );
  getIt.registerLazySingleton<OrdersService>(
    () => OrdersService(getIt<OrdersRepository>()),
  );
  getIt.registerLazySingleton<LogsService>(
    () => LogsService(getIt<LogsRepository>()),
  );
  getIt.registerLazySingleton<InventoryMovementsService>(
    () => InventoryMovementsService(getIt<InventoryMovementsRepository>()),
  );
  getIt.registerLazySingleton<PrecioService>(
    () => PrecioService(getIt<PrecioRepository>()),
  );

  getIt.registerLazySingleton<UserService>(
    () => UserService(getIt<UserRepository>()),
  );
  getIt.registerLazySingleton<RoleService>(
    () => RoleService(getIt<RolesRepository>()),
  );
  getIt.registerLazySingleton<RestocksService>(
    () => RestocksService(getIt<RestocksRepository>()),
  );
  getIt.registerLazySingleton<SalesService>(
    () => SalesService(getIt<SalesRepository>()),
  );

  //Register providers
  getIt.registerLazySingleton<AuthProvider>(
    () => AuthProvider(getIt<AuthServices>()),
  );
  getIt.registerLazySingleton<BusinessProfileProvider>(
    () => BusinessProfileProvider(getIt<BusinessProfileService>()),
  );
  getIt.registerFactory<DashboardProvider>(
    () => DashboardProvider(getIt<DashboardService>()),
  );
  getIt.registerFactory<LogsProvider>(
    () => LogsProvider(getIt<LogsService>()),
  );
  getIt.registerLazySingleton<InventoryProvider>(
    () => InventoryProvider(getIt<InventoryService>()),
  );
  getIt.registerFactory<OrdersProvider>(
    () => OrdersProvider(getIt<OrdersService>()),
  );
  getIt.registerLazySingleton<InventoryMovementsProvider>(
    () => InventoryMovementsProvider(getIt<InventoryMovementsService>()),
  );
  getIt.registerFactory<PrecioProvider>(
    () => PrecioProvider(getIt<PrecioService>()),
  );

  getIt.registerFactory<UserProvider>(() => UserProvider(getIt<UserService>()));
  getIt.registerFactory<UserFormProvider>(
    () => UserFormProvider(getIt<UserService>()),
  );
  getIt.registerFactory<RolesProvider>(
    () => RolesProvider(getIt<RoleService>()),
  );
  getIt.registerFactory<SalesProvider>(
    () => SalesProvider(getIt<SalesService>()),
  );
  getIt.registerFactory<RestocksProvider>(
    () => RestocksProvider(getIt<RestocksService>()),
  );
}
