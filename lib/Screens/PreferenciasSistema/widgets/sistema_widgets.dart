import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

class SistemaAppBar extends StatelessWidget {
  const SistemaAppBar({super.key, required this.onBack});

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
          Text(
            'Preferencias del Sistema',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}

class GlobalMonitoringCard extends StatelessWidget {
  const GlobalMonitoringCard({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferenceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          PreferenceTitle(
            title: 'Umbrales globales de monitoreo',
            description:
                'Base para alertas cuando un producto no tiene umbral propio.',
          ),
          SizedBox(height: AppSpacing.lg),
          PreferenceLabel(
            label: 'Umbral global de stock bajo (und)',
            reference: 'RF30',
          ),
          SizedBox(height: AppSpacing.sm),
          PreferenceValueField(value: '10'),
          SizedBox(height: AppSpacing.md),
          PreferenceLabel(
            label: 'Días para alertar vencimiento de lotes',
            reference: 'RF31',
          ),
          SizedBox(height: AppSpacing.sm),
          PreferenceValueField(value: '15'),
          SizedBox(height: AppSpacing.md),
          PreferenceLabel(
            label: 'Unidades de visualización del panel',
            reference: 'RF32',
          ),
          SizedBox(height: AppSpacing.sm),
          PreferenceValueField(value: 'Unidades (und)', showsArrow: true),
          SizedBox(height: AppSpacing.lg),
          PreferencePrimaryButton(label: 'Guardar preferencias'),
        ],
      ),
    );
  }
}

class ProductThresholdCard extends StatelessWidget {
  const ProductThresholdCard({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferenceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          PreferenceTitle(
            title: 'Umbral de stock bajo por producto',
            description:
                'Sobrescribe el umbral global para productos específicos.',
            reference: 'RF30',
          ),
          SizedBox(height: AppSpacing.lg),
          PreferenceLabel(label: 'Producto'),
          SizedBox(height: AppSpacing.sm),
          PreferenceValueField(
            value: 'Sorbete Tradicional Albaricoque 4 Onzas',
            showsArrow: true,
          ),
          SizedBox(height: AppSpacing.md),
          PreferenceLabel(label: 'Umbral personalizado (und)'),
          SizedBox(height: AppSpacing.sm),
          PreferenceValueField(value: 'Ej. 20', isPlaceholder: true),
          SizedBox(height: AppSpacing.lg),
          PreferenceSecondaryButton(),
          SizedBox(height: AppSpacing.lg),
          Text(
            'Sin umbrales personalizados: se aplica el umbral global a todos los productos.',
            style: TextStyle(color: AppColors.muted, fontSize: 13, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class PreferenceCard extends StatelessWidget {
  const PreferenceCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: AppSpacing.cardShadow,
      ),
      child: child,
    );
  }
}

class PreferenceTitle extends StatelessWidget {
  const PreferenceTitle({
    super.key,
    required this.title,
    required this.description,
    this.reference,
  });

  final String title;
  final String description;
  final String? reference;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            if (reference != null) PreferenceReference(reference: reference!),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.35),
        ),
      ],
    );
  }
}

class PreferenceLabel extends StatelessWidget {
  const PreferenceLabel({super.key, required this.label, this.reference});

  final String label;
  final String? reference;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (reference != null) PreferenceReference(reference: reference!),
      ],
    );
  }
}

class PreferenceReference extends StatelessWidget {
  const PreferenceReference({super.key, required this.reference});

  final String reference;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.lavender,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Text(
        reference,
        style: const TextStyle(
          color: AppColors.muted,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class PreferenceValueField extends StatelessWidget {
  const PreferenceValueField({
    super.key,
    required this.value,
    this.showsArrow = false,
    this.isPlaceholder = false,
  });

  final String value;
  final bool showsArrow;
  final bool isPlaceholder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.lavender,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isPlaceholder ? AppColors.muted : AppColors.ink,
                fontSize: 14,
                fontWeight: isPlaceholder ? FontWeight.w500 : FontWeight.w600,
              ),
            ),
          ),
          if (showsArrow)
            const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.muted),
        ],
      ),
    );
  }
}

class PreferencePrimaryButton extends StatelessWidget {
  const PreferencePrimaryButton({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_rounded, color: AppColors.textOnPrimary),
          const SizedBox(width: AppSpacing.sm),
          Text(label, style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }
}

class PreferenceSecondaryButton extends StatelessWidget {
  const PreferenceSecondaryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.add_rounded, color: AppColors.muted),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Asignar umbral',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.muted,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
