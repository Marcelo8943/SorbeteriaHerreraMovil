import 'package:flutter/material.dart';
import '../../../models/app_models.dart';
import '../../../theme/app_theme.dart';

class TransaccionDetalleHero extends StatelessWidget {
  final Transaccion transaccion;

  const TransaccionDetalleHero({super.key, required this.transaccion});

  @override
  Widget build(BuildContext context) {
    final tone = _toneForType(transaccion.tipo);
    final icon = _iconForType(transaccion.tipo);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16, bottom: 28, left: 20, right: 20),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppToneColors.soft[tone],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: AppToneColors.intense[tone], size: 30),
          ),
          const SizedBox(height: 12),

          Text(
            transaccion.relacionado,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textOnPrimary,
            ),
          ),
          const SizedBox(height: 4),

          Text(
            '${transaccion.tipo} · Folio ${transaccion.folio}',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textOnPrimary.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.textOnPrimary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              transaccion.tipo,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textOnPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppTone _toneForType(String tipo) {
    switch (tipo) {
      case 'Venta':
        return AppTone.teal;
      case 'Pedido':
        return AppTone.blue;
      case 'Reabastecimiento':
      default:
        return AppTone.purple;
    }
  }

  IconData _iconForType(String tipo) {
    switch (tipo) {
      case 'Venta':
        return Icons.attach_money;
      case 'Pedido':
        return Icons.description_outlined;
      case 'Reabastecimiento':
      default:
        return Icons.local_shipping_outlined;
    }
  }
}
