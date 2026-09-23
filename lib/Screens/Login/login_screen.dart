import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import 'login_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final _facebookUri = Uri.parse(
    'https://www.facebook.com/SorbetesHerrera/',
  );

  final _userController = TextEditingController(text: 'Marcelo');
  final _passwordController = TextEditingController(text: 'herrera');
  bool _hidePassword = true;

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _openFacebook() async {
    final didOpen = await launchUrl(
      _facebookUri,
      mode: LaunchMode.externalApplication,
    );

    if (!didOpen && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo abrir la página de Facebook.'),
        ),
      );
    }
  }

  void _showPendingLoginMessage() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.shell);
  }

  void _showPasswordRecoveryMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('La recuperación de contraseña estará disponible pronto.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LoginColors.background,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LoginHero(onLogoTap: _openFacebook),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 18, 14, 0),
                    child: _LoginForm(
                      userController: _userController,
                      passwordController: _passwordController,
                      hidePassword: _hidePassword,
                      onPasswordVisibilityChanged: () {
                        setState(() => _hidePassword = !_hidePassword);
                      },
                      onLogin: _showPendingLoginMessage,
                      onForgotPassword: _showPasswordRecoveryMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.userController,
    required this.passwordController,
    required this.hidePassword,
    required this.onPasswordVisibilityChanged,
    required this.onLogin,
    required this.onForgotPassword,
  });

  final TextEditingController userController;
  final TextEditingController passwordController;
  final bool hidePassword;
  final VoidCallback onPasswordVisibilityChanged;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Iniciar Sesión', style: LoginTextStyles.heading),
        const SizedBox(height: 2),
        const Text(
          'Ingresa tus credenciales para continuar.',
          style: LoginTextStyles.description,
        ),
        const SizedBox(height: 17),
        LoginTextField(
          label: 'Usuario',
          controller: userController,
          icon: Icons.person_outline_rounded,
        ),
        const SizedBox(height: 13),
        LoginTextField(
          label: 'Contraseña',
          controller: passwordController,
          icon: Icons.shield_outlined,
          obscureText: hidePassword,
          trailing: IconButton(
            tooltip: hidePassword ? 'Mostrar contraseña' : 'Ocultar contraseña',
            onPressed: onPasswordVisibilityChanged,
            icon: Icon(
              hidePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: LoginColors.fieldIcon,
              size: 20,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: onForgotPassword,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            child: const Text('¿Olvidó su contraseña?'),
          ),
        ),
        const SizedBox(height: 8),
        LoginButton(onPressed: onLogin),
        const SizedBox(height: 18),
        const Center(
          child: Text(
            '© 2026 Sorbetería Herrera.\nTodos los derechos reservados.',
            textAlign: TextAlign.center,
            style: LoginTextStyles.footer,
          ),
        ),
      ],
    );
  }
}
