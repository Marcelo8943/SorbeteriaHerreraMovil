import 'package:flutter/material.dart';
import 'package:herrera_system/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../routes/app_routes.dart';
import '../../../session.dart';
import '../../theme/app_theme.dart';
import 'widgets/conf_widgets.dart';

class ConfiguracionesScreen extends StatelessWidget {
  const ConfiguracionesScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final navigator = Navigator.of(context);
    final auth = context.read<AuthProvider>();
    await auth.logout();
    Session.cerrarSesion();
    navigator.pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final userName = user?.fullName ?? 'Usuario';
    final userRole = user?.roleName ?? 'Usuario';
    final userInitials = user?.initials.isNotEmpty == true
        ? user!.initials
        : 'U';

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
                          name: userName,
                          description: user == null
                              ? userRole
                              : '$userRole · ${user.email}',
                          initials: userInitials,
                          onTap: () => Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.miPerfil),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        const ConfigurationSectionLabel('ADMINISTRACIÓN'),
                        const SizedBox(height: AppSpacing.sm),
                        ConfigurationOptionTile(
                          icon: Icons.storefront_outlined,
                          iconBackground: AppToneColors.soft[AppTone.yellow]!,
                          iconColor: AppToneColors.intense[AppTone.yellow]!,
                          title: 'Datos del Negocio',
                          subtitle: 'Nombre, dirección y contacto',
                          onTap: () => Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.datosNegocio),
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
                          onTap: () => Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.seguridad),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        const SizedBox(height: AppSpacing.xl),
                        LogoutButton(onPressed: () async => _logout(context)),
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
