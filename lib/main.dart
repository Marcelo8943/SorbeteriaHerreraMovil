import 'package:flutter/material.dart';

import 'presentation/routes/app_routes.dart';
import 'presentation/theme/app_theme.dart';

void main() {
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
