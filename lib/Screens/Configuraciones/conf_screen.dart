import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import 'conf_widgets.dart';

class ConfiguracionesScreen extends StatelessWidget {
  const ConfiguracionesScreen({super.key});

  void _logout(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              children: [
                ConfigurationAppBar(
                  onBack: () => Navigator.of(context).maybePop(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      12,
                      AppSpacing.md,
                      AppSpacing.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ConfigurationProfileCard(
                          name: 'Marcelo Mena',
                          description: 'Administrador · Marcelomena@gmail.com',
                          initials: 'MM',
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        const ConfigurationSectionLabel('ADMINISTRACIÓN'),
                        const SizedBox(height: AppSpacing.sm),
                        ConfigurationOptionTile(
                          icon: Icons.storefront_outlined,
                          iconBackground: AppToneColors.soft[AppTone.yellow]!,
                          iconColor: AppToneColors.intense[AppTone.yellow]!,
                          title: 'Datos del Negocio',
                          subtitle: 'Nombre, eslogan y contacto',
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        const ConfigurationSectionLabel('SISTEMA'),
                        const SizedBox(height: AppSpacing.sm),
                        ConfigurationOptionTile(
                          icon: Icons.shield_outlined,
                          iconBackground: AppToneColors.soft[AppTone.blue]!,
                          iconColor: AppToneColors.intense[AppTone.blue]!,
                          title: 'Seguridad',
                          subtitle: 'Cambiar contraseña',
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        ConfigurationOptionTile(
                          icon: Icons.info_outline_rounded,
                          iconBackground: AppColors.lavender,
                          iconColor: AppColors.muted,
                          title: 'Acerca de',
                          subtitle: 'Sorbetería Herrera App v2.2.0',
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        LogoutButton(onPressed: () => _logout(context)),
                        const SizedBox(height: 44),
                        const Text(
                          '© 2026 Sorbetería Herrera · v2.2.0',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
