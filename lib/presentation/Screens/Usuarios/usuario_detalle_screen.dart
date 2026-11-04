import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';
import 'usuario_form_screen.dart';
import 'widgets/usuario_detalle_widgets.dart';

class UsuarioDetalleScreen extends StatefulWidget {
  final UserModel usuario;
  final Color avatarColor;

  const UsuarioDetalleScreen({
    super.key,
    required this.usuario,
    required this.avatarColor,
  });

  @override
  State<UsuarioDetalleScreen> createState() => _UsuarioDetalleScreenState();
}

class _UsuarioDetalleScreenState extends State<UsuarioDetalleScreen> {
  late UserModel _usuario;

  @override
  void initState() {
    super.initState();
    _usuario = widget.usuario;
  }

  Future<void> _openEditForm() async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => UsuarioFormScreen(usuario: _usuario)),
    );
    if (saved != true || !mounted) return;

    try {
      final updated = await context.read<UserProvider>().getById(_usuario.id);
      if (mounted) setState(() => _usuario = updated);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Se guardó el usuario, pero no se pudo recargar: $error')),
        );
      }
    }
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
            UsuarioDetalleHero(usuario: _usuario, avatarColor: widget.avatarColor),
            Transform.translate(
              offset: const Offset(0, -30),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: UsuarioDetalleCardData(usuario: _usuario),
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
                  onPressed: _openEditForm,
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
