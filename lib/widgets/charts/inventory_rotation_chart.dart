import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../models/dashboard_metrics.dart';
import '../../theme/app_theme.dart';

class InventoryRotationChart extends StatelessWidget {
  final List<Producto> productos;
  final List<Transaccion> transacciones;

  const InventoryRotationChart({
    super.key,
    required this.productos,
    required this.transacciones,
  });

  @override
  Widget build(BuildContext context) {
    final rotacion = rotacionInventario(transacciones, productos);

    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rotación de inventario',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.ink),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppToneColors.soft[AppTone.teal],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.sync_rounded,
                      color: AppToneColors.intense[AppTone.teal],
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${rotacion.toStringAsFixed(1)}x',
                    style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'veces que rotó el inventario en el período',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: AppColors.muted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
