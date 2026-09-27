import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

/// Indicador visual superior de la hoja inferior.
class InfoProductoFormHandle extends StatelessWidget {
  const InfoProductoFormHandle({super.key});

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

/// Encabezado del formulario y acción para cerrar.
class InfoProductoFormEncabezado extends StatelessWidget {
  final String titulo;
  final VoidCallback onCerrar;

  const InfoProductoFormEncabezado({
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
          tooltip: 'Cerrar',
          onPressed: onCerrar,
          icon: const Icon(Icons.close),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.lavender,
            foregroundColor: AppColors.ink,
            fixedSize: const Size(48, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ],
    );
  }
}

/// Campo para escribir el nombre del dato de ejemplo.
class InfoProductoFormNombre extends StatelessWidget {
  final TextEditingController controller;

  const InfoProductoFormNombre({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.words,
      style: const TextStyle(
        color: AppColors.ink,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: 'Escribe el nombre',
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

/// Acción visual que cierra el formulario sin agregar datos al mock.
class InfoProductoFormActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const InfoProductoFormActionButton({
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
        label: const Text('Crear'),
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
