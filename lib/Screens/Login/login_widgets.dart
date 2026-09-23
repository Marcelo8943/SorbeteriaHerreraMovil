import 'dart:math' as math;

import 'package:flutter/material.dart';

abstract final class LoginColors {
  static const background = Color(0xFFF1F3F9);
  static const primary = Color(0xFF00BB8C);
  static const primaryDark = Color(0xFF00906F);
  static const logoGreen = Color(0xFF00684F);
  static const text = Color(0xFF1D2638);
  static const description = Color(0xFF596A8D);
  static const fieldBackground = Color(0xFFE8EBF5);
  static const fieldIcon = Color(0xFF8492B1);
}

abstract final class LoginTextStyles {
  static const heading = TextStyle(
    color: LoginColors.text,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static const description = TextStyle(
    color: LoginColors.description,
    fontSize: 12,
  );

  static const footer = TextStyle(
    color: LoginColors.description,
    fontSize: 10,
    height: 1.45,
  );
}

class LoginHero extends StatelessWidget {
  const LoginHero({super.key, required this.onLogoTap});

  final VoidCallback onLogoTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: SizedBox(
        height: 236,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Positioned.fill(child: _HeroBackground()),
            const Positioned(
              left: -82,
              top: -48,
              child: _DecorativeCircle(
                size: 190,
                color: Color(0x2BFFFFFF),
              ),
            ),
            const Positioned(
              right: -67,
              bottom: -74,
              child: _DecorativeCircle(
                size: 188,
                color: Color(0x26004F3D),
              ),
            ),
            _HeroContent(onLogoTap: onLogoTap),
          ],
        ),
      ),
    );
  }
}

class _HeroBackground extends StatelessWidget {
  const _HeroBackground();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF08BF91), LoginColors.primaryDark],
        ),
      ),
    );
  }
}

class _HeroContent extends StatelessWidget {
  const _HeroContent({required this.onLogoTap});

  final VoidCallback onLogoTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0x36FFFFFF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'APP DE GESTIÓN',
            style: TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: 10),
        _FacebookLogo(onTap: onLogoTap),
        const SizedBox(height: 13),
        const Text(
          'Sorbetería Herrera',
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        const Text(
          'Accede al panel de administración y administra\n'
          'clientes, productos, sabores y más.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 11, height: 1.45),
        ),
      ],
    );
  }
}

class _FacebookLogo extends StatelessWidget {
  const _FacebookLogo({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Abrir Facebook de Sorbetería Herrera',
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Transform.rotate(
          angle: -0.10,
          child: Container(
            width: 90,
            height: 90,
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(23),
            ),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: LoginColors.logoGreen,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: const Color(0xFF004B39),
                  width: 2,
                ),
              ),
              child: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Herrera',
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'serif',
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  const _DecorativeCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: math.pi / 8,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}

class LoginTextField extends StatelessWidget {
  const LoginTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    this.obscureText = false,
    this.trailing,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final bool obscureText;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: LoginColors.text,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(
            color: LoginColors.text,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: LoginColors.fieldBackground,
            prefixIcon: Icon(icon, color: LoginColors.fieldIcon, size: 19),
            suffixIcon: trailing,
            contentPadding: const EdgeInsets.symmetric(vertical: 13),
            border: _inputBorder(),
            enabledBorder: _inputBorder(),
            focusedBorder: _inputBorder(
              color: LoginColors.primary,
              width: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _inputBorder({Color color = Colors.transparent, double width = 0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: LoginColors.primary,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: const Color(0x5500B889),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ingresar al sistema',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward_rounded, size: 21),
          ],
        ),
      ),
    );
  }
}
