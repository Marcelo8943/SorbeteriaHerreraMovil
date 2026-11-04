import 'package:flutter/material.dart';
import 'package:herrera_system/data/models/order_list_item_model.dart';
import 'package:herrera_system/presentation/routes/app_routes.dart';

import '../../../theme/app_theme.dart';

class PedidosLista extends StatelessWidget {
  final List<OrderListItemModel> pedidos;

  const PedidosLista({super.key, required this.pedidos});

  @override
  Widget build(BuildContext context) {
    if (pedidos.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            'No hay pedidos registrados.',
            style: TextStyle(color: AppColors.muted, fontSize: 13),
          ),
        ),
      );
    }
    return Column(
      children: pedidos.map((order) => _PedidoCard(order: order)).toList(),
    );
  }
}

class _PedidoCard extends StatelessWidget {
  final OrderListItemModel order;

  const _PedidoCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final registrationDate = order.registrationDate == null
        ? 'Fecha no disponible'
        : _formatDate(order.registrationDate!.toLocal());
    final deliveryDate = order.estimatedDeliveryDate == null
        ? ''
        : 'Entrega estimada: ${_formatDate(order.estimatedDeliveryDate!.toLocal())}';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: AppSpacing.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          onTap: () => Navigator.of(context).pushNamed(
            AppRoutes.pedidoDetalle,
            arguments: order.id,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppToneColors.soft[AppTone.blue],
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.description_outlined,
                    color: AppToneColors.intense[AppTone.blue],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.customerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${order.orderCode} · $registrationDate',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                        ),
                      ),
                      if (deliveryDate.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          deliveryDate,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 11,
                          ),
                        ),
                      ],
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
                        color: AppToneColors.soft[AppTone.blue],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        order.orderStatusName,
                        style: TextStyle(
                          color: AppToneColors.intense[AppTone.blue],
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'C\$${order.totalOrder.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
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

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';
}
