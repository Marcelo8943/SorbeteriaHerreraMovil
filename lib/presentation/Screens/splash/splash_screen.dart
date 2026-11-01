import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.icecream_outlined,
                color: AppColors.primary,
                size: 42,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Sorbetería Herrera',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.lg),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
