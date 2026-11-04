import 'package:flutter/material.dart';
import 'package:herrera_system/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import 'widgets/mi_perfil_widgets.dart';

class MiPerfilScreen extends StatelessWidget {
  const MiPerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              children: [
                ProfileAppBar(onBack: () => Navigator.of(context).maybePop()),
                Expanded(
                  child: user == null
                      ? const Center(
                          child: Text(
                            'No se pudo cargar la información del usuario.',
                            style: TextStyle(color: AppColors.muted),
                          ),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.md,
                            AppSpacing.lg,
                            AppSpacing.md,
                            AppSpacing.xl,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Visualiza tu información personal y nivel de acceso.',
                                style: TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              UserInformationCard(
                                username: user.userName,
                                role: user.roleName,
                                firstName: user.firstName,
                                lastName: user.lastName,
                                email: user.email,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                ),
                                child: Text(
                                  'Para modificar tu información contacta a administración.',
                                  style: TextStyle(
                                    color: AppColors.muted,
                                    fontSize: 12,
                                  ),
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
