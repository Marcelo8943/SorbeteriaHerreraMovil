import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/h_stat_card.dart';

class MovimientosStatsRow extends StatelessWidget {
  final int movimientosHoy;
  final int transferenciasHoy;
  final int ajustesHoy;

  const MovimientosStatsRow({
    super.key,
    required this.movimientosHoy,
    required this.transferenciasHoy,
    required this.ajustesHoy,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          HStatCard(
            title: 'Movimientos hoy',
            value: movimientosHoy.toString(),
            bgColor: AppToneColors.soft[AppTone.teal]!,
            iconColor: AppToneColors.intense[AppTone.teal]!,
            icon: Icons.swap_horiz,
          ),
          const SizedBox(width: AppSpacing.md),
          HStatCard(
            title: 'Transferencias hoy',
            value: transferenciasHoy.toString(),
            bgColor: AppToneColors.soft[AppTone.blue]!,
            iconColor: AppToneColors.intense[AppTone.blue]!,
            icon: Icons.local_shipping_outlined,
          ),
          const SizedBox(width: AppSpacing.md),
          HStatCard(
            title: 'Ajustes hoy',
            value: ajustesHoy.toString(),
            bgColor: AppToneColors.soft[AppTone.red]!,
            iconColor: AppToneColors.intense[AppTone.red]!,
            icon: Icons.error_outline,
          ),
        ],
      ),
    );
  }
}
