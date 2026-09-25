import 'package:flutter/material.dart';

import '../../../models/app_models.dart';
import '../../../theme/app_theme.dart';

/// Tarjeta de resumen que muestra un indicador del mÃ³dulo, como precios
/// configurados o precios especiales.
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

/// Selector horizontal para filtrar los precios generales por lÃ­nea.
class PreciosLineaSelector extends StatelessWidget {
  final String seleccionada;
  final ValueChanged<String> onSeleccionar;

  const PreciosLineaSelector({
    super.key,
    required this.seleccionada,
    required this.onSeleccionar,
  });

  static const _opciones = <(String, String)>[
    ('Todas', 'Todas'),
    ('Tradicionales', 'Tradicional'),
    ('Lights', 'Lights'),
    ('Nieves', 'Nieves'),
    ('Paletas', 'Paleta'),
    ('Fantacia', 'Fantacia'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final opcion in _opciones)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: ChoiceChip(
                label: Text(opcion.$1),
                selected: seleccionada == opcion.$2,
                onSelected: (_) => onSeleccionar(opcion.$2),
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.card,
                side: BorderSide.none,
                labelStyle: TextStyle(
                  color: seleccionada == opcion.$2
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

/// Tarjeta con la presentaciÃ³n, cantidad de productos y precios de detalle
/// y mayoreo de una lÃ­nea.
class PrecioGeneralCard extends StatelessWidget {
  final PrecioGeneral precio;
  final String nombreLinea;
  final VoidCallback? onTap;

  const PrecioGeneralCard({
    super.key,
    required this.precio,
    required this.nombreLinea,
    this.onTap,
  });

  String get _unidad {
    final presentacion = precio.presentacion.toLowerCase();
    if (presentacion.contains('4 onzas')) return '4';
    if (presentacion.contains('8 onzas')) return '8';
    if (presentacion.contains('1/4 gal')) return '¼';
    if (presentacion.contains('1/2 gal')) return '½';
    if (presentacion.contains('1 gal')) return '1';
    if (presentacion.contains('litro')) return 'L';
    if (presentacion.contains('libra')) return 'Lb';
    return precio.presentacion;
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
                    Text(
                      precio.presentacion,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$nombreLinea Â· ${precio.cantidadProductos} productos',
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
                    'C\$${precio.precioDetalle.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: AppToneColors.intense[AppTone.teal],
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'C\$${precio.precioMayoreo.toStringAsFixed(2)} may.',
                    style: TextStyle(
                      color: AppToneColors.intense[AppTone.purple],
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
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

/// Tarjeta visual para mostrar una promociÃ³n o precio especial de producto.
class PrecioEspecialCard extends StatelessWidget {
  final PrecioEspecial precio;

  const PrecioEspecialCard({super.key, required this.precio});

  AppTone get _tono => precio.colorTag == 'yellow' ? AppTone.yellow : AppTone.purple;

  @override
  Widget build(BuildContext context) {
    final color = AppToneColors.intense[_tono]!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppToneColors.soft[_tono],
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            precio.productoNombre,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'C\$${precio.precioEspecial.toStringAsFixed(0)}',
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Icon(
                precio.colorTag == 'yellow'
                    ? Icons.star_border
                    : Icons.trending_down,
                color: color,
                size: 16,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  '${precio.motivo ?? 'Precio especial'} Â· Inicio: ${precio.fechaInicio}',
                  style: TextStyle(
                    color: color,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
