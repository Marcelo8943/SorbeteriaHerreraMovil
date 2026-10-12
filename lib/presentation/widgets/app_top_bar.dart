import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppBrandLogo extends StatelessWidget {
  final double size;

  const AppBrandLogo({super.key, this.size = 42});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF00684F),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: const Color(0xFF004B39), width: 1.5),
        ),
        child: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Herrera',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              fontFamily: 'serif',
            ),
          ),
        ),
      ),
    );
  }
}

class AppTopBar extends StatelessWidget {
  final String subtitle;
  final String? userInitials;
  final VoidCallback? onAvatarTap;
  final Widget? trailing;

  const AppTopBar({
    super.key,
    required this.subtitle,
    this.userInitials,
    this.onAvatarTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 12,
      ),
      color: AppColors.lavender,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const AppBrandLogo(),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sorbetería Herrera',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.ink,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing ??
              GestureDetector(
                onTap: onAvatarTap,
                child: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  child: Text(
                    userInitials ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
