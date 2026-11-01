import 'package:flutter/material.dart';
import 'package:herrera_system/data/models/dashboard_stats_model.dart';
import 'package:herrera_system/presentation/theme/app_theme.dart';
import 'package:herrera_system/presentation/widgets/h_stat_card.dart';

class DashboardStatsCards extends StatelessWidget {
  final DashboardStatsModel stats;
  final bool compact;

  const DashboardStatsCards({
    super.key,
    required this.stats,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) return _buildCompactStats();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _statsSection('Productos', [
          _card('Productos registrados', '${stats.products.total}', Icons.inventory_2_outlined, AppTone.teal),
          _card('Productos activos', '${stats.products.activos}', Icons.check_circle_outline, AppTone.blue),
        ]),
        _statsSection('Clientes', [
          _card('Clientes activos', '${stats.customers.activos}', Icons.people_outline, AppTone.teal),
          _card('Municipios con clientes', '${stats.customers.municipios}', Icons.location_city_outlined, AppTone.blue),
          _card('Puntos de venta activos', '${stats.customers.puntosVentaActivos}', Icons.storefront_outlined, AppTone.purple),
        ]),
        _statsSection('Inventario', [
          _card('Productos en inventario', '${stats.inventory.totalProducts}', Icons.category_outlined, AppTone.blue),
          _card('Unidades disponibles', '${stats.inventory.totalUnits}', Icons.inventory_outlined, AppTone.teal),
          _card('Productos con stock bajo', '${stats.inventory.lowStockProducts}', Icons.warning_amber_rounded, AppTone.red),
          _card('Lotes por vencer', '${stats.inventory.expiringLots}', Icons.event_busy_outlined, AppTone.yellow),
          _card('Valor del inventario', 'C\$${stats.inventory.inventoryValue.toStringAsFixed(0)}', Icons.payments_outlined, AppTone.purple),
          if (stats.inventory.bestSellingFlavorName != null)
            _card('Sabor más vendido', stats.inventory.bestSellingFlavorName!, Icons.local_dining_outlined, AppTone.teal),
          if (stats.inventory.bestSellingFlavorName != null)
            _card('Unidades del sabor', '${stats.inventory.bestSellingFlavorQuantity}', Icons.trending_up, AppTone.blue),
        ]),
        _statsSection('Ventas del mes', [
          _card('Ventas realizadas', '${stats.sales.salesThisMonth}', Icons.point_of_sale_outlined, AppTone.teal),
          _card('Ingresos', 'C\$${stats.sales.totalIncomeThisMonth.toStringAsFixed(0)}', Icons.attach_money, AppTone.yellow),
          _card('Productos vendidos', '${stats.sales.productsSoldThisMonth}', Icons.shopping_bag_outlined, AppTone.blue),
        ]),
        _statsSection('Movimientos de hoy', [
          _card('Movimientos', '${stats.movements.movementsToday}', Icons.swap_horiz, AppTone.blue),
          _card('Reabastecimientos', '${stats.movements.restocksToday}', Icons.add_box_outlined, AppTone.teal),
          _card('Transferencias', '${stats.movements.transfersToday}', Icons.compare_arrows, AppTone.purple),
          _card('Ajustes positivos', '${stats.movements.positiveAdjustmentsToday}', Icons.trending_up, AppTone.teal),
          _card('Ajustes negativos', '${stats.movements.negativeAdjustmentsToday}', Icons.trending_down, AppTone.red),
        ]),
      ],
    );
  }

  Widget _buildCompactStats() {
    final cards = [
      _card('Productos activos', '${stats.products.activos}', Icons.check_circle_outline, AppTone.blue),
      _card('Clientes activos', '${stats.customers.activos}', Icons.people_outline, AppTone.teal),
      _card('Productos con stock bajo', '${stats.inventory.lowStockProducts}', Icons.warning_amber_rounded, AppTone.red),
      _card('Lotes por vencer', '${stats.inventory.expiringLots}', Icons.event_busy_outlined, AppTone.yellow),
      _card('Ventas realizadas', '${stats.sales.salesThisMonth}', Icons.point_of_sale_outlined, AppTone.teal),
      _card('Ingresos', 'C\$${stats.sales.totalIncomeThisMonth.toStringAsFixed(0)}', Icons.attach_money, AppTone.yellow),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.1,
        children: cards,
      ),
    );
  }

  Widget _statsSection(String title, List<Widget> cards) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.md, bottom: 10),
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.1,
            children: cards,
          ),
        ],
      ),
    );
  }

  Widget _card(String title, String value, IconData icon, AppTone tone) {
    return HStatCard(
      title: title,
      value: value,
      icon: icon,
      bgColor: AppToneColors.soft[tone]!,
      iconColor: AppToneColors.intense[tone]!,
    );
  }
}
