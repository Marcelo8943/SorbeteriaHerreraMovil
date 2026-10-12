import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../theme/app_theme.dart';
import 'usuario_form_screen.dart';
import 'widgets/usuario_detalle_widgets.dart';

class UsuarioDetalleScreen extends StatelessWidget {
  final Usuario usuario;
  final Color avatarColor;

  const UsuarioDetalleScreen({
    super.key,
    required this.usuario,
    required this.avatarColor,
  });

  void _openEditForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UsuarioFormScreen(usuario: usuario)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.lavender,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Detalle del Usuario'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            UsuarioDetalleHero(usuario: usuario, avatarColor: avatarColor),
            Transform.translate(
              offset: const Offset(0, -30),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: UsuarioDetalleCardData(usuario: usuario),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.lg,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => _openEditForm(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        color: AppColors.textOnPrimary,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Editar usuario',
                        style: TextStyle(
                          color: AppColors.textOnPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
