import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../models/app_models.dart';

/// Item Individual de Cliente adaptado al modelo de datos Cliente
class ClienteCardItem extends StatelessWidget {
  final Cliente cliente;
  final int index;
  final VoidCallback? onTap;

  const ClienteCardItem({
    Key? key,
    required this.cliente,
    required this.index,
    this.onTap,
  }) : super(key: key);

  static Color colorForIndex(int index) {
    final tonosDisponibles = AppToneColors.intense.values.toList();
    return tonosDisponibles[index % tonosDisponibles.length];
  }

  String get _inicialesDisplay {
    if (cliente.iniciales != null && cliente.iniciales!.isNotEmpty) {
      return cliente.iniciales!;
    }
    List<String> partes = cliente.nombre.trim().split(' ');
    if (partes.length >= 2) {
      return '${partes[0][0]}${partes[1][0]}'.toUpperCase();
    }
    return partes.isNotEmpty ? partes[0][0].toUpperCase() : '';
  }

  @override
  Widget build(BuildContext context) {
    final Color avatarBgColor = colorForIndex(index);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: avatarBgColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      _inicialesDisplay,
                      style: const TextStyle(
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cliente.nombre,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 13, color: AppColors.muted),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${cliente.municipio} (${cliente.departamento})',
                              style: const TextStyle(fontSize: 11.5, color: AppColors.muted),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.store_outlined, size: 13, color: AppColors.muted),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              cliente.puntoVenta,
                              style: const TextStyle(fontSize: 11.5, color: AppColors.muted),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.muted, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Control de Paginación para 10 elementos por hoja
class ClientePaginationRow extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const ClientePaginationRow({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    this.onPrevious,
    this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool canGoBack = currentPage > 1;
    final bool canGoNext = currentPage < totalPages && totalPages > 0;

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
                Icon(Icons.arrow_back_ios_new, size: 11, color: canGoBack ? AppColors.primary : AppColors.muted),
                const SizedBox(width: 4),
                Text('Anterior', style: TextStyle(fontSize: 11.5, color: canGoBack ? AppColors.primary : AppColors.muted)),
              ],
            ),
          ),
          Text(
            totalPages > 0 ? 'Página $currentPage de $totalPages' : 'Sin resultados',
            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.ink),
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
                Text('Siguiente', style: TextStyle(fontSize: 11.5, color: canGoNext ? AppColors.primary : AppColors.muted)),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios, size: 11, color: canGoNext ? AppColors.primary : AppColors.muted),
              ],
            ),
          ),
        ],
      ),
    );
  }
}