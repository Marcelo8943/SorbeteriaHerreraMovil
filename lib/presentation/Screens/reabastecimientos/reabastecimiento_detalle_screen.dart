import 'package:flutter/material.dart';
import 'package:herrera_system/core/constants/view_status.dart';
import 'package:herrera_system/data/models/restock_detail_model.dart';
import 'package:herrera_system/presentation/providers/restocks_provider.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';

class ReabastecimientoDetalleScreen extends StatefulWidget {
  final int restockId;

  const ReabastecimientoDetalleScreen({
    super.key,
    required this.restockId,
  });

  @override
  State<ReabastecimientoDetalleScreen> createState() =>
      _ReabastecimientoDetalleScreenState();
}

class _ReabastecimientoDetalleScreenState
    extends State<ReabastecimientoDetalleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<RestocksProvider>().loadDetail(widget.restockId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RestocksProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detalle de reabastecimiento'),
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.ink,
      ),
      body: switch (provider.detailStatus) {
        ViewStatus.initial || ViewStatus.loading =>
          const LoadingView(message: 'Cargando reabastecimiento...'),
        ViewStatus.error => ErrorView(
          errorMessage: provider.detailError ??
              'No se pudo cargar el reabastecimiento.',
          onRetry: () => provider.loadDetail(widget.restockId),
        ),
        ViewStatus.success => provider.detail == null
            ? const Center(child: Text('No se encontró el reabastecimiento.'))
            : _RestockDetailContent(detail: provider.detail!),
      },
    );
  }
}

class _RestockDetailContent extends StatelessWidget {
  final RestockDetailModel detail;

  const _RestockDetailContent({required this.detail});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        _SectionCard(
          title: detail.restockCode,
          children: [
            _InfoRow(label: 'Fecha', value: _date(detail.restockDate)),
            _InfoRow(label: 'Registrado por', value: detail.userName),
            _InfoRow(label: 'Cantidad de lotes', value: '${detail.batchCount}'),
            _InfoRow(label: 'Productos distintos', value: '${detail.differentProductsCount}'),
            _InfoRow(label: 'Unidades totales', value: '${detail.totalUnits}'),
            _InfoRow(
              label: 'Inversión total',
              value: 'C\$${detail.totalInvestment.toStringAsFixed(2)}',
              emphasize: true,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _SectionCard(
          title: 'Lotes registrados',
          children: detail.batches.isEmpty
              ? const [Text('Este reabastecimiento no tiene lotes registrados.')]
              : detail.batches.map(_BatchItemCard.new).toList(),
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

class _BatchItemCard extends StatelessWidget {
  final RestockDetailBatchModel batch;

  const _BatchItemCard(this.batch);

  @override
  Widget build(BuildContext context) {
    final expiration = batch.expirationDate.toLocal();
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
            batch.productName,
            style: const TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          if (batch.batchCode?.isNotEmpty == true)
            Text('Código de lote: ${batch.batchCode}'),
          Text('Estado: ${batch.batchStatusName}'),
          Text('Cantidad inicial: ${batch.initialQuantity}'),
          Text(
            'Costo por unidad: C\$${batch.unitProductionCost.toStringAsFixed(2)}',
          ),
          Text('Costo total: C\$${batch.totalCost.toStringAsFixed(2)}'),
          Text(
            'Vencimiento: ${expiration.day.toString().padLeft(2, '0')}/'
            '${expiration.month.toString().padLeft(2, '0')}/'
            '${expiration.year}',
          ),
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
