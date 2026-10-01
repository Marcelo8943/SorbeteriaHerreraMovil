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
  final _formKey = GlobalKey<FormState>();
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

  void _guardarPrecio() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pop(
      PrecioGeneral(
        id: widget.precio.id,
        presentacion: widget.precio.presentacion,
        linea: widget.precio.linea,
        precioDetalle: _leerPrecio(_detalleController),
        precioMayoreo: _leerPrecio(_mayoreoController),
        cantidadProductos: widget.precio.cantidadProductos,
      ),
    );
  }

  double _leerPrecio(TextEditingController controller) =>
      double.parse(controller.text.trim().replaceAll(',', '.'));

  double? _parsearPrecio(String? value) =>
      double.tryParse(value?.trim().replaceAll(',', '.') ?? '');

  String? _validarPrecio(String? value) {
    final precio = _parsearPrecio(value);
    if (precio == null || !precio.isFinite || precio <= 0) {
      return 'Ingrese un precio válido mayor que 0';
    }
    return null;
  }

  String? _validarPrecioMayoreo(String? value) {
    final error = _validarPrecio(value);
    if (error != null) return error;

    final precioMayoreo = _parsearPrecio(value);
    final precioDetalle = _parsearPrecio(_detalleController.text);
    if (precioMayoreo != null &&
        precioDetalle != null &&
        precioMayoreo > precioDetalle) {
      return 'El precio mayoreo no puede superar el precio detalle';
    }
    return null;
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
              key: _formKey,
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
                        validator: _validarPrecio,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: PrecioFormField(
                        etiqueta: 'PRECIO MAYOREO (C\$)',
                        controller: _mayoreoController,
                        validator: _validarPrecioMayoreo,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                const Divider(height: 1, color: AppColors.line),
                const SizedBox(height: AppSpacing.md),
                PrecioFormActionButton(onPressed: _guardarPrecio),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
