import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

/// Indicador superior de la hoja inferior.
class InfoProductoDetalleHandle extends StatelessWidget {
  const InfoProductoDetalleHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 5,
      decoration: BoxDecoration(
        color: AppColors.line,
        borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
      ),
    );
  }
}

/// Encabezado del formulario de detalle y botón para cerrar la hoja.
class InfoProductoDetalleEncabezado extends StatelessWidget {
  final String titulo;
  final VoidCallback onCerrar;

  const InfoProductoDetalleEncabezado({
    super.key,
    required this.titulo,
    required this.onCerrar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            titulo,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        IconButton.filledTonal(
          onPressed: onCerrar,
          style: IconButton.styleFrom(
            backgroundColor: AppColors.lavender,
            foregroundColor: AppColors.ink,
            fixedSize: const Size(48, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }
}

/// Campo de nombre con el valor correspondiente al dato mock seleccionado.
class InfoProductoDetalleNombre extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const InfoProductoDetalleNombre({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textCapitalization: TextCapitalization.words,
      validator: validator,
      style: const TextStyle(
          color: AppColors.ink,
          fontSize: 15,
          fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.lavender,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}

/// Control de estado interactivo para la vista previa local del detalle.
class InfoProductoDetalleEstado extends StatelessWidget {
  final bool activo;
  final ValueChanged<bool> onChanged;

  const InfoProductoDetalleEstado({
    super.key,
    required this.activo,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            activo ? 'Activo' : 'Inactivo',
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => onChanged(!activo),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 54,
            height: 32,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: activo ? AppColors.primary : AppColors.line,
              borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 160),
              alignment:
                  activo ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: AppColors.card,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Botón de maqueta que cierra la hoja sin modificar el dato mock.
class InfoProductoDetalleBotonGuardar extends StatelessWidget {
  final VoidCallback onPressed;

  const InfoProductoDetalleBotonGuardar({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.check),
        label: const Text('Guardar'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
