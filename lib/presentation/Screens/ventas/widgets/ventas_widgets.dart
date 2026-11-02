import 'package:flutter/material.dart';
import 'package:herrera_system/data/models/sale_list_item_model.dart';
import 'package:herrera_system/presentation/routes/app_routes.dart';

import '../../../theme/app_theme.dart';

class VentasLista extends StatelessWidget {
  final List<SaleListItemModel> ventas;

  const VentasLista({super.key, required this.ventas});

  @override
  Widget build(BuildContext context) {
    if (ventas.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            'No hay ventas registradas.',
            style: TextStyle(color: AppColors.muted, fontSize: 13),
          ),
        ),
      );
    }

    return Column(
      children: ventas.map((sale) => _VentaCard(sale: sale)).toList(),
    );
  }
}

class _VentaCard extends StatelessWidget {
  final SaleListItemModel sale;

  const _VentaCard({required this.sale});

  @override
  Widget build(BuildContext context) {
    final date = sale.saleDate == null
        ? 'Fecha no disponible'
        : _formatDate(sale.saleDate!.toLocal());

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
            AppRoutes.ventaDetalle,
            arguments: sale.id,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppToneColors.soft[AppTone.teal],
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.point_of_sale_outlined,
                    color: AppToneColors.intense[AppTone.teal],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sale.customerName,
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
                        '${sale.saleCode} · ${sale.saleTypeName} · $date',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${sale.paymentTypeName} · ${sale.paymentStatus}',
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
                  _currency(sale.total),
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 14,
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

  String _currency(double amount) => 'C\$${amount.toStringAsFixed(2)}';
}
