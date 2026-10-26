import 'package:flutter/material.dart';
import '../../../../data/models/app_models.dart';
import '../../../theme/app_theme.dart';
import '../../transacciones/widgets/transaccion_card.dart';

class ReabastecimientosLista extends StatelessWidget {
  final List<Transaccion> reabastecimientos;

  const ReabastecimientosLista({super.key, required this.reabastecimientos});

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
          .map(
            (reabastecimiento) =>
                TransaccionCard(transaccion: reabastecimiento),
          )
          .toList(),
    );
  }
}
