import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'widgets/info_producto_form_widgets.dart';

/// Formulario de maqueta para crear una línea o presentación.
class InfoProductoFormScreen extends StatefulWidget {
  final bool esLinea;
  final ValueChanged<String> onCrear;

  const InfoProductoFormScreen({
    super.key,
    required this.esLinea,
    required this.onCrear,
  });

  @override
  State<InfoProductoFormScreen> createState() => _InfoProductoFormScreenState();
}

class _InfoProductoFormScreenState extends State<InfoProductoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  void _cerrarFormulario() => Navigator.of(context).maybePop();

  void _crear() {
    if (!_formKey.currentState!.validate()) return;
    widget.onCrear(_nombreController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final titulo = widget.esLinea ? 'Agregar nueva línea' : 'Agregar nueva presentación';

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.cardRadius + 6),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(child: InfoProductoFormHandle()),
                  const SizedBox(height: AppSpacing.md),
                  InfoProductoFormEncabezado(
                    titulo: titulo,
                    onCerrar: _cerrarFormulario,
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
                  InfoProductoFormNombre(
                    controller: _nombreController,
                    validator: _validarNombre,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  InfoProductoFormActionButton(onPressed: _crear),
                ],
              ),
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
}
