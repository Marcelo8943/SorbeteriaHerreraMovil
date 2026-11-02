import 'dart:async';

import 'package:flutter/material.dart';
import 'package:herrera_system/core/constants/view_status.dart';
import 'package:herrera_system/data/models/restock_list_item_model.dart';
import 'package:herrera_system/presentation/providers/restocks_provider.dart';
import 'package:provider/provider.dart';

import '../../Screens/productos/widgets/productos_widgets.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/error_view.dart';
import '../../widgets/h_stat_card.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/search_filter_row.dart';
import '../transacciones/widgets/transaccion_tipo_selector.dart';
import 'widgets/reabastecimientos_widgets.dart';

class ReabastecimientosScreen extends StatefulWidget {
  const ReabastecimientosScreen({super.key});

  @override
  State<ReabastecimientosScreen> createState() =>
      _ReabastecimientosScreenState();
}

class _ReabastecimientosScreenState extends State<ReabastecimientosScreen> {
  static const int _pageSize = 10;
  static const List<String> _dateRanges = [
    'Este mes',
    'Todo el historial',
    'Hoy',
    'Últimos 7 días',
    'Este año',
  ];

  int _currentPage = 1;
  String _search = '';
  String _selectedDateRange = 'Este mes';
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = context.read<RestocksProvider>();
      provider.loadStatistics();
      _loadPage(1);
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  Future<void> _loadPage(int page) {
    _currentPage = page;
    final dates = _getDateBounds(_selectedDateRange);
    return context.read<RestocksProvider>().loadRestocks(
      page: page,
      pageSize: _pageSize,
      fromDate: dates.$1,
      toDate: dates.$2,
      search: _search.isEmpty ? null : _search,
    );
  }

  (DateTime?, DateTime?) _getDateBounds(String range) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    switch (range) {
      case 'Todo el historial':
        return (null, today);
      case 'Hoy':
        return (today, today);
      case 'Últimos 7 días':
        return (today.subtract(const Duration(days: 6)), today);
      case 'Este año':
        return (DateTime(now.year), today);
      case 'Este mes':
      default:
        return (DateTime(now.year, now.month), today);
    }
  }

  void _onSearchChanged(String value) {
    _search = value.trim();
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) _loadPage(1);
    });
  }

  void _showFilters() {
    var selectedRange = _selectedDateRange;
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) => StatefulBuilder(
        builder: (modalContext, setModalState) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filtrar reabastecimientos',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              const Text('Fecha de registro'),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: selectedRange,
                isExpanded: true,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: AppColors.lavender,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                items: _dateRanges
                    .map((range) => DropdownMenuItem(
                          value: range,
                          child: Text(range),
                        ))
                    .toList(),
                onChanged: (value) =>
                    setModalState(() => selectedRange = value ?? 'Este mes'),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() => _selectedDateRange = 'Este mes');
                        Navigator.pop(modalContext);
                        _loadPage(1);
                      },
                      child: const Text('Restablecer'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        setState(() => _selectedDateRange = selectedRange);
                        Navigator.pop(modalContext);
                        _loadPage(1);
                      },
                      child: const Text('Aplicar filtros'),
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

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RestocksProvider>();
    final page = provider.page;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
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
          'Reabastecimientos',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            provider.loadStatistics(),
            _loadPage(_currentPage),
          ]);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(
            top: AppSpacing.md,
            bottom: AppSpacing.xl,
          ),
          children: [
            TransaccionTipoSelector(
              tipoSeleccionado: 'Reabastecimiento',
              onSeleccionar: (type) {
                final route = switch (type) {
                  'Venta' => AppRoutes.ventas,
                  'Pedido' => AppRoutes.pedidos,
                  'Reabastecimiento' => AppRoutes.reabastecimientos,
                  _ => throw ArgumentError.value(type),
                };
                if (route != AppRoutes.reabastecimientos) {
                  Navigator.of(context).pushReplacementNamed(route);
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),
            _buildStatistics(provider),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: SearchFilterRow(
                hintText: 'Buscar por código o usuario...',
                onSearchChanged: _onSearchChanged,
                onFilterTap: _showFilters,
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: Text(
                'Reabastecimientos registrados',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ),
            if (provider.listStatus == ViewStatus.initial ||
                provider.listStatus == ViewStatus.loading)
              const SizedBox(
                height: 180,
                child: LoadingView(message: 'Cargando reabastecimientos...'),
              )
            else if (provider.listStatus == ViewStatus.error)
              SizedBox(
                height: 220,
                child: ErrorView(
                  errorMessage: provider.listError ??
                      'No se pudieron cargar los reabastecimientos.',
                  onRetry: () => _loadPage(_currentPage),
                ),
              )
            else ...[
              ReabastecimientosLista(
                reabastecimientos:
                    page?.restocks ?? const <RestockListItemModel>[],
              ),
              if (page != null && page.totalPages > 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: ProductoPaginationRow(
                    currentPage: page.currentPage,
                    totalPages: page.totalPages,
                    onPrevious: page.currentPage > 1
                        ? () => _loadPage(page.currentPage - 1)
                        : null,
                    onNext: page.currentPage < page.totalPages
                        ? () => _loadPage(page.currentPage + 1)
                        : null,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatistics(RestocksProvider provider) {
    final stats = provider.statistics;
    if (stats == null) {
      if (provider.statisticsStatus == ViewStatus.error) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: TextButton.icon(
            onPressed: provider.loadStatistics,
            icon: const Icon(Icons.refresh),
            label: Text(
              provider.statisticsError ??
                  'No se pudieron cargar las estadísticas.',
            ),
          ),
        );
      }
      return const SizedBox(
        height: 72,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: HStatCard(
              title: 'Reabastecimientos del mes',
              value: '${stats.restocksThisMonth}',
              bgColor: AppToneColors.soft[AppTone.purple]!,
              iconColor: AppToneColors.intense[AppTone.purple]!,
              icon: Icons.local_shipping_outlined,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: HStatCard(
              title: 'Inversión del mes',
              value: 'C\$${stats.totalInvestmentThisMonth.toStringAsFixed(0)}',
              bgColor: AppToneColors.soft[AppTone.yellow]!,
              iconColor: AppToneColors.intense[AppTone.yellow]!,
              icon: Icons.attach_money,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: HStatCard(
              title: 'Lotes creados',
              value: '${stats.batchesCreatedThisMonth}',
              bgColor: AppToneColors.soft[AppTone.blue]!,
              iconColor: AppToneColors.intense[AppTone.blue]!,
              icon: Icons.inventory_2_outlined,
            ),
          ),
        ],
      ),
    );
  }
}
