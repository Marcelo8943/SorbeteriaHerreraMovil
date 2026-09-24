import 'package:flutter/material.dart';

import '../../../../theme/app_theme.dart';

class SecurityAppBar extends StatelessWidget {
  const SecurityAppBar({super.key, required this.onBack});

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
          Text('Seguridad', style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}

class SecurityFormCard extends StatelessWidget {
  const SecurityFormCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: AppSpacing.cardShadow,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Cambiar contraseña',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            'Actualiza tu contraseña para mantener segura tu cuenta.',
            style: TextStyle(color: AppColors.muted, fontSize: 12),
          ),
          SizedBox(height: AppSpacing.lg),
          SecurityPasswordField(label: 'Contraseña actual'),
          SizedBox(height: AppSpacing.md),
          SecurityPasswordField(label: 'Nueva contraseña'),
          SizedBox(height: AppSpacing.md),
          SecurityPasswordField(label: 'Confirmar contraseña'),
          SizedBox(height: AppSpacing.lg),
          SecurityUpdateButton(),
        ],
      ),
    );
  }
}

class SecurityPasswordField extends StatelessWidget {
  const SecurityPasswordField({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.lavender,
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ],
    );
  }
}

class SecurityUpdateButton extends StatelessWidget {
  const SecurityUpdateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3300B884),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shield_outlined, color: AppColors.textOnPrimary, size: 18),
          SizedBox(width: AppSpacing.sm),
          Text(
            'Actualizar contraseña',
            style: TextStyle(
              color: AppColors.textOnPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
