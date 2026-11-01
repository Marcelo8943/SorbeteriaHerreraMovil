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
import '../transacciones/widgets/transaccion_tipo_selector.dart';
import 'widgets/ventas_widgets.dart';

class VentasScreen extends StatefulWidget {
  const VentasScreen({super.key});

  @override
  State<VentasScreen> createState() => _VentasScreenState();
}

class _VentasScreenState extends State<VentasScreen> {
  static const int _pageSize = 10;
  int _currentPage = 1;
  String _search = '';
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
    return context.read<SalesProvider>().loadSales(
      page: page,
      pageSize: _pageSize,
      search: _search.isEmpty ? null : _search,
    );
  }

  void _onSearchChanged(String value) {
    _search = value.trim();
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) _loadPage(1);
    });
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
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.lavender,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.muted),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        onChanged: _onSearchChanged,
                        decoration: const InputDecoration(
                          hintText: 'Buscar por código o cliente...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
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
