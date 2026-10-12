import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../models/app_models.dart';

/// Lista de las últimas transacciones, con encabezado y "Ver todo →".
/// Exclusivo del Dashboard.
class RecentTransactionsList extends StatelessWidget {
  final List<Transaccion> transacciones;
  final VoidCallback onVerTodo;
  final int limite;

  const RecentTransactionsList({
    super.key,
    required this.transacciones,
    required this.onVerTodo,
    this.limite = 5,
  });

  @override
  Widget build(BuildContext context) {
    final recientes = transacciones.take(limite).toList();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transacciones recientes',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.ink),
              ),
              GestureDetector(
                onTap: onVerTodo,
                child: const Text(
                  'Ver todo →',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final t in recientes) _TransaccionRow(transaccion: t),
        ],
      ),
    );
  }
}

class _TransaccionRow extends StatelessWidget {
  final Transaccion transaccion;

  const _TransaccionRow({required this.transaccion});

  @override
  Widget build(BuildContext context) {
    final tone = AppToneColors.forTransactionType(transaccion.tipo);
    final icon = switch (transaccion.tipo) {
      'Venta' => Icons.attach_money,
      'Pedido' => Icons.description_outlined,
      _ => Icons.sync_alt,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppToneColors.soft[tone],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppToneColors.intense[tone], size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaccion.relacionado,
                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: AppColors.ink),
                ),
                Text(
                  '${transaccion.tipo} · ${transaccion.cantidadTotal} und · ${transaccion.fechaRelativa}',
                  style: const TextStyle(fontSize: 11, color: AppColors.muted),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppToneColors.soft[tone],
                  borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
                ),
                child: Text(
                  transaccion.tipo,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppToneColors.intense[tone]),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'C\$${transaccion.monto.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.ink),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
