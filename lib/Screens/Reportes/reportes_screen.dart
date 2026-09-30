import 'package:flutter/material.dart';
import '../../models/dashboard_metrics.dart';
import '../../models/mocks/mock_productos.dart';
import '../../models/mocks/mock_transacciones.dart';
import '../../theme/app_theme.dart';
import '../../widgets/charts/average_ticket_chart.dart';
import '../../widgets/charts/inventory_rotation_chart.dart';
import '../../widgets/charts/sales_by_period_chart.dart';
import '../../widgets/charts/top_products_chart.dart';
import 'widgets/reportes_filtros_bar.dart';

class ReportesScreen extends StatelessWidget {
  const ReportesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: AppColors.ink,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Reportes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ReportesFiltrosBar(),
            SalesByPeriodChart(
              datos: ventasPorPeriodo(
                mockTransacciones,
                agruparPor: (t) => t.fecha.split(',').first,
              ),
            ),
            TopProductsChart(datos: topProductos(mockTransacciones)),
            InventoryRotationChart(
              productos: mockProductos,
              transacciones: mockTransacciones,
            ),
            AverageTicketChart(
              datos: ticketPromedioPorPeriodo(
                mockTransacciones,
                agruparPor: (t) => t.fecha.split(',').first,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
