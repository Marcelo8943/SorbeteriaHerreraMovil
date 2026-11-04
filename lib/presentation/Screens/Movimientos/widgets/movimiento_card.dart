import 'package:flutter/material.dart';
import 'package:herrera_system/data/models/inventory_movement_model.dart';

import '../../../theme/app_theme.dart';

class MovimientoCard extends StatelessWidget {
  const MovimientoCard({
    super.key,
    required this.movimiento,
    required this.onTap,
  });

  final InventoryMovementModel movimiento;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tone = _toneFor(movimiento.movementTypeName);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 5,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          child: Container(
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
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppToneColors.soft[tone],
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _iconFor(movimiento.movementTypeName),
                    color: AppToneColors.intense[tone],
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movimiento.productLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        _subtitle(),
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
                const SizedBox(width: AppSpacing.sm),
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
                        movimiento.movementTypeName,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppToneColors.intense[tone],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      _quantityLabel(),
                      style: const TextStyle(
                        fontSize: 15,
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

  String _subtitle() {
    final origins = movimiento.sourceLocationNames.join(', ');
    final destinations = movimiento.destinationLocationNames.join(', ');
    final location = origins.isNotEmpty && destinations.isNotEmpty
        ? '$origins → $destinations'
        : origins.isNotEmpty
        ? origins
        : destinations;

    return [
      if (location.isNotEmpty) location,
      movimiento.dateLabel,
    ].join(' · ');
  }

  String _quantityLabel() {
    final isPositive = movimiento.movementTypeName.toLowerCase().contains(
      'positivo',
    );
    final prefix = isPositive ? '+' : '';
    return '$prefix${movimiento.totalQuantity} und';
  }

  AppTone _toneFor(String movementType) {
    final type = movementType.toLowerCase();
    if (type.contains('transfer')) return AppTone.blue;
    if (type.contains('negativo')) return AppTone.red;
    return AppTone.teal;
  }

  IconData _iconFor(String movementType) {
    final type = movementType.toLowerCase();
    if (type.contains('transfer')) return Icons.local_shipping_outlined;
    if (type.contains('negativo')) return Icons.remove_circle_outline;
    return Icons.add_circle_outline;
  }
}
