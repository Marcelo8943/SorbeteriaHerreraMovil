import 'package:flutter/material.dart';
import 'package:herrera_system/core/constants/view_status.dart';
import 'package:herrera_system/data/models/sale_detail_item_model.dart';
import 'package:herrera_system/data/models/sale_header_detail_model.dart';
import 'package:herrera_system/data/models/sale_payment_model.dart';
import 'package:herrera_system/presentation/providers/sales_provider.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';

class VentaDetalleScreen extends StatefulWidget {
  final int saleId;

  const VentaDetalleScreen({super.key, required this.saleId});

  @override
  State<VentaDetalleScreen> createState() => _VentaDetalleScreenState();
}

class _VentaDetalleScreenState extends State<VentaDetalleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<SalesProvider>().loadSaleDetail(widget.saleId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SalesProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detalle de venta'),
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.ink,
      ),
      body: switch (provider.detailStatus) {
        ViewStatus.initial || ViewStatus.loading =>
          const LoadingView(message: 'Cargando venta...'),
        ViewStatus.error => ErrorView(
          errorMessage: provider.detailError ?? 'No se pudo cargar la venta.',
          onRetry: () => provider.loadSaleDetail(widget.saleId),
        ),
        ViewStatus.success => provider.sale == null
            ? const Center(child: Text('No se encontró la venta.'))
            : _VentaDetalleContent(
                sale: provider.sale!,
                details: provider.details,
                payments: provider.payments,
              ),
      },
    );
  }
}

class _VentaDetalleContent extends StatelessWidget {
  final SaleHeaderDetailModel sale;
  final List<SaleDetailItemModel> details;
  final List<SalePaymentModel> payments;

  const _VentaDetalleContent({
    required this.sale,
    required this.details,
    required this.payments,
  });

  @override
  Widget build(BuildContext context) {
    final date = sale.saleDate == null
        ? 'No disponible'
        : _formatDate(sale.saleDate!.toLocal());
    final customerLocation = [
      sale.customer.departmentName,
      sale.customer.municipalityName,
      sale.customer.pointOfSale,
    ].whereType<String>().where((value) => value.isNotEmpty).join(' · ');

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        _SectionCard(
          title: sale.saleCode,
          children: [
            _InfoRow(label: 'Cliente', value: sale.customer.fullName),
            _InfoRow(label: 'Ubicación', value: customerLocation),
            _InfoRow(label: 'Fecha', value: date),
            _InfoRow(label: 'Tipo de venta', value: sale.saleTypeName),
            _InfoRow(label: 'Método de pago', value: sale.paymentTypeName),
            _InfoRow(label: 'Estado del pago', value: sale.paymentStatusName),
            _InfoRow(label: 'Saldo pendiente', value: _money(sale.pendingBalance)),
            _InfoRow(label: 'Código de pedido', value: sale.orderCode ?? ''),
            _InfoRow(label: 'Registrada por', value: sale.createdByUserName ?? ''),
            _InfoRow(label: 'Total', value: _money(sale.total), emphasize: true),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _SectionCard(
          title: 'Productos',
          children: details.isEmpty
              ? const [Text('Esta venta no tiene productos registrados.')]
              : details.map(_SaleDetailRow.new).toList(),
        ),
        const SizedBox(height: AppSpacing.md),
        _SectionCard(
          title: 'Pagos',
          children: payments.isEmpty
              ? const [Text('Esta venta no tiene pagos registrados.')]
              : payments.map(_PaymentRow.new).toList(),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year} '
      '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}';

  String _money(double? amount) =>
      amount == null ? 'No disponible' : 'C\$${amount.toStringAsFixed(2)}';
}

class _SaleDetailRow extends StatelessWidget {
  final SaleDetailItemModel item;

  const _SaleDetailRow(this.item);

  @override
  Widget build(BuildContext context) {
    return _NestedItem(
      title: item.productName,
      lines: [
        'Lote: ${item.batchCode}',
        'Cantidad: ${item.quantity}',
        'Precio unitario: C\$${item.unitPrice.toStringAsFixed(2)}',
        'Subtotal: C\$${item.lineSubtotal.toStringAsFixed(2)}',
      ],
    );
  }
}

class _PaymentRow extends StatelessWidget {
  final SalePaymentModel payment;

  const _PaymentRow(this.payment);

  @override
  Widget build(BuildContext context) {
    final date = payment.paymentDate == null
        ? ''
        : '${payment.paymentDate!.toLocal().day.toString().padLeft(2, '0')}/'
              '${payment.paymentDate!.toLocal().month.toString().padLeft(2, '0')}/'
              '${payment.paymentDate!.toLocal().year}';
    return _NestedItem(
      title: payment.paymentMethodName,
      lines: [
        if (date.isNotEmpty) 'Fecha: $date',
        'Monto: C\$${payment.amount.toStringAsFixed(2)}',
        if (payment.transactionReference?.isNotEmpty == true)
          'Referencia: ${payment.transactionReference}',
        if (payment.registeredByUserName?.isNotEmpty == true)
          'Registrado por: ${payment.registeredByUserName}',
      ],
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
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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

class _NestedItem extends StatelessWidget {
  final String title;
  final List<String> lines;

  const _NestedItem({required this.title, required this.lines});

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
            title,
            style: const TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          ...lines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                line,
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
