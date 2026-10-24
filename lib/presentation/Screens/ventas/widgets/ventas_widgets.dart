import 'package:flutter/material.dart';
import '../../../../data/models/app_models.dart';
import '../../../theme/app_theme.dart';
import '../../transacciones/widgets/transaccion_card.dart';

class VentasLista extends StatelessWidget {
  final List<Transaccion> ventas;

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
      children: ventas
          .map((venta) => TransaccionCard(transaccion: venta))
          .toList(),
    );
  }
}
