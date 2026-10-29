import 'package:flutter/material.dart';

import '../../../../data/models/precio_general_model.dart';
import '../../../theme/app_theme.dart';

/// Tarjeta de resumen que muestra un indicador del módulo, como precios
/// configurados en el catálogo.
class PrecioResumenCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;
  final AppTone tono;

  const PrecioResumenCard({
    super.key,
    required this.titulo,
    required this.valor,
    required this.icono,
    required this.tono,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppToneColors.intense[tono]!;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppToneColors.soft[tono],
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.card.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icono, color: color),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(titulo, style: TextStyle(color: color, fontSize: 13)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            valor,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

/// Selector horizontal de las líneas devueltas por la API.
class PreciosLineaSelector extends StatelessWidget {
  final String seleccionada;
  final List<String> opciones;
  final ValueChanged<String> onSeleccionar;

  const PreciosLineaSelector({
    super.key,
    required this.seleccionada,
    required this.opciones,
    required this.onSeleccionar,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final opcion in opciones)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: ChoiceChip(
                label: Text(opcion),
                selected: seleccionada == opcion,
                onSelected: (_) => onSeleccionar(opcion),
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.card,
                side: BorderSide.none,
                labelStyle: TextStyle(
                  color: seleccionada == opcion
                      ? AppColors.textOnPrimary
                      : AppColors.muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Tarjeta con la presentación, cantidad de productos y precios de detalle
/// y mayoreo de una línea.
class PrecioGeneralCard extends StatelessWidget {
  final PrecioGeneralModel precio;
  final String nombreLinea;
  final VoidCallback? onTap;

  const PrecioGeneralCard({
    super.key,
    required this.precio,
    required this.nombreLinea,
    this.onTap,
  });

  String _formatearPrecio(double? valor) =>
      valor == null ? 'Sin definir' : 'C\$${valor.toStringAsFixed(2)}';

  String get _unidad {
    final presentacion = precio.presentationName.toLowerCase();
    if (presentacion.contains('cubeta')) return 'Cub.';
    if (presentacion.contains('4 onzas')) return '4';
    if (presentacion.contains('8 onzas')) return '8';
    if (presentacion.contains('1/4 gal')) return '¼';
    if (presentacion.contains('1/2 gal')) return '½';
    if (presentacion.contains('1 gal')) return '1';
    if (presentacion.contains('litro')) return 'L';
    if (presentacion.contains('libra')) return 'Lb';
    final primeraPalabra = precio.presentationName
        .trim()
        .split(RegExp(r'\s+'))
        .first;
    return primeraPalabra.length > 4
        ? '${primeraPalabra.substring(0, 4)}.'
        : primeraPalabra;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            boxShadow: AppSpacing.cardShadow,
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppToneColors.soft[AppTone.teal],
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  _unidad,
                  style: TextStyle(
                    color: AppToneColors.intense[AppTone.teal],
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Tooltip(
                      message: precio.presentationName,
                      child: Text(
                        precio.presentationName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$nombreLinea · ${precio.productsCount} productos',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatearPrecio(precio.retailPrice),
                    style: TextStyle(
                      color: AppToneColors.intense[AppTone.teal],
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${_formatearPrecio(precio.wholesalePrice)} may.',
                    style: TextStyle(
                      color: AppToneColors.intense[AppTone.purple],
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              if (onTap != null)
                Icon(
                  Icons.chevron_right,
                  color: AppColors.muted.withValues(alpha: 0.65),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
