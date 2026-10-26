import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:herrera_system/core/di/injection.dart';

import 'presentation/routes/app_routes.dart';
import 'presentation/theme/app_theme.dart';

Future<void> main() async {
  await dotenv.load();
  setupDependencies();
  runApp(const HerreraApp());
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
