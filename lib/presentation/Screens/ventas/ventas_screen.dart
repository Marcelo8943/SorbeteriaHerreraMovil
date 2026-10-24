import 'package:flutter/material.dart';
import '../../../data/mocks/mock_transacciones.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../transacciones/widgets/transaccion_tipo_selector.dart';
import 'widgets/ventas_widgets.dart';

class VentasScreen extends StatelessWidget {
  const VentasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ventas = mockTransacciones.where((t) => t.tipo == 'Venta').toList();

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
          'Ventas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(
          top: AppSpacing.md,
          bottom: AppSpacing.xl,
        ),
        children: [
          TransaccionTipoSelector(
            tipoSeleccionado: 'Venta',
            onSeleccionar: (tipo) {
              final ruta = switch (tipo) {
                'Venta' => AppRoutes.ventas,
                'Pedido' => AppRoutes.pedidos,
                'Reabastecimiento' => AppRoutes.reabastecimientos,
                _ => throw ArgumentError.value(
                  tipo,
                  'tipo',
                  'Tipo no soportado',
                ),
              };
              if (ruta != AppRoutes.ventas) {
                Navigator.of(context).pushReplacementNamed(ruta);
              }
            },
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Text(
              'Ventas registradas',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
          VentasLista(ventas: ventas),
        ],
      ),
    );
  }
}
