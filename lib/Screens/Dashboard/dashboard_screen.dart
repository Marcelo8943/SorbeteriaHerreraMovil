import 'package:flutter/material.dart';
import 'package:herrera_system/models/mocks/mock_productos.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/h_stat_card.dart';
import '../../models/app_models.dart';
import '../../models/mocks/mock_transacciones.dart';
import '../../models/dashboard_metrics.dart';

import 'widgets/greeting_banner.dart';

import 'widgets/recent_transactions_list.dart';
import 'widgets/sales_by_period_chart.dart';
import 'widgets/top_products_chart.dart';
import 'widgets/average_ticket_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const userName = 'Marcelo';
    const userRole = 'Administrador';
    const userInitials = 'MA';
    const fechaFormateada = 'domingo, 16 de agosto de 2026';

    final List<Transaccion> transacciones = mockTransacciones;
    final List<Producto> productos = mockProductos;

    final ventasDiarias = ventasPorPeriodo(
      transacciones,
      agruparPor: (t) => t.fecha.split(',').first,
    );

    final ticketHoy = ticketPromedio(transacciones);

    final ventasHoy = transacciones
        .where((t) => t.tipo == 'Venta')
        .fold<double>(0, (sum, t) => sum + t.monto);

    final pedidosPendientes = transacciones
        .where((t) => t.tipo == 'Pedido' && t.estado == 'Pendiente')
        .length;

    final stockCritico = productos
        .where((p) => p.stockActual <= p.stockMinimo)
        .length;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppTopBar(
            subtitle: 'Hecho en familia',
            userInitials: userInitials,
          ),
          const SizedBox(height: AppSpacing.md),

          const GreetingBanner(
            userName: userName,
            userRole: userRole,
            fechaFormateada: fechaFormateada,
          ),
          const SizedBox(height: AppSpacing.md),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.4,
              children: [
                HStatCard(
                  title: 'Ventas del día',
                  value: 'C\$${ventasHoy.toStringAsFixed(0)}',
                  bgColor: AppToneColors.soft[AppTone.teal]!,
                  iconColor: AppToneColors.intense[AppTone.teal]!,
                  icon: Icons.attach_money,
                ),
                HStatCard(
                  title: 'Pedidos pendientes',
                  value: '$pedidosPendientes',
                  bgColor: AppToneColors.soft[AppTone.blue]!,
                  iconColor: AppToneColors.intense[AppTone.blue]!,
                  icon: Icons.description_outlined,
                ),
                HStatCard(
                  title: 'Stock crítico',
                  value: '$stockCritico',
                  bgColor: AppToneColors.soft[AppTone.red]!,
                  iconColor: AppToneColors.intense[AppTone.red]!,
                  icon: Icons.warning_amber_rounded,
                ),
                HStatCard(
                  title: 'Ticket promedio',
                  value: 'C\$${ticketHoy.toStringAsFixed(0)}',
                  bgColor: AppToneColors.soft[AppTone.yellow]!,
                  iconColor: AppToneColors.intense[AppTone.yellow]!,
                  icon: Icons.receipt_long_outlined,
                ),
              ],
            ),
          ),

          SalesByPeriodChart(datos: ventasDiarias),
          TopProductsChart(datos: topProductos(transacciones)),
          AverageTicketChart(
            datos: ticketPromedioPorPeriodo(
              transacciones,
              agruparPor: (t) => t.fecha.split(',').first,
            ),
          ),

          RecentTransactionsList(
            transacciones: transacciones,
            onVerTodo: () {},
          ),
        ],
      ),
    );
  }
}
