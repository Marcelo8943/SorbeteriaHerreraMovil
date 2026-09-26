import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../theme/app_theme.dart';
import 'producto_form_screen.dart';
import 'widgets/producto_detalle_widgets.dart';

class ProductoDetalleScreen extends StatelessWidget {
  final Producto producto;

  const ProductoDetalleScreen({super.key, required this.producto});

  void _abrirFicha(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => ProductoFormScreen(producto: producto),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Detalle del Producto'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderSeccion(producto: producto),
            Transform.translate(
              offset: const Offset(0, -30),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  children: [
                    TarjetaInformacion(producto: producto),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _abrirFicha(context),
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text('Editar producto'),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
