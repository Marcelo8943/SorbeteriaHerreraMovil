import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

/// Banner verde de saludo, exclusivo del Dashboard — no se repite en
/// ninguna otra pantalla, así que vive aquí y no en lib/widgets/.
class GreetingBanner extends StatelessWidget {
  final String userName;
  final String userRole;
  final String fechaFormateada; // ej. "domingo, 16 de agosto de 2026"

  const GreetingBanner({
    super.key,
    required this.userName,
    required this.userRole,
    required this.fechaFormateada,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00C48F), Color(0xFF007A58)],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Hola, $userName! 👋',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$fechaFormateada · $userRole',
                  style: const TextStyle(color: Colors.white70, fontSize: 11.5),
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Herrera',
                style: TextStyle(
                  color: Color(0xFF00684F),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'serif',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
