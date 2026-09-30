import 'package:flutter/material.dart';
import '../../../models/app_models.dart';
import '../../../theme/app_theme.dart';

class MovimientoCard extends StatelessWidget {
  final Movimiento movimiento;

  const MovimientoCard({super.key, required this.movimiento});

  @override
  Widget build(BuildContext context) {
    final tone = _getTone(movimiento.tipo);
    final icon = _getIcon(movimiento.tipo);
    final subtitle = _buildSubtitle();
    final quantityText = _buildQuantityText();

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

          // ── Información central ──────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movimiento.producto,
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
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppToneColors.soft[tone],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  movimiento.tipo,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppToneColors.intense[tone],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                quantityText,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _buildSubtitle() {
    if (movimiento.tipo == 'Transferencia') {
      final orig = movimiento.origen ?? 'Bodega';
      final dest = movimiento.destino ?? 'Mostrador';
      return 'Transferencia · $orig → $dest · ${movimiento.fechaRelativa}';
    } else {
      final ubi = movimiento.ubicacion ?? 'Bodega';
      return '${movimiento.tipo} · $ubi · ${movimiento.fechaRelativa}';
    }
  }

  String _buildQuantityText() {
    if (movimiento.tipo == 'Ajuste Positivo') {
      return '+${movimiento.cantidad} und';
    }
    return '${movimiento.cantidad} und';
  }

  AppTone _getTone(String tipo) {
    switch (tipo) {
      case 'Transferencia':
        return AppTone.blue;
      case 'Ajuste Negativo':
        return AppTone.red;
      case 'Ajuste Positivo':
      default:
        return AppTone.teal;
    }
  }

  IconData _getIcon(String tipo) {
    switch (tipo) {
      case 'Transferencia':
        return Icons.local_shipping_outlined;
      case 'Ajuste Negativo':
        return Icons.error_outline;
      case 'Ajuste Positivo':
      default:
        return Icons.add;
    }
  }
}
