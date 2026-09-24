import 'package:flutter/material.dart';

import '../../../../theme/app_theme.dart';

class AboutAppBar extends StatelessWidget {
  const AboutAppBar({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      color: AppColors.lavender,
      child: Row(
        children: [
          IconButton(
            tooltip: 'Volver',
            onPressed: onBack,
            icon: const Icon(Icons.chevron_left_rounded),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text('Acerca de', style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}

class AboutInformationCard extends StatelessWidget {
  const AboutInformationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: AppSpacing.cardShadow,
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppToneColors.soft[AppTone.teal],
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Sorbetería Herrera App',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Versión 2.2.0',
            style: TextStyle(color: AppColors.muted, fontSize: 12),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Prototipo móvil de monitoreo y análisis gerencial. '
            'Hecho en familia, gestionado de forma inteligente.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, fontSize: 12, height: 1.45),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Divider(color: AppColors.line),
          const SizedBox(height: AppSpacing.md),
          const Text(
            '© 2026 Sorbetería Herrera',
            style: TextStyle(color: AppColors.muted, fontSize: 10.5),
          ),
        ],
      ),
    );
  }
}
