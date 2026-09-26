import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../theme/app_theme.dart';
import '../../../models/dashboard_metrics.dart';

class TopProductsChart extends StatelessWidget {
  final List<ProductoVendido> datos;

  const TopProductsChart({super.key, required this.datos});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Productos más vendidos',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.ink),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: datos.isEmpty
                ? const Center(
                    child: Text(
                      'Sin datos suficientes',
                      style: TextStyle(color: AppColors.muted),
                    ),
                  )
                : BarChart(_buildChartData()),
          ),
        ],
      ),
    );
  }

  BarChartData _buildChartData() {
    final groups = <BarChartGroupData>[
      for (int i = 0; i < datos.length; i++)
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: datos[i].cantidad.toDouble(),
              color: AppColors.primary,
              width: 14,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
    ];

    return BarChartData(
      gridData: const FlGridData(show: false),
      titlesData: FlTitlesData(
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= datos.length) return const SizedBox();
              final nombre = datos[index].nombre;
              final etiqueta =
                  nombre.length > 8 ? '${nombre.substring(0, 8)}...' : nombre;
              return Text(
                etiqueta,
                style: const TextStyle(fontSize: 10, color: AppColors.muted),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      barGroups: groups,
    );
  }
}
