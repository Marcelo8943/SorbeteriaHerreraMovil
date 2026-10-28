import 'package:flutter/material.dart';
import 'package:herrera_system/presentation/providers/inventory_movements_provider.dart';
import 'package:herrera_system/presentation/routes/app_routes.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../widgets/search_filter_row.dart';
import 'widgets/movimiento_card.dart';
import 'widgets/movimientos_stats_row.dart';

class MovimientosScreen extends StatefulWidget {
  const MovimientosScreen({super.key});

  @override
  State<MovimientosScreen> createState() => _MovimientosScreenState();
}

class _MovimientosScreenState extends State<MovimientosScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<InventoryMovementsProvider>().loadInitial();
    });
  }

  void _showFilterModal(InventoryMovementsProvider movements) {
    var tempDateRange = movements.dateRange;

    showModalBottomSheet(
      context: context,
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
                    'Filtrar movimientos',
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
              const _FilterLabel('Rango de fecha'),
              const SizedBox(height: AppSpacing.xs),
              _DateRangeDropdown(
                value: tempDateRange,
                onChanged: (value) {
                  if (value != null) {
                    setModalState(() => tempDateRange = value);
                  }
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => setModalState(
                        () => tempDateRange = MovementDateRange.all,
                      ),
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
                        movements.applyFilters(
                          search: _searchQuery,
                          dateRange: tempDateRange,
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

  void _search(InventoryMovementsProvider movements, String query) {
    final search = query.trim();
    setState(() => _searchQuery = search);
    movements.applyFilters(search: search, dateRange: movements.dateRange);
  }

  @override
  Widget build(BuildContext context) {
    final movements = context.watch<InventoryMovementsProvider>();
    final stats = movements.stats;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: movements.isLoading && movements.movements.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.only(top: AppSpacing.md, bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Text(
                      _todayLabel(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  MovimientosStatsRow(
                    movimientosHoy: stats?.movementsToday ?? 0,
                    transferenciasHoy: stats?.transfersToday ?? 0,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: SearchFilterRow(
                      hintText: 'Buscar movimiento o producto...',
                      onSearchChanged: (query) => _search(movements, query),
                      onFilterTap: () => _showFilterModal(movements),
                    ),
                  ),
                  if (movements.errorMessage != null)
                    _MovementsError(
                      message: movements.errorMessage!,
                      onRetry: movements.loadInitial,
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
                            'Movimientos recientes',
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
                              '${movements.totalRecords}',
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
                    if (movements.movements.isEmpty)
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
                        children: movements.movements
                            .map(
                              (movement) => MovimientoCard(
                                movimiento: movement,
                                onTap: () => Navigator.of(context).pushNamed(
                                  AppRoutes.movimientoDetalle,
                                  arguments: movement.id,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    if (movements.totalPages > 1) ...[
                      const SizedBox(height: AppSpacing.sm),
                      _MovimientosPaginationRow(
                        currentPage: movements.currentPage,
                        totalPages: movements.totalPages,
                        onPrevious: () =>
                            movements.goToPage(movements.currentPage - 1),
                        onNext: () =>
                            movements.goToPage(movements.currentPage + 1),
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
      'Movimientos de Inventario',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
      ),
    ),
  );

  String _todayLabel() {
    const weekdays = [
      'lunes',
      'martes',
      'miércoles',
      'jueves',
      'viernes',
      'sábado',
      'domingo',
    ];
    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    return 'Hoy · ${weekdays[now.weekday - 1]} $day/$month';
  }
}

class _MovementsError extends StatelessWidget {
  const _MovementsError({required this.message, required this.onRetry});

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

class _DateRangeDropdown extends StatelessWidget {
  const _DateRangeDropdown({required this.value, required this.onChanged});

  final MovementDateRange value;
  final ValueChanged<MovementDateRange?> onChanged;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
    decoration: BoxDecoration(
      color: AppColors.lavender,
      borderRadius: BorderRadius.circular(12),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<MovementDateRange>(
        value: value,
        isExpanded: true,
        dropdownColor: AppColors.card,
        icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.muted),
        items: MovementDateRange.values
            .map(
              (range) => DropdownMenuItem(
                value: range,
                child: Text(
                  _labelFor(range),
                  style: const TextStyle(color: AppColors.ink, fontSize: 13.5),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    ),
  );

  String _labelFor(MovementDateRange range) => switch (range) {
    MovementDateRange.all => 'Todos',
    MovementDateRange.today => 'Hoy',
    MovementDateRange.last7Days => 'Últimos 7 días',
    MovementDateRange.thisMonth => 'Este mes',
    MovementDateRange.thisYear => 'Este año',
  };
}

class _MovimientosPaginationRow extends StatelessWidget {
  const _MovimientosPaginationRow({
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
