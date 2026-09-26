import 'package:flutter/material.dart';

import '../../models/app_models.dart';
import '../../theme/app_theme.dart';
import 'widgets/precios_form_widgets.dart';

/// Vista de ejemplo de precios para una presentación.
class PrecioFormScreen extends StatefulWidget {
  final PrecioGeneral precio;

  const PrecioFormScreen({super.key, required this.precio});

  @override
  State<PrecioFormScreen> createState() => _PrecioFormScreenState();
}

class _PrecioFormScreenState extends State<PrecioFormScreen> {
  late final TextEditingController _detalleController;
  late final TextEditingController _mayoreoController;

  @override
  void initState() {
    super.initState();
    _detalleController = TextEditingController(
      text: _textoPrecio(widget.precio.precioDetalle),
    );
    _mayoreoController = TextEditingController(
      text: _textoPrecio(widget.precio.precioMayoreo),
    );
  }

  String _textoPrecio(double precio) =>
      precio == precio.roundToDouble() ? precio.toStringAsFixed(0) : '$precio';

  @override
  void dispose() {
    _detalleController.dispose();
    _mayoreoController.dispose();
    super.dispose();
  }

  void _cerrarVistaPrevia() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.cardRadius),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                // Indicador visual del panel inferior.
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.line,
                      borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                // Título del formulario y botón para cerrarlo.
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Editar precio · ${widget.precio.presentacion}',
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton.filledTonal(
                      tooltip: 'Cerrar',
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.lavender,
                        foregroundColor: AppColors.ink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                // Los precios se editan en paralelo como en el diseño.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: PrecioFormField(
                        etiqueta: 'PRECIO DETALLE (C\$)',
                        controller: _detalleController,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: PrecioFormField(
                        etiqueta: 'PRECIO MAYOREO (C\$)',
                        controller: _mayoreoController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                const Divider(height: 1, color: AppColors.line),
                const SizedBox(height: AppSpacing.md),
                // Acción visual: cierra el formulario de ejemplo sin guardar datos.
                PrecioFormActionButton(onPressed: _cerrarVistaPrevia),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
