import 'dart:async';

import 'package:flutter/material.dart';
import 'package:herrera_system/core/constants/view_status.dart';
import 'package:herrera_system/data/models/log_model.dart';
import 'package:herrera_system/presentation/providers/logs_provider.dart';
import 'package:herrera_system/presentation/routes/app_routes.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../widgets/error_view.dart';
import '../../widgets/h_stat_card.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/search_filter_row.dart';
import '../productos/widgets/productos_widgets.dart';
import 'widgets/log_card.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  static const int _pageSize = 10;
  static const List<String> _actions = [
    'Todos',
    'Consultar',
    'Crear',
    'Actualizar',
    'Cambiar estado',
    'Eliminar',
  ];
  static const List<String> _modules = [
    'Todos',
    'Autenticación',
    'Usuarios',
    'Roles',
    'Clientes',
    'Productos',
    'Sabores',
    'Líneas',
    'Presentaciones',
    'Pedidos',
    'Ventas',
    'Reabastecimientos',
    'Inventario',
    'Movimientos',
    'Archivos',
    'Negocio',
  ];
  static const List<String> _results = ['Todos', 'Exitosos', 'Fallidos'];
  static const List<String> _dateRanges = [
    'Todos',
    'Hoy',
    'Últimos 7 días',
    'Este mes',
    'Este año',
  ];

  static const Map<String, String> _moduleRoutes = {
    'Autenticación': 'Auth',
    'Usuarios': 'Users',
    'Roles': 'Roles',
    'Clientes': 'Customers',
    'Productos': 'Products',
    'Sabores': 'Flavors',
    'Líneas': 'Lines',
    'Presentaciones': 'Presentations',
    'Pedidos': 'Orders',
    'Ventas': 'Sales',
    'Reabastecimientos': 'Restocks',
    'Inventario': 'Inventory',
    'Movimientos': 'InventoryMovements',
    'Archivos': 'Uploads',
    'Negocio': 'BusinessProfile',
  };

  int _currentPage = 1;
  String _searchQuery = '';
  String _selectedAction = 'Todos';
  String _selectedModule = 'Todos';
  String _selectedResult = 'Todos';
  String _selectedDateRange = 'Todos';
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
    final dateBounds = _getDateBounds(_selectedDateRange);
    final method = switch (_selectedAction) {
      'Consultar' => 'GET',
      'Crear' => 'POST',
      'Actualizar' => 'PUT',
      'Cambiar estado' => 'PATCH',
      'Eliminar' => 'DELETE',
      _ => null,
    };
    return context.read<LogsProvider>().loadLogs(
      page: page,
      pageSize: _pageSize,
      modulo: _selectedModule == 'Todos'
          ? null
          : _moduleRoutes[_selectedModule],
      method: method,
      userId: _searchQuery.isEmpty ? null : _searchQuery,
      success: switch (_selectedResult) {
        'Exitosos' => true,
        'Fallidos' => false,
        _ => null,
      },
      fromDate: dateBounds.$1,
      toDate: dateBounds.$2,
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
    setState(() {
      _searchQuery = value.trim();
      _currentPage = 1;
    });
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) _loadPage(1);
    });
  }

  void _showFilterModal() {
    var action = _selectedAction;
    var module = _selectedModule;
    var result = _selectedResult;
    var dateRange = _selectedDateRange;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) => StatefulBuilder(
        builder: (modalContext, setModalState) => SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filtrar logs',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(modalContext),
                      icon: const Icon(Icons.close, color: AppColors.ink),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const _FilterLabel('Módulo'),
                const SizedBox(height: 6),
                _FilterDropdown(
                  value: module,
                  items: _modules,
                  onChanged: (value) =>
                      setModalState(() => module = value ?? 'Todos'),
                ),
                const SizedBox(height: 16),
                const _FilterLabel('Tipo de acción'),
                const SizedBox(height: 6),
                _FilterDropdown(
                  value: action,
                  items: _actions,
                  onChanged: (value) =>
                      setModalState(() => action = value ?? 'Todos'),
                ),
                const SizedBox(height: 16),
                const _FilterLabel('Resultado'),
                const SizedBox(height: 6),
                _FilterDropdown(
                  value: result,
                  items: _results,
                  onChanged: (value) =>
                      setModalState(() => result = value ?? 'Todos'),
                ),
                const SizedBox(height: 16),
                const _FilterLabel('Rango de fecha'),
                const SizedBox(height: 6),
                _FilterDropdown(
                  value: dateRange,
                  items: _dateRanges,
                  onChanged: (value) =>
                      setModalState(() => dateRange = value ?? 'Todos'),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedAction = 'Todos';
                            _selectedModule = 'Todos';
                            _selectedResult = 'Todos';
                            _selectedDateRange = 'Todos';
                            _currentPage = 1;
                          });
                          Navigator.pop(modalContext);
                          _loadPage(1);
                        },
                        child: const Text('Limpiar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedAction = action;
                            _selectedModule = module;
                            _selectedResult = result;
                            _selectedDateRange = dateRange;
                            _currentPage = 1;
                          });
                          Navigator.pop(modalContext);
                          _loadPage(1);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Aplicar',
                          style: TextStyle(color: AppColors.textOnPrimary),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LogsProvider>();
    final page = provider.page;
    final logs = page?.logs ?? const <LogModel>[];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: () => _loadPage(_currentPage),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: AppSpacing.md, bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (page != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: SizedBox(
                    height: 76,
                    child: HStatCard(
                      title: 'Eventos encontrados',
                      value: '${page.totalRecords}',
                      bgColor: AppToneColors.soft[AppTone.teal]!,
                      iconColor: AppToneColors.intense[AppTone.teal]!,
                      icon: Icons.description_outlined,
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.md),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: SearchFilterRow(
                  hintText: 'Buscar por  usuario...',
                  onSearchChanged: _onSearchChanged,
                  onFilterTap: _showFilterModal,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    const Text(
                      'Eventos recientes',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (page != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppToneColors.soft[AppTone.teal],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${page.totalRecords}',
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
              const SizedBox(height: 4),
              if (provider.status == ViewStatus.initial ||
                  provider.status == ViewStatus.loading)
                const Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: LoadingView(message: 'Cargando logs...'),
                )
              else if (provider.status == ViewStatus.error)
                ErrorView(
                  errorMessage:
                      provider.errorMessage ??
                      'No se pudieron cargar los logs.',
                  onRetry: () => _loadPage(_currentPage),
                )
              else if (logs.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text(
                      'No hay logs para los filtros aplicados.',
                      style: TextStyle(color: AppColors.muted, fontSize: 13),
                    ),
                  ),
                )
              else
                Column(
                  children: logs
                      .map(
                        (log) => LogCard(
                          log: log,
                          onTap: () => Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.logDetalle, arguments: log.id),
                        ),
                      )
                      .toList(),
                ),
              if (page != null && page.totalPages > 1)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
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
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
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
        'Logs del Sistema',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      ),
    );
  }
}

class _FilterLabel extends StatelessWidget {
  final String text;

  const _FilterLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _FilterDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.lavender,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: AppColors.card,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.muted),
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
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
}
