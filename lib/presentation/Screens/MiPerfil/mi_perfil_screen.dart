import 'package:flutter/material.dart';

import '../../models/mocks/mock_usuarios.dart';
import '../../session.dart';
import '../../theme/app_theme.dart';
import 'widgets/mi_perfil_widgets.dart';

class MiPerfilScreen extends StatelessWidget {
  const MiPerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = Session.usuarioActual ?? mockUsuarios.first;
    final nameParts = usuario.nombre.split(' ');
    final firstName = nameParts.first;
    final lastName = nameParts.skip(1).join(' ');

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
                  child: SingleChildScrollView(
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
                          username: usuario.usuario,
                          role: usuario.rol,
                          firstName: firstName,
                          lastName: lastName,
                          email: usuario.correo,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
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
