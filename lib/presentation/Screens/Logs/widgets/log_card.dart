import 'package:flutter/material.dart';

import '../../../../data/models/log_model.dart';
import '../../../theme/app_theme.dart';

class LogCard extends StatelessWidget {
  final LogModel log;
  final VoidCallback onTap;

  const LogCard({super.key, required this.log, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tone = log.success ? AppTone.teal : AppTone.red;
    final user = log.userName.isNotEmpty ? log.userName : log.userId;
    final timestamp = log.timestamp.toLocal();
    final date =
        '${timestamp.day.toString().padLeft(2, '0')}/'
        '${timestamp.month.toString().padLeft(2, '0')}/'
        '${timestamp.year} '
        '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 5,
      ),
      child: Material(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 12,
            ),
            decoration: BoxDecoration(
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
                  child: Icon(
                    _iconForType(log.tipo),
                    color: AppToneColors.intense[tone],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _actionName(log.tipo),
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
                        '$user · ${log.modulo} · $date',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppToneColors.soft[tone],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${log.success ? 'Exitoso' : 'Fallido'} · ${log.statusCode}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppToneColors.intense[tone],
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

  String _actionName(String type) {
    switch (type) {
      case 'Creación':
        return 'Crear';
      case 'Edición':
        return 'Actualizar';
      case 'Cambio de estado':
        return 'Cambiar estado';
      case 'Eliminación':
        return 'Eliminar';
      case 'Inicio de sesión':
        return 'Inicio de sesión';
      case 'Consulta':
        return 'Consultar';
      default:
        return type;
    }
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'Creación':
        return Icons.add;
      case 'Edición':
      case 'Cambio de estado':
        return Icons.edit_outlined;
      case 'Inicio de sesión':
        return Icons.lock_outline;
      case 'Eliminación':
        return Icons.delete_outline;
      default:
        return Icons.visibility_outlined;
    }
  }
}
