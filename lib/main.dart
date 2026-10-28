import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:herrera_system/core/di/injection.dart';
import 'package:herrera_system/presentation/providers/auth_provider.dart';
import 'package:herrera_system/presentation/providers/business_profile_provider.dart';
import 'package:herrera_system/presentation/providers/inventory_provider.dart';
import 'package:herrera_system/presentation/providers/inventory_movements_provider.dart';
import 'package:provider/provider.dart';

import 'presentation/routes/app_routes.dart';
import 'presentation/theme/app_theme.dart';

Future<void> main() async {
  await dotenv.load();
  setupDependencies();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<AuthProvider>()),
        ChangeNotifierProvider(
          create: (_) => getIt<BusinessProfileProvider>(),
        ),
        ChangeNotifierProvider(create: (_) => getIt<InventoryProvider>()),
        ChangeNotifierProvider(
          create: (_) => getIt<InventoryMovementsProvider>(),
        ),
      ],
      child: const HerreraApp(),
    ),
  );
}

class HerreraApp extends StatelessWidget {
  const HerreraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sorbetería Herrera',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
