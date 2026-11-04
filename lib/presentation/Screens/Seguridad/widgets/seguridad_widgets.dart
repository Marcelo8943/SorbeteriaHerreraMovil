import 'package:flutter/material.dart';
import 'package:herrera_system/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../../theme/app_theme.dart';

class SecurityAppBar extends StatelessWidget {
  const SecurityAppBar({super.key, required this.onBack});

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
          Text('Seguridad', style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}

class SecurityFormCard extends StatefulWidget {
  const SecurityFormCard({super.key});

  @override
  State<SecurityFormCard> createState() => _SecurityFormCardState();
}

class _SecurityFormCardState extends State<SecurityFormCard> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: AppSpacing.cardShadow,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Cambiar contraseña',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            const Text(
              'Actualiza tu contraseña para mantener segura tu cuenta.',
              style: TextStyle(color: AppColors.muted, fontSize: 12),
            ),
            const SizedBox(height: AppSpacing.lg),
            _passwordField(
              label: 'Contraseña actual',
              controller: _currentPasswordController,
              showPassword: _showCurrentPassword,
              onToggleVisibility: () => setState(
                () => _showCurrentPassword = !_showCurrentPassword,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _passwordField(
              label: 'Nueva contraseña',
              controller: _newPasswordController,
              showPassword: _showNewPassword,
              onToggleVisibility: () => setState(
                () => _showNewPassword = !_showNewPassword,
              ),
              validateNewPassword: true,
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: authProvider.isChangingPassword ? null : _submit,
                icon: authProvider.isChangingPassword
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.shield_outlined, size: 18),
                label: Text(
                  authProvider.isChangingPassword
                      ? 'Actualizando...'
                      : 'Actualizar contraseña',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _passwordField({
    required String label,
    required TextEditingController controller,
    required bool showPassword,
    required VoidCallback onToggleVisibility,
    bool validateNewPassword = false,
  }) {
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
        TextFormField(
          controller: controller,
          obscureText: !showPassword,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.lavender,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14),
            suffixIcon: IconButton(
              onPressed: onToggleVisibility,
              icon: Icon(
                showPassword ? Icons.visibility_off : Icons.visibility,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es obligatorio.';
            }
            if (validateNewPassword && value.length < 8) {
              return 'La nueva contraseña debe tener al menos 8 caracteres.';
            }
            return null;
          },
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<AuthProvider>();
    final changed = await provider.changePassword(
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
    );
    if (!mounted) return;

    final message =
        provider.passwordChangeMessage ??
        (changed
            ? 'Contraseña actualizada.'
            : 'No se pudo cambiar la contraseña.');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: changed ? AppColors.primary : Colors.red,
      ),
    );
    if (changed) {
      _currentPasswordController.clear();
      _newPasswordController.clear();
    }
  }
}
