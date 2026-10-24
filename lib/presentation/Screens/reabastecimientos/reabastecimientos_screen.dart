import 'package:flutter/material.dart';
import '../../../data/mocks/mock_transacciones.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../transacciones/widgets/transaccion_tipo_selector.dart';
import 'widgets/reabastecimientos_widgets.dart';

class ReabastecimientosScreen extends StatelessWidget {
  const ReabastecimientosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reabastecimientos = mockTransacciones
        .where((t) => t.tipo == 'Reabastecimiento')
        .toList();

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
          'Reabastecimientos',
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
            tipoSeleccionado: 'Reabastecimiento',
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
              if (ruta != AppRoutes.reabastecimientos) {
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
            child: const Text(
              'Reabastecimientos registrados',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
          ReabastecimientosLista(reabastecimientos: reabastecimientos),
        ],
      ),
    );
  }
}
