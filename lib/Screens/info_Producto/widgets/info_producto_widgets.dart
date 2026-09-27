import 'package:flutter/material.dart';

import '../../../models/mocks/mock_info_producto.dart';
import '../../../theme/app_theme.dart';

/// Encabezado de sección para alternar entre líneas y presentaciones.
class InfoProductoSeccionSelector extends StatelessWidget {
  final bool lineasSeleccionadas;
  final ValueChanged<bool> onChanged;

  const InfoProductoSeccionSelector({
    super.key,
    required this.lineasSeleccionadas,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.lavender,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Row(
        children: [
          _OpcionSeccion(
            texto: 'Líneas',
            seleccionada: lineasSeleccionadas,
            onTap: () => onChanged(true),
          ),
          _OpcionSeccion(
            texto: 'Presentaciones',
            seleccionada: !lineasSeleccionadas,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }
}

class _OpcionSeccion extends StatelessWidget {
  final String texto;
  final bool seleccionada;
  final VoidCallback onTap;

  const _OpcionSeccion({
    required this.texto,
    required this.seleccionada,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: seleccionada ? AppColors.card : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius - 4),
            boxShadow: seleccionada ? AppSpacing.cardShadow : null,
          ),
          child: Text(
            texto,
            style: TextStyle(
              color: seleccionada ? AppColors.primaryDark : AppColors.muted,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

/// Tarjeta que muestra la información de una línea o presentación.
class InfoProductoItemCard extends StatelessWidget {
  final InfoProductoMockItem item;
  final bool esLinea;
  final VoidCallback? onTap;

  const InfoProductoItemCard({
    super.key,
    required this.item,
    required this.esLinea,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tono = esLinea ? AppTone.yellow : AppTone.purple;
    final color = AppToneColors.intense[tono]!;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: AppSpacing.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppToneColors.soft[tono],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              esLinea ? Icons.icecream_outlined : Icons.layers_outlined,
              color: color,
              size: 25,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nombre,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  esLinea ? 'Línea de producto' : 'Presentación',
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _EstadoCatalogoBadge(estado: item.estado),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right, color: AppColors.muted, size: 23),
        ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Indicador visual del estado del elemento del catálogo.
class _EstadoCatalogoBadge extends StatelessWidget {
  final String estado;

  const _EstadoCatalogoBadge({required this.estado});

  @override
  Widget build(BuildContext context) {
    final activo = estado == 'Activo';
    final tone = activo ? AppTone.teal : AppTone.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppToneColors.soft[tone],
        borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: AppToneColors.intense[tone],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            estado,
            style: TextStyle(
              color: AppToneColors.intense[tone],
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
