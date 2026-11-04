import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class TransaccionTipoSelector extends StatelessWidget {
  final String tipoSeleccionado;
  final ValueChanged<String> onSeleccionar;

  const TransaccionTipoSelector({
    super.key,
    required this.tipoSeleccionado,
    required this.onSeleccionar,
  });

  static const List<String> tipos = ['Venta', 'Pedido', 'Reabastecimiento'];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.lavender,
        borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
      ),
      child: Row(
        children: tipos.map((tipo) {
          final seleccionado = tipo == tipoSeleccionado;
          final etiqueta = tipo == 'Venta'
              ? 'Ventas'
              : tipo == 'Pedido'
              ? 'Pedidos'
              : 'Reabastecimiento';

          return Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
                onTap: () => onSeleccionar(tipo),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: seleccionado ? AppColors.card : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
                    boxShadow: seleccionado ? AppSpacing.cardShadow : null,
                  ),
                  child: Text(
                    etiqueta,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: seleccionado
                          ? AppColors.primaryDark
                          : AppColors.muted,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
