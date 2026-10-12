import 'package:flutter/material.dart';
import '../../../models/app_models.dart';
import '../../../theme/app_theme.dart';

class LogCard extends StatelessWidget {
  final LogEvento log;

  const LogCard({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    final tone = AppToneColors.forLogType(log.tipo);
    final icon = _iconForType(log.tipo);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 5,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: AppSpacing.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppToneColors.soft[tone],
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppToneColors.intense[tone], size: 20),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.descripcion,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${log.usuario} · ${log.modulo} · ${log.fechaRelativa}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // ── Badge de tipo de evento ───────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppToneColors.soft[tone],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              log.tipo,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppToneColors.intense[tone],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForType(String tipo) {
    switch (tipo) {
      case 'Creación':
        return Icons.add;
      case 'Edición':
        return Icons.edit_outlined;
      case 'Desactivación':
        return Icons.close;
      case 'Inicio de sesión':
      default:
        return Icons.lock_outline;
    }
  }
}
