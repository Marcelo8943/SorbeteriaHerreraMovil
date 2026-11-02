import 'dart:async';

import 'package:flutter/material.dart';
import 'package:herrera_system/core/constants/view_status.dart';
import 'package:herrera_system/data/models/sale_list_item_model.dart';
import 'package:herrera_system/presentation/providers/sales_provider.dart';
import 'package:provider/provider.dart';

import '../../Screens/productos/widgets/productos_widgets.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/error_view.dart';
import '../../widgets/h_stat_card.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/search_filter_row.dart';
import '../transacciones/widgets/transaccion_tipo_selector.dart';
import 'widgets/ventas_widgets.dart';

class VentasScreen extends StatefulWidget {
  const VentasScreen({super.key});

  @override
  State<VentasScreen> createState() => _VentasScreenState();
}

class _VentasScreenState extends State<VentasScreen> {
  static const int _pageSize = 10;
  static const List<String> _dateRanges = [
    'Todas las fechas',
    'Hoy',
    'Últimos 7 días',
    'Este mes',
    'Este año',
  ];
  int _currentPage = 1;
  String _search = '';
  String _selectedDateRange = 'Todas las fechas';
  int? _selectedSaleTypeId;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = context.read<SalesProvider>();
      provider.loadStats();
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
    final dateBounds = _getDateBounds(_selectedDateRange);
    return context.read<SalesProvider>().loadSales(
      page: page,
      pageSize: _pageSize,
      startDate: dateBounds.$1,
      endDate: dateBounds.$2,
      saleTypeId: _selectedSaleTypeId,
      search: _search.isEmpty ? null : _search,
    );
  }

  (DateTime?, DateTime?) _getDateBounds(String range) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    switch (range) {
      case 'Hoy':
        return (today, today);
      case 'Últimos 7 días':
        return (today.subtract(const Duration(days: 6)), today);
      case 'Este mes':
        return (DateTime(now.year, now.month), today);
      case 'Este año':
        return (DateTime(now.year), today);
      default:
        // La API interpreta fechas nulas como "este mes". Usa sus límites
        // admitidos para que "Todas las fechas" consulte todo el historial.
        return (DateTime(1753, 1, 1), DateTime(9999, 12, 31));
    }
  }

  void _onSearchChanged(String value) {
    _search = value.trim();
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) _loadPage(1);
    });
  }

  void _showFilters(SalesProvider provider) {
    var dateRange = _selectedDateRange;
    var saleTypeValue = _selectedSaleTypeId?.toString() ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                'Filtrar ventas',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              const Text('Tipo de venta'),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: saleTypeValue,
                isExpanded: true,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: AppColors.lavender,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                items: [
                  const DropdownMenuItem<String>(
                    value: '',
                    child: Text('Todos los tipos'),
                  ),
                  ...provider.availableSaleTypes.entries.map(
                    (entry) => DropdownMenuItem<String>(
                      value: entry.key.toString(),
                      child: Text(entry.value),
                    ),
                  ),
                ],
                onChanged: (value) => setModalState(() => saleTypeValue = value ?? ''),
              ),
              if (provider.availableSaleTypes.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text(
                    'Los tipos se mostrarán cuando la API devuelva ventas.',
                    style: TextStyle(color: AppColors.muted, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 16),
              const Text('Fecha'),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: dateRange,
                isExpanded: true,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: AppColors.lavender,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                items: _dateRanges
                    .map((range) => DropdownMenuItem(value: range, child: Text(range)))
                    .toList(),
                onChanged: (value) =>
                    setModalState(() => dateRange = value ?? _dateRanges.first),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedDateRange = _dateRanges.first;
                          _selectedSaleTypeId = null;
                        });
                        Navigator.pop(modalContext);
                        _loadPage(1);
                      },
                      child: const Text('Limpiar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        setState(() {
                          _selectedDateRange = dateRange;
                          _selectedSaleTypeId = int.tryParse(saleTypeValue);
                        });
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
    final provider = context.watch<SalesProvider>();
    final page = provider.page;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.ink),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Ventas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([provider.loadStats(), _loadPage(_currentPage)]);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(
            top: AppSpacing.md,
            bottom: AppSpacing.xl,
          ),
          children: [
            TransaccionTipoSelector(
              tipoSeleccionado: 'Venta',
              onSeleccionar: (tipo) {
                final route = switch (tipo) {
                  'Venta' => AppRoutes.ventas,
                  'Pedido' => AppRoutes.pedidos,
                  'Reabastecimiento' => AppRoutes.reabastecimientos,
                  _ => throw ArgumentError.value(tipo),
                };
                if (route != AppRoutes.ventas) {
                  Navigator.of(context).pushReplacementNamed(route);
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),
            _buildStats(provider),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: SearchFilterRow(
                hintText: 'Buscar por código o cliente...',
                onSearchChanged: _onSearchChanged,
                onFilterTap: () => _showFilters(provider),
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
                'Ventas registradas',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ),
            if (provider.listStatus == ViewStatus.initial ||
                provider.listStatus == ViewStatus.loading)
              const SizedBox(height: 180, child: LoadingView(message: 'Cargando ventas...'))
            else if (provider.listStatus == ViewStatus.error)
              SizedBox(
                height: 220,
                child: ErrorView(
                  errorMessage: provider.listError ?? 'No se pudieron cargar las ventas.',
                  onRetry: () => _loadPage(_currentPage),
                ),
              )
            else ...[
              VentasLista(ventas: page?.sales ?? const <SaleListItemModel>[]),
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

  Widget _buildStats(SalesProvider provider) {
    final stats = provider.stats;
    if (provider.statsStatus == ViewStatus.loading || stats == null) {
      if (provider.statsStatus == ViewStatus.error) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: TextButton.icon(
            onPressed: provider.loadStats,
            icon: const Icon(Icons.refresh),
            label: Text(provider.statsError ?? 'No se pudieron cargar las estadísticas.'),
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
              title: 'Ventas del mes',
              value: '${stats.salesThisMonth}',
              bgColor: AppToneColors.soft[AppTone.teal]!,
              iconColor: AppToneColors.intense[AppTone.teal]!,
              icon: Icons.point_of_sale_outlined,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: HStatCard(
              title: 'Ingresos del mes',
              value: 'C\$${stats.totalIncomeThisMonth.toStringAsFixed(0)}',
              bgColor: AppToneColors.soft[AppTone.yellow]!,
              iconColor: AppToneColors.intense[AppTone.yellow]!,
              icon: Icons.attach_money,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: HStatCard(
              title: 'Productos vendidos',
              value: '${stats.productsSoldThisMonth}',
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
