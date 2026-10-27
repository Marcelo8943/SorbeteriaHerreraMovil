import 'package:flutter/material.dart';
import 'package:herrera_system/data/models/business_profile_model.dart';

import '../../../theme/app_theme.dart';

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
  const AboutInformationCard({super.key, required this.profile});

  final BusinessProfileModel profile;

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
          Text(
            profile.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.line),
          const SizedBox(height: AppSpacing.md),
          _AboutDetail(label: 'Teléfono', value: profile.phone),
          const SizedBox(height: AppSpacing.md),
          _AboutDetail(label: 'Dirección', value: profile.address),
          const SizedBox(height: AppSpacing.md),
          _AboutDetail(label: 'Correo', value: profile.email),
        ],
      ),
    );
  }
}

class _AboutDetail extends StatelessWidget {
  const _AboutDetail({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
