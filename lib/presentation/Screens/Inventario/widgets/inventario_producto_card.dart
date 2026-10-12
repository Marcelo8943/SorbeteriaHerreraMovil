import 'package:flutter/material.dart';
import '../../../models/app_models.dart';
import '../../../theme/app_theme.dart';

class InventarioProductoCard extends StatelessWidget {
  final InventarioProducto producto;

  const InventarioProductoCard({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
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
          // ── Texto principal ──────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre del producto
                Text(
                  producto.nombreProducto,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                // Desglose por ubicación
                Text(
                  'Bodega ${producto.stockBodega} · '
                  'Reserva ${producto.stockReservado} · '
                  'Mostrador ${producto.stockMostrador}',
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _InventarioBadge(stockBajo: producto.stockBajo),
              const SizedBox(height: 6),

              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: producto.stockTotal.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    const TextSpan(
                      text: ' und',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InventarioBadge extends StatelessWidget {
  final bool stockBajo;
  const _InventarioBadge({required this.stockBajo});

  @override
  Widget build(BuildContext context) {
    final AppTone tone = stockBajo ? AppTone.red : AppTone.teal;
    final String label = stockBajo ? 'Stock bajo' : 'OK';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppToneColors.soft[tone],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppToneColors.intense[tone],
        ),
      ),
    );
  }
}
