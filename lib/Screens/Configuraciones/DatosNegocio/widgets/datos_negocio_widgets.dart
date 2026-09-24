import 'package:flutter/material.dart';

import '../../../../models/app_models.dart';
import '../../../../theme/app_theme.dart';

class BusinessAppBar extends StatelessWidget {
  const BusinessAppBar({super.key, required this.onBack});

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
            'Datos del Negocio',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}

class BusinessInformationCard extends StatelessWidget {
  const BusinessInformationCard({super.key, required this.negocio});

  final Negocio negocio;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: AppSpacing.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BusinessTextField(label: 'Nombre del negocio', value: negocio.nombre),
          const SizedBox(height: AppSpacing.md),
          BusinessTextField(label: 'Eslogan', value: negocio.eslogan),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: BusinessDataItem(
                  label: 'DIRECCIÓN',
                  value: negocio.direccion,
                ),
              ),
              Expanded(
                child: BusinessDataItem(
                  label: 'TELÉFONO',
                  value: negocio.telefono,
                ),
              ),
            ],
          ),
          const Divider(height: AppSpacing.lg, color: AppColors.line),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppToneColors.soft[AppTone.blue],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFF3B76F0),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: BusinessDataItem(
                  label: 'CORREO',
                  value: negocio.correo,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const BusinessSaveButton(),
        ],
      ),
    );
  }
}

class BusinessTextField extends StatelessWidget {
  const BusinessTextField({super.key, required this.label, required this.value});

  final String label;
  final String value;

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
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: AppColors.lavender,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class BusinessDataItem extends StatelessWidget {
  const BusinessDataItem({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 9,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class BusinessSaveButton extends StatelessWidget {
  const BusinessSaveButton({super.key});

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
          Icon(Icons.check_rounded, color: AppColors.textOnPrimary, size: 18),
          SizedBox(width: AppSpacing.sm),
          Text(
            'Guardar cambios',
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
