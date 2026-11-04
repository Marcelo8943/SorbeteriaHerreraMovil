import 'package:flutter/material.dart';
import 'package:herrera_system/core/constants/regular_expresion.dart';
import 'package:herrera_system/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/app_theme.dart';
import 'widgets/login_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final _facebookUri = Uri.parse(
    'https://www.facebook.com/SorbetesHerrera/',
  );

  final _globalKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
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

  Future<void> _login() async {
    final formState = _globalKey.currentState;
    if (formState == null || !formState.validate()) return;

    final username = _userController.text.trim();
    final password = _passwordController.text.trim();

    final authProvider = context.read<AuthProvider>();
    await authProvider.login(
      username: username,
      password: password,
    );

    if (!mounted) return;

    if (!authProvider.isAuthenticated) {
      final errorMessage = authProvider.errorMessage;
      if (errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        )..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
      }
    }
  }

  void _showPasswordRecoveryMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'La recuperación de contraseña estará disponible pronto.',
        ),
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
            child: RefreshIndicator(
              onRefresh: _login,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LoginHero(onLogoTap: _openFacebook),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 18, 14, 0),
                      child: _LoginForm(
                        formKey: _globalKey,
                        userController: _userController,
                        passwordController: _passwordController,
                        hidePassword: _hidePassword,
                        onPasswordVisibilityChanged: () {
                          setState(() => _hidePassword = !_hidePassword);
                        },
                        onLogin: _login,
                        onForgotPassword: _showPasswordRecoveryMessage,
                      ),
                    ),
                  ],
                ),
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
    required this.formKey,
    required this.userController,
    required this.passwordController,
    required this.hidePassword,
    required this.onPasswordVisibilityChanged,
    required this.onLogin,
    required this.onForgotPassword,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController userController;
  final TextEditingController passwordController;
  final bool hidePassword;
  final VoidCallback onPasswordVisibilityChanged;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Form(
      key: formKey,
      child: Column(
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
            validator: (value) {
              final username = value?.trim() ?? '';
              if (username.isEmpty) return 'Ingresa tu usuario';
              if (!CommonRegex.userNameRegex.hasMatch(username)) {
                return 'El usuario debe tener entre 3 y 50 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 13),
          LoginTextField(
            label: 'Contraseña',
            controller: passwordController,
            icon: Icons.shield_outlined,
            obscureText: hidePassword,
            validator: (value) {
              final password = value?.trim() ?? '';
              if (password.isEmpty) return 'Ingresa tu contraseña';
              if (!CommonRegex.passwordRegex.hasMatch(password)) {
                return 'Mínimo 8 caracteres: incluye mayúscula, minúscula, número y un símbolo permitido (@ \$ ! % * ? & o -).';
              }
              return null;
            },
            trailing: IconButton(
              tooltip: hidePassword
                  ? 'Mostrar contraseña'
                  : 'Ocultar contraseña',
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
          LoginButton(
            onPressed: auth.isSubmitting ? null : onLogin,
            isSubmitting: auth.isSubmitting,
          ),
          const SizedBox(height: 18),

          const Center(
            child: Text(
              '© 2026 Sorbetería Herrera.\nTodos los derechos reservados.',
              textAlign: TextAlign.center,
              style: LoginTextStyles.footer,
            ),
          ),
        ],
      ),
    );
  }
}
