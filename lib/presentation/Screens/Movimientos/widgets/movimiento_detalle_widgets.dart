import 'package:flutter/material.dart';
import 'package:herrera_system/data/models/inventory_movement_detail_item_model.dart';
import 'package:herrera_system/data/models/inventory_movement_header_model.dart';

import '../../../theme/app_theme.dart';

class MovimientoHeaderCard extends StatelessWidget {
  const MovimientoHeaderCard({super.key, required this.header});

  final InventoryMovementHeaderModel header;

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
          Row(
            children: [
              Expanded(
                child: Text(
                  header.movementTypeName.isEmpty
                      ? 'Movimiento de inventario'
                      : header.movementTypeName,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ),
              _MovementIdBadge(id: header.id),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          MovimientoInfoRow(
            icon: Icons.calendar_today_outlined,
            value: header.dateLabel,
          ),
          if (_hasText(header.createdByUserName)) ...[
            const SizedBox(height: AppSpacing.sm),
            MovimientoInfoRow(
              icon: Icons.person_outline,
              value: header.createdByUserName!,
            ),
          ],
          if (_hasText(header.notes)) ...[
            const SizedBox(height: AppSpacing.sm),
            MovimientoInfoRow(icon: Icons.notes_outlined, value: header.notes!),
          ],
          if (header.saleId != null || header.orderId != null) ...[
            const SizedBox(height: AppSpacing.sm),
            MovimientoInfoRow(
              icon: Icons.tag_outlined,
              value: _referenceLabel(header),
            ),
          ],
        ],
      ),
    );
  }

  bool _hasText(String? value) => value != null && value.trim().isNotEmpty;

  String _referenceLabel(InventoryMovementHeaderModel header) {
    if (header.saleId != null) return 'Venta #${header.saleId}';
    return 'Orden #${header.orderId}';
  }
}

class MovimientoDetailItemCard extends StatelessWidget {
  const MovimientoDetailItemCard({super.key, required this.item});

  final InventoryMovementDetailItemModel item;

  @override
  Widget build(BuildContext context) {
    final batch = item.batchCode?.trim();

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
            batch == null || batch.isEmpty ? 'Lote #${item.batchId}' : batch,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          MovimientoInfoRow(
            icon: Icons.location_on_outlined,
            value: item.locationLabel,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: MovimientoValue(
                  label: 'Cantidad',
                  value: '${item.quantity} und',
                ),
              ),
              Expanded(
                child: MovimientoValue(
                  label: 'Costo unitario',
                  value: 'C\$ ${item.unitCost.toStringAsFixed(2)}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MovimientoInfoRow extends StatelessWidget {
  const MovimientoInfoRow({super.key, required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: AppColors.muted),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, color: AppColors.muted),
          ),
        ),
      ],
    );
  }
}

class MovimientoValue extends StatelessWidget {
  const MovimientoValue({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.muted,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
      ],
    );
  }
}

class MovimientoDetalleError extends StatelessWidget {
  const MovimientoDetalleError({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(onPressed: onRetry, child: const Text('Reintentar')),
          ],
        ),
      ),
    );
  }
}

class MovimientoDetalleEmpty extends StatelessWidget {
  const MovimientoDetalleEmpty({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.muted),
        ),
      ),
    );
  }
}

class _MovementIdBadge extends StatelessWidget {
  const _MovementIdBadge({required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
      ),
      child: Text(
        '#$id',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }
}
