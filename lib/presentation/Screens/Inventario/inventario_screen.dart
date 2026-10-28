import 'package:flutter/material.dart';
import 'package:herrera_system/data/models/inventory_filter_option.dart';
import 'package:herrera_system/presentation/providers/inventory_provider.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../widgets/search_filter_row.dart';
import 'widgets/inventario_producto_card.dart';
import 'widgets/inventario_stats_row.dart';

class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<InventoryProvider>().loadInitial();
    });
  }

  void _showFilterModal(InventoryProvider inventory) {
    var tempLineId = inventory.lineId ?? 0;
    var tempFlavorId = inventory.flavorId ?? 0;
    var tempPresentationId = inventory.presentationId ?? 0;
    var tempStockStatus = switch (inventory.lowStock) {
      true => 2,
      false => 1,
      null => 0,
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.line,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filtrar inventario',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.ink,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Cerrar',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: AppColors.ink),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              const _FilterLabel('Línea'),
              const SizedBox(height: AppSpacing.xs),
              _FilterDropdown(
                value: tempLineId,
                items: _optionsWithAll('Todas', inventory.lines),
                onChanged: (value) =>
                    setModalState(() => tempLineId = value ?? 0),
              ),
              const SizedBox(height: AppSpacing.md),
              const _FilterLabel('Sabor'),
              const SizedBox(height: AppSpacing.xs),
              _FilterDropdown(
                value: tempFlavorId,
                items: _optionsWithAll('Todos', inventory.flavors),
                onChanged: (value) =>
                    setModalState(() => tempFlavorId = value ?? 0),
              ),
              const SizedBox(height: AppSpacing.md),
              const _FilterLabel('Presentación'),
              const SizedBox(height: AppSpacing.xs),
              _FilterDropdown(
                value: tempPresentationId,
                items: _optionsWithAll('Todas', inventory.presentations),
                onChanged: (value) =>
                    setModalState(() => tempPresentationId = value ?? 0),
              ),
              const SizedBox(height: AppSpacing.md),
              const _FilterLabel('Estado de stock'),
              const SizedBox(height: AppSpacing.xs),
              _FilterDropdown(
                value: tempStockStatus,
                items: const [
                  InventoryFilterOption(id: 0, name: 'Todos'),
                  InventoryFilterOption(id: 1, name: 'OK'),
                  InventoryFilterOption(id: 2, name: 'Stock bajo'),
                ],
                onChanged: (value) =>
                    setModalState(() => tempStockStatus = value ?? 0),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setModalState(() {
                          tempLineId = 0;
                          tempFlavorId = 0;
                          tempPresentationId = 0;
                          tempStockStatus = 0;
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.lavender,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Limpiar',
                        style: TextStyle(
                          color: AppColors.ink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        inventory.applyFilters(
                          search: _searchQuery,
                          lineId: tempLineId == 0 ? null : tempLineId,
                          flavorId: tempFlavorId == 0 ? null : tempFlavorId,
                          presentationId: tempPresentationId == 0
                              ? null
                              : tempPresentationId,
                          lowStock: switch (tempStockStatus) {
                            1 => false,
                            2 => true,
                            _ => null,
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Aplicar',
                        style: TextStyle(
                          color: AppColors.textOnPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<InventoryFilterOption> _optionsWithAll(
    String allLabel,
    List<InventoryFilterOption> options,
  ) => [InventoryFilterOption(id: 0, name: allLabel), ...options];

  void _search(InventoryProvider inventory, String query) {
    final search = query.trim();
    setState(() => _searchQuery = search);
    inventory.applyFilters(
      search: search,
      lineId: inventory.lineId,
      flavorId: inventory.flavorId,
      presentationId: inventory.presentationId,
      lowStock: inventory.lowStock,
    );
  }

  @override
  Widget build(BuildContext context) {
    final inventory = context.watch<InventoryProvider>();
    final stats = inventory.stats;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: inventory.isLoading && inventory.products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.only(top: AppSpacing.md, bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InventarioStatsRow(
                    stockBajoCount: stats?.lowStockProducts ?? 0,
                    lotesPorVencer: stats?.expiringLots ?? 0,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: SearchFilterRow(
                      hintText: 'Buscar producto...',
                      onSearchChanged: (query) => _search(inventory, query),
                      onFilterTap: () => _showFilterModal(inventory),
                    ),
                  ),
                  if (inventory.errorMessage != null)
                    _InventoryError(
                      message: inventory.errorMessage!,
                      onRetry: inventory.loadInitial,
                    )
                  else ...[
                    const SizedBox(height: AppSpacing.md),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: 4,
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'Stock por producto',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppToneColors.soft[AppTone.teal],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${inventory.totalRecords}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppToneColors.intense[AppTone.teal],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    if (inventory.products.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            'Sin resultados para los filtros aplicados.',
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      )
                    else
                      Column(
                        children: inventory.products
                            .map(
                              (product) =>
                                  InventarioProductoCard(producto: product),
                            )
                            .toList(),
                      ),
                    if (inventory.totalPages > 1) ...[
                      const SizedBox(height: AppSpacing.sm),
                      _InventarioPaginationRow(
                        currentPage: inventory.currentPage,
                        totalPages: inventory.totalPages,
                        onPrevious: () =>
                            inventory.goToPage(inventory.currentPage - 1),
                        onNext: () =>
                            inventory.goToPage(inventory.currentPage + 1),
                      ),
                    ],
                  ],
                ],
              ),
            ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) => AppBar(
    backgroundColor: AppColors.card,
    elevation: 0,
    scrolledUnderElevation: 0,
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back_ios_new,
        size: 18,
        color: AppColors.ink,
      ),
      onPressed: () => Navigator.of(context).pop(),
    ),
    title: const Text(
      'Inventario',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
      ),
    ),
  );
}

class _InventoryError extends StatelessWidget {
  const _InventoryError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppSpacing.xl),
    child: Center(
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(onPressed: onRetry, child: const Text('Reintentar')),
        ],
      ),
    ),
  );
}

