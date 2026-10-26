import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import 'widgets/transaccion_tipo_selector.dart';

class TransaccionesScreen extends StatefulWidget {
  const TransaccionesScreen({super.key});

  @override
  State<TransaccionesScreen> createState() => _TransaccionesScreenState();
}

class _TransaccionesScreenState extends State<TransaccionesScreen> {
  void _abrirTipo(String tipo) {
    final ruta = switch (tipo) {
      'Venta' => AppRoutes.ventas,
      'Pedido' => AppRoutes.pedidos,
      'Reabastecimiento' => AppRoutes.reabastecimientos,
      _ => throw ArgumentError.value(tipo, 'tipo', 'Tipo no soportado'),
    };

    Navigator.of(context).pushNamed(ruta);
  }

  @override
  Widget build(BuildContext context) {
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
          'Transacciones',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TransaccionTipoSelector(
              tipoSeleccionado: '',
              onSeleccionar: _abrirTipo,
            ),
            const SizedBox(height: AppSpacing.lg),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(
                'Selecciona el tipo de transacción que deseas consultar.',
                style: TextStyle(fontSize: 14, color: AppColors.muted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
