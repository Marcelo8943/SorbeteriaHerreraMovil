import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/h_stat_card.dart';

class InventarioStatsRow extends StatelessWidget {
  final int stockBajoCount;

  final int lotesPorVencer;

  const InventarioStatsRow({
    super.key,
    required this.stockBajoCount,
    required this.lotesPorVencer,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          HStatCard(
            title: 'Stock bajo',
            value: stockBajoCount.toString(),
            bgColor: AppToneColors.soft[AppTone.red]!,
            iconColor: AppToneColors.intense[AppTone.red]!,
            icon: Icons.warning_amber_rounded,
          ),
          const SizedBox(width: AppSpacing.md),
          HStatCard(
            title: 'Lotes por vencer',
            value: lotesPorVencer.toString(),
            bgColor: AppToneColors.soft[AppTone.yellow]!,
            iconColor: AppToneColors.intense[AppTone.yellow]!,
            icon: Icons.hourglass_bottom_rounded,
          ),
        ],
      ),
    );
  }
}
