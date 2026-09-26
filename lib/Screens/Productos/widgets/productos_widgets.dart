import 'package:flutter/material.dart';
import '../../../../models/app_models.dart';
import '../../../../theme/app_theme.dart';
import 'producto_imagen.dart';

class ProductoTopBar extends StatelessWidget {
  final VoidCallback onAdd;

  const ProductoTopBar({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
      color: AppColors.lavender,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primaryDarker,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: AppColors.primaryDarker, width: 1.5),
                  ),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Herrera',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'serif',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sorbetería Herrera', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.ink)),
                  Text('Catálogo de productos', style: TextStyle(color: AppColors.muted, fontSize: 11.5)),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: onAdd,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(12),
            ),
            child: const Icon(Icons.add, color: AppColors.textOnPrimary),
          ),
        ],
      ),
    );
  }
}

class ProductoStatusBadge extends StatelessWidget {
  final String estado;

  const ProductoStatusBadge({super.key, required this.estado});

  @override
  Widget build(BuildContext context) {
    final activo = estado == 'Activo';
    final color = activo
        ? AppToneColors.intense[AppTone.teal]!
        : AppToneColors.intense[AppTone.red]!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: activo
            ? AppToneColors.soft[AppTone.teal]
            : AppToneColors.soft[AppTone.red],
        borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
      ),
      child: Text(
        estado,
        style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class ProductoCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback onTap;

  const ProductoCard({
    super.key,
    required this.producto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          boxShadow: AppSpacing.cardShadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 112,
              width: double.infinity,
              color: AppColors.lavender,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(12),
              child: ProductoImagen(
                referencia: producto.imgUrl,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [ProductoStatusBadge(estado: producto.estado)],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 36,
                    child: Text(
                      producto.nombre,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'C\$ ${producto.precioDetalle.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: AppToneColors.intense[AppTone.teal],
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${producto.linea} · ${producto.presentacion}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductoPaginationRow extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const ProductoPaginationRow({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final canGoBack = currentPage > 1;
    final canGoNext = currentPage < totalPages && totalPages > 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton(
            onPressed: canGoBack ? onPrevious : null,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              side: BorderSide(
                color: canGoBack ? AppColors.primary : AppColors.line,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_ios_new,
                  size: 11,
                  color: canGoBack ? AppColors.primary : AppColors.muted,
                ),
                const SizedBox(width: 4),
                Text(
                  'Anterior',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: canGoBack ? AppColors.primary : AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            totalPages > 0 ? 'Página $currentPage de $totalPages' : 'Sin resultados',
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
          OutlinedButton(
            onPressed: canGoNext ? onNext : null,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              side: BorderSide(
                color: canGoNext ? AppColors.primary : AppColors.line,
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Siguiente',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: canGoNext ? AppColors.primary : AppColors.muted,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 11,
                  color: canGoNext ? AppColors.primary : AppColors.muted,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


