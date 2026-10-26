import 'package:flutter/material.dart';
import '../../../../data/models/app_models.dart';
import '../../../theme/app_theme.dart';
import '../../transacciones/widgets/transaccion_card.dart';

class PedidosLista extends StatelessWidget {
  final List<Transaccion> pedidos;

  const PedidosLista({super.key, required this.pedidos});

  @override
  Widget build(BuildContext context) {
    if (pedidos.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            'No hay pedidos registrados.',
            style: TextStyle(color: AppColors.muted, fontSize: 13),
          ),
        ),
      );
    }

    return Column(
      children: pedidos
          .map((pedido) => TransaccionCard(transaccion: pedido))
          .toList(),
    );
  }
}
