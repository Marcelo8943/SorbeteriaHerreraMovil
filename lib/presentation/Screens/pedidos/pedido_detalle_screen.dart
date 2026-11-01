import 'package:flutter/material.dart';
import 'package:herrera_system/core/constants/view_status.dart';
import 'package:herrera_system/data/models/order_detail_item_model.dart';
import 'package:herrera_system/data/models/order_detail_model.dart';
import 'package:herrera_system/presentation/providers/orders_provider.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';

class PedidoDetalleScreen extends StatefulWidget {
  final int orderId;

  const PedidoDetalleScreen({super.key, required this.orderId});

  @override
  State<PedidoDetalleScreen> createState() => _PedidoDetalleScreenState();
}

class _PedidoDetalleScreenState extends State<PedidoDetalleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted)
        context.read<OrdersProvider>().loadOrderDetail(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrdersProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detalle de pedido'),
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.ink,
      ),
      body: switch (provider.detailStatus) {
        ViewStatus.initial ||
        ViewStatus.loading => const LoadingView(message: 'Cargando pedido...'),
        ViewStatus.error => ErrorView(
          errorMessage: provider.detailError ?? 'No se pudo cargar el pedido.',
          onRetry: () => provider.loadOrderDetail(widget.orderId),
        ),
        ViewStatus.success =>
          provider.order == null
              ? const Center(child: Text('No se encontró el pedido.'))
              : _PedidoDetalleContent(order: provider.order!),
      },
    );
  }
}

class _PedidoDetalleContent extends StatelessWidget {
  final OrderDetailModel order;

  const _PedidoDetalleContent({required this.order});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        _SectionCard(
          title: order.orderCode,
          children: [
            _InfoRow(label: 'Cliente', value: order.customerName),
            _InfoRow(label: 'Estado', value: order.orderStatusName),
            _InfoRow(
              label: 'Fecha de registro',
              value: _date(order.registrationDate),
            ),
            _InfoRow(
              label: 'Entrega estimada',
              value: _date(order.estimatedDeliveryDate),
            ),
            _InfoRow(
              label: 'Entrega realizada',
              value: _date(order.actualDeliveryDate),
            ),
            _InfoRow(label: 'Registrado por', value: order.createdByUserName),
            _InfoRow(
              label: 'Total',
              value: 'C\$${order.totalOrder.toStringAsFixed(2)}',
              emphasize: true,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _SectionCard(
          title: 'Productos solicitados',
          children: order.details.isEmpty
              ? const [Text('Este pedido no tiene productos registrados.')]
              : order.details
                    .map<Widget>((item) => _OrderDetailRow(item))
                    .toList(),
        ),
      ],
    );
  }

  String _date(DateTime? value) {
    if (value == null) return 'No disponible';
    final date = value.toLocal();
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

class _OrderDetailRow extends StatelessWidget {
  final OrderDetailItemModel item;

  const _OrderDetailRow(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.productName,
            style: const TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text('Cantidad solicitada: ${item.quantityRequested}'),
          Text('Precio aplicado: C\$${item.appliedPrice.toStringAsFixed(2)}'),
          if (item.batchCode?.isNotEmpty == true)
            Text('Lote: ${item.batchCode}'),
          Text('Subtotal: C\$${item.lineSubtotal.toStringAsFixed(2)}'),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: AppSpacing.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasize;

  const _InfoRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: AppColors.muted)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: AppColors.ink,
                fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
