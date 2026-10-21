import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'presentation/routes/app_routes.dart';
import 'presentation/theme/app_theme.dart';

Future<void> main() async {
  runApp(const HerreraApp());
  await dotenv.load();
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
