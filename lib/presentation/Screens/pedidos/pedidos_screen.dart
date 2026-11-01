import 'dart:async';

import 'package:flutter/material.dart';
import 'package:herrera_system/core/constants/view_status.dart';
import 'package:herrera_system/data/models/order_list_item_model.dart';
import 'package:herrera_system/presentation/providers/orders_provider.dart';
import 'package:provider/provider.dart';

import '../../Screens/productos/widgets/productos_widgets.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/search_filter_row.dart';
import '../transacciones/widgets/transaccion_tipo_selector.dart';
import 'widgets/pedidos_widgets.dart';

class PedidosScreen extends StatefulWidget {
  const PedidosScreen({super.key});

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
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
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadPage(1);
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
    return context.read<OrdersProvider>().loadOrders(
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
      case 'Hoy':
        return (today, today);
      case 'Últimos 7 días':
        return (today.subtract(const Duration(days: 6)), today);
      case 'Este mes':
        return (DateTime(now.year, now.month), today);
      case 'Este año':
        return (DateTime(now.year), today);
      default:
        return (null, null);
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
    var range = _selectedDateRange;
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
                'Filtrar pedidos',
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
                value: range,
                isExpanded: true,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: AppColors.lavender,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                items: _dateRanges
                    .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                    .toList(),
                onChanged: (value) =>
                    setModalState(() => range = value ?? _dateRanges.first),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() => _selectedDateRange = _dateRanges.first);
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
                        setState(() => _selectedDateRange = range);
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
    final provider = context.watch<OrdersProvider>();
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
          'Pedidos',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _loadPage(_currentPage),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(
            top: AppSpacing.md,
            bottom: AppSpacing.xl,
          ),
          children: [
            TransaccionTipoSelector(
              tipoSeleccionado: 'Pedido',
              onSeleccionar: (type) {
                final route = switch (type) {
                  'Venta' => AppRoutes.ventas,
                  'Pedido' => AppRoutes.pedidos,
                  'Reabastecimiento' => AppRoutes.reabastecimientos,
                  _ => throw ArgumentError.value(type),
                };
                if (route != AppRoutes.pedidos) {
                  Navigator.of(context).pushReplacementNamed(route);
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: SearchFilterRow(
                hintText: 'Buscar por código o cliente...',
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
                'Pedidos registrados',
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
                child: LoadingView(message: 'Cargando pedidos...'),
              )
            else if (provider.listStatus == ViewStatus.error)
              SizedBox(
                height: 220,
                child: ErrorView(
                  errorMessage:
                      provider.listError ?? 'No se pudieron cargar los pedidos.',
                  onRetry: () => _loadPage(_currentPage),
                ),
              )
            else ...[
              PedidosLista(
                pedidos: page?.orders ?? const <OrderListItemModel>[],
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
}