class _FilterLabel extends StatelessWidget {
  const _FilterLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 12.5,
      fontWeight: FontWeight.w600,
      color: AppColors.ink,
    ),
  );
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final int value;
  final List<InventoryFilterOption> items;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
    decoration: BoxDecoration(
      color: AppColors.lavender,
      borderRadius: BorderRadius.circular(12),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<int>(
        value: value,
        isExpanded: true,
        dropdownColor: AppColors.card,
        icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.muted),
        items: items
            .map(
              (item) => DropdownMenuItem<int>(
                value: item.id,
                child: Text(
                  item.name,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 13.5,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    ),
  );
}

class _InventarioPaginationRow extends StatelessWidget {
  const _InventarioPaginationRow({
    required this.currentPage,
    required this.totalPages,
    required this.onPrevious,
    required this.onNext,
  });

  final int currentPage;
  final int totalPages;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final canGoPrevious = currentPage > 1;
    final canGoNext = currentPage < totalPages;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton.icon(
            onPressed: canGoPrevious ? onPrevious : null,
            icon: Icon(
              Icons.chevron_left,
              size: 18,
              color: canGoPrevious ? AppColors.ink : AppColors.muted,
            ),
            label: Text(
              'Anterior',
              style: TextStyle(
                color: canGoPrevious ? AppColors.ink : AppColors.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            'Página $currentPage de $totalPages',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.ink,
            ),
          ),
          OutlinedButton.icon(
            onPressed: canGoNext ? onNext : null,
            icon: Text(
              'Siguiente',
              style: TextStyle(
                color: canGoNext ? AppColors.primary : AppColors.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
            label: Icon(
              Icons.chevron_right,
              size: 18,
              color: canGoNext ? AppColors.primary : AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
