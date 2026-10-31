import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:herrera_system/core/di/injection.dart';
import 'package:herrera_system/presentation/providers/auth_provider.dart';
import 'package:herrera_system/presentation/providers/business_profile_provider.dart';
import 'package:herrera_system/presentation/providers/inventory_provider.dart';
import 'package:herrera_system/presentation/providers/inventory_movements_provider.dart';
import 'package:herrera_system/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'presentation/routes/app_routes.dart';
import 'presentation/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  setupDependencies();

  getIt<AuthProvider>().checkSession();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<BusinessProfileProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<BusinessProfileProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<InventoryProvider>()),
        ChangeNotifierProvider(
          create: (_) => getIt<InventoryMovementsProvider>(),
        ),
        ChangeNotifierProvider(create: (_) => getIt<UserProvider>()),
      ],
      child: const HerreraApp(),
    ),
  );
}

class HerreraApp extends StatefulWidget {
  const HerreraApp({super.key});

  @override
  State<HerreraApp> createState() => _HerreraAppState();
}

class _HerreraAppState extends State<HerreraApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final AuthProvider _authProvider = getIt<AuthProvider>();
  AuthStatus _routedStatus = AuthStatus.unknown;

  @override
  void initState() {
    super.initState();
    _authProvider.addListener(_onAuthChange);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onAuthChange());
  }

  void _onAuthChange() {
    final authStatus = _authProvider.authStatus;
    final navigator = _navigatorKey.currentState;

    if (authStatus == AuthStatus.unknown ||
        authStatus == _routedStatus ||
        navigator == null) {
      return;
    }

    _routedStatus = authStatus;
    final route = authStatus == AuthStatus.authenticated
        ? AppRoutes.shell
        : AppRoutes.login;

    navigator.pushNamedAndRemoveUntil(route, (_) => false);
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onAuthChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Sorbetería Herrera',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
