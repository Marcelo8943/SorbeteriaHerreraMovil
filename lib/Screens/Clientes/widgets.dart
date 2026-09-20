import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Tarjeta de KPI/Estadística para el encabezado
class ClienteStatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color bgColor;
  final Color iconColor;
  final IconData icon;

  const ClienteStatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.bgColor,
    required this.iconColor,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: AppSpacing.cardShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 17),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: AppColors.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Campo de Búsqueda y Botón de Filtro
class ClienteSearchFilterRow extends StatelessWidget {
  final String hintText;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onFilterTap;
  final bool isFilterActive;

  const ClienteSearchFilterRow({
    Key? key,
    this.hintText = 'Buscar clientes...',
    this.searchController,
    this.onSearchChanged,
    this.onFilterTap,
    this.isFilterActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.lavender,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: AppColors.muted, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: onSearchChanged,
                    style: const TextStyle(fontSize: 13, color: AppColors.ink),
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      fillColor: Colors.transparent,
                      hintStyle: const TextStyle(fontSize: 13, color: AppColors.muted),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: isFilterActive ? AppColors.primary : AppColors.card,
            borderRadius: BorderRadius.circular(14),
          ),
          child: IconButton(
            icon: Icon(
              Icons.tune,
              color: isFilterActive ? AppColors.textOnPrimary : AppColors.ink,
              size: 20,
            ),
            onPressed: onFilterTap,
          ),
        ),
      ],
    );
  }
}

/// Item Individual de Cliente (Layout exacto al prototipo)
class ClienteCardItem extends StatelessWidget {
  final String nombre;
  final String puntoVenta;
  final String municipio;
  final String iniciales;
  final VoidCallback? onTap;

  const ClienteCardItem({
    Key? key,
    required this.nombre,
    required this.puntoVenta,
    required this.municipio,
    required this.iniciales,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      iniciales,
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
                        nombre,
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
                              municipio,
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
                              puntoVenta,
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