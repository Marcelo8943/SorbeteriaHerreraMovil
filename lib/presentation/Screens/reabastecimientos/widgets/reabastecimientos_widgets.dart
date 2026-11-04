import 'package:flutter/material.dart';
import 'package:herrera_system/data/models/restock_list_item_model.dart';
import 'package:herrera_system/presentation/routes/app_routes.dart';

import '../../../theme/app_theme.dart';

class ReabastecimientosLista extends StatelessWidget {
  final List<RestockListItemModel> reabastecimientos;

  const ReabastecimientosLista({
    super.key,
    required this.reabastecimientos,
  });

  @override
  Widget build(BuildContext context) {
    if (reabastecimientos.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            'No hay reabastecimientos registrados.',
            style: TextStyle(color: AppColors.muted, fontSize: 13),
          ),
        ),
      );
    }
    return Column(
      children: reabastecimientos
          .map((restock) => _ReabastecimientoCard(restock: restock))
          .toList(),
    );
  }
}

class _ReabastecimientoCard extends StatelessWidget {
  final RestockListItemModel restock;

  const _ReabastecimientoCard({required this.restock});

  @override
  Widget build(BuildContext context) {
    final date = restock.restockDate == null
        ? 'Fecha no disponible'
        : _formatDate(restock.restockDate!.toLocal());
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
            AppRoutes.reabastecimientoDetalle,
            arguments: restock.restockId,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppToneColors.soft[AppTone.purple],
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.local_shipping_outlined,
                    color: AppToneColors.intense[AppTone.purple],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restock.restockCode,
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
                        '${restock.userName} · $date',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${restock.batchCount} lotes · ${restock.totalUnits} unidades',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'C\$${restock.totalInvestment.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
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
