import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'widgets/info_producto_detalle_widgets.dart';

/// Hoja inferior de detalle visual para una línea o presentación del catálogo.
class InfoProductoDetalleScreen extends StatefulWidget {
  final String nombre;
  final String estado;
  final bool esLinea;
  final Future<void> Function(String nombre, String estado) onGuardar;

  const InfoProductoDetalleScreen({
    super.key,
    required this.nombre,
    required this.estado,
    required this.esLinea,
    required this.onGuardar,
  });

  @override
  State<InfoProductoDetalleScreen> createState() =>
      _InfoProductoDetalleScreenState();
}

class _InfoProductoDetalleScreenState extends State<InfoProductoDetalleScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;
  late bool _activo;
  bool _guardando = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.nombre);
    _activo = widget.estado == 'Activo';
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _guardando = true;
      _error = null;
    });
    try {
      await widget.onGuardar(
        _nombreController.text.trim(),
        _activo ? 'Activo' : 'Inactivo',
      );
    } catch (exception) {
      if (mounted) setState(() => _error = _mensajeError(exception));
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(child: InfoProductoDetalleHandle()),
                const SizedBox(height: AppSpacing.md),
                InfoProductoDetalleEncabezado(
                  titulo: widget.esLinea
                      ? 'Editar línea'
                      : 'Editar presentación',
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
                InfoProductoDetalleNombre(
                  controller: _nombreController,
                  validator: _validarNombre,
                ),
                const SizedBox(height: AppSpacing.md),
                InfoProductoDetalleEstado(
                  activo: _activo,
                  onChanged: (activo) => setState(() => _activo = activo),
                ),
                if (_error != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(_error!, style: const TextStyle(color: AppColors.error)),
                ],
                const SizedBox(height: AppSpacing.md),
                InfoProductoDetalleBotonGuardar(
                  onPressed: _guardando ? null : _guardar,
                  cargando: _guardando,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validarNombre(String? value) {
    final nombre = value?.trim() ?? '';
    if (nombre.isEmpty) return 'Ingrese el nombre';
    if (nombre.length < 2) return 'El nombre debe tener al menos 2 caracteres';
    return null;
  }

  String _mensajeError(Object exception) =>
      exception.toString().replaceFirst(RegExp(r'^[^:]+: '), '');
}
