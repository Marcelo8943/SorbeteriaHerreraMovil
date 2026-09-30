import 'package:flutter/material.dart';
import '../../../models/app_models.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_theme.dart';

class TransaccionCard extends StatelessWidget {
  final Transaccion transaccion;

  const TransaccionCard({super.key, required this.transaccion});

  @override
  Widget build(BuildContext context) {
    final tone = _toneForType(transaccion.tipo);
    final icon = _iconForType(transaccion.tipo);
    final subtitle = _buildSubtitle();
    final valueText = _buildValueText();

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: AppSpacing.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.transaccionDetalle,
              arguments: transaccion,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 12,
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
                    icon,
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
                        transaccion.relacionado,
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
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
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
                        transaccion.tipo,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppToneColors.intense[tone],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      valueText,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _buildSubtitle() {
    if (transaccion.tipo == 'Reabastecimiento') {
      final lotesCount = transaccion.items.length;
      return 'Reabastecimiento · $lotesCount lotes · ${transaccion.cantidadTotal} und · ${transaccion.fechaRelativa}';
    } else if (transaccion.tipo == 'Pedido') {
      return 'Pedido · ${transaccion.cantidadTotal} und · ${transaccion.fechaRelativa}';
    } else {
      final tipoVenta = transaccion.tipoVenta ?? 'Detalle';
      return 'Venta · $tipoVenta · ${transaccion.cantidadTotal} und · ${transaccion.fechaRelativa}';
    }
  }

  String _buildValueText() {
    if (transaccion.tipo == 'Reabastecimiento') {
      return '${transaccion.cantidadTotal} und';
    }
    // Formato moneda de córdobas
    final monto = transaccion.monto.toInt();
    if (monto >= 1000) {
      final miles = monto ~/ 1000;
      final resto = (monto % 1000).toString().padLeft(3, '0');
      return 'C\$$miles,$resto';
    }
    return 'C\$$monto';
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
