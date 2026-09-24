import 'package:flutter/material.dart';

import '../../../../theme/app_theme.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
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
          Text('Mi Perfil', style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}

class UserInformationCard extends StatelessWidget {
  const UserInformationCard({
    super.key,
    required this.username,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  final String username;
  final String role;
  final String firstName;
  final String lastName;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Información del Usuario',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'Esta información identifica tu actividad dentro del sistema.',
            style: TextStyle(color: AppColors.muted, fontSize: 12),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: ProfileDataItem(
                  label: 'NOMBRE DE USUARIO',
                  value: username,
                ),
              ),
              Expanded(child: ProfileDataItem(label: 'ROL', value: role)),
            ],
          ),
          const Divider(height: AppSpacing.lg, color: AppColors.line),
          Row(
            children: [
              Expanded(
                child: ProfileDataItem(
                  label: 'PRIMER NOMBRE',
                  value: firstName,
                ),
              ),
              Expanded(
                child: ProfileDataItem(label: 'APELLIDO', value: lastName),
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
                child: ProfileDataItem(
                  label: 'CORREO ELECTRÓNICO',
                  value: email,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileDataItem extends StatelessWidget {
  const ProfileDataItem({super.key, required this.label, required this.value});

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
