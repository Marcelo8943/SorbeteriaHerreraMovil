import 'package:flutter/material.dart';

import '../../models/mocks/mock_info_producto.dart';
import '../../theme/app_theme.dart';
import 'widgets/info_producto_detalle_widgets.dart';

/// Hoja inferior de detalle visual para una línea o presentación del catálogo.
class InfoProductoDetalleScreen extends StatefulWidget {
  final InfoProductoMockItem item;
  final bool esLinea;

  const InfoProductoDetalleScreen({
    super.key,
    required this.item,
    required this.esLinea,
  });

  @override
  State<InfoProductoDetalleScreen> createState() =>
      _InfoProductoDetalleScreenState();
}

class _InfoProductoDetalleScreenState extends State<InfoProductoDetalleScreen> {
  late final TextEditingController _nombreController;
  late bool _activo;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.item.nombre);
    _activo = widget.item.estado == 'Activo';
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.cardRadius + 6),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.md + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(child: InfoProductoDetalleHandle()),
              const SizedBox(height: AppSpacing.md),
              InfoProductoDetalleEncabezado(
                titulo: widget.esLinea ? 'Editar línea' : 'Editar presentación',
                onCerrar: () => Navigator.of(context).maybePop(),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Nombre *',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              InfoProductoDetalleNombre(controller: _nombreController),
              const SizedBox(height: AppSpacing.md),
              InfoProductoDetalleEstado(
                activo: _activo,
                onChanged: (activo) => setState(() => _activo = activo),
              ),
              const SizedBox(height: AppSpacing.md),
              InfoProductoDetalleBotonGuardar(
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
