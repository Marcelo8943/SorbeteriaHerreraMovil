import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../models/mocks/mock_movimientos.dart';
import '../../theme/app_theme.dart';
import '../../widgets/search_filter_row.dart';
import 'widgets/movimientos_stats_row.dart';
import 'widgets/movimiento_card.dart';

class MovimientosScreen extends StatefulWidget {
  const MovimientosScreen({super.key});

  @override
  State<MovimientosScreen> createState() => _MovimientosScreenState();
}

class _MovimientosScreenState extends State<MovimientosScreen> {
  int _currentPage = 1;
  static const int _itemsPerPage = 10;

  String _searchQuery = '';
  String _filtroTipo = 'Todos';
  String _filtroUbicacion = 'Todas';
  String _filtroRangoFecha = 'Todos';

  static const List<String> _tiposMovimiento = [
    'Todos',
    'Transferencia',
    'Ajuste Positivo',
    'Ajuste Negativo',
  ];

  static const List<String> _ubicaciones = [
    'Todas',
    'Bodega',
    'Reserva',
    'Mostrador',
  ];

  static const List<String> _rangosFecha = [
    'Todos',
    'Hoy',
    'Últimos 7 días',
    'Este mes',
    'Este año',
  ];

  // ── Filtrado dinámico ─────────────────────────────────────────────────────
  List<Movimiento> get _filteredMovimientos {
    return mockMovimientos.where((m) {
      final matchSearch =
          _searchQuery.isEmpty ||
          m.producto.toLowerCase().contains(_searchQuery) ||
          m.folio.toLowerCase().contains(_searchQuery) ||
          m.tipo.toLowerCase().contains(_searchQuery);

      final matchTipo = _filtroTipo == 'Todos' || m.tipo == _filtroTipo;

      final matchUbicacion =
          _filtroUbicacion == 'Todas' ||
          m.origen == _filtroUbicacion ||
          m.destino == _filtroUbicacion ||
          m.ubicacion == _filtroUbicacion;

      final matchFecha = _evaluarRangoFecha(m, _filtroRangoFecha);

      return matchSearch && matchTipo && matchUbicacion && matchFecha;
    }).toList();
  }

  bool _evaluarRangoFecha(Movimiento m, String rango) {
    switch (rango) {
      case 'Hoy':
        return m.fecha == mockFechaHoy || m.fechaRelativa.startsWith('hace');
      case 'Últimos 7 días':
        return m.fechaRelativa.startsWith('hace') ||
            m.fechaRelativa == 'ayer' ||
            m.fecha.endsWith('/08/2026') &&
                (m.fecha.startsWith('10') ||
                    m.fecha.startsWith('11') ||
                    m.fecha.startsWith('12') ||
                    m.fecha.startsWith('13') ||
                    m.fecha.startsWith('14') ||
                    m.fecha.startsWith('15') ||
                    m.fecha.startsWith('16'));
      case 'Este mes':
        return m.fecha.contains('/08/2026');
      case 'Este año':
        return m.fecha.contains('/2026');
      case 'Todos':
      default:
        return true;
    }
  }

  // ── Modal de filtros ──────────────────────────────────────────────────────
  void _showFilterModal() {
    String tempTipo = _filtroTipo;
    String tempUbi = _filtroUbicacion;
    String tempRango = _filtroRangoFecha;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle superior
                    Center(
                      child: Container(
                        width: 44,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: AppColors.line,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // Encabezado
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
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.lavender,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 18,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Campo 1: Tipo de movimiento
                    const _FilterLabel('Tipo de movimiento'),
                    const SizedBox(height: 6),
                    _FilterDropdown(
                      value: tempTipo,
                      items: _tiposMovimiento,
                      onChanged: (val) => setModalState(() => tempTipo = val!),
                    ),
                    const SizedBox(height: 16),

                    // Campo 2: Ubicación
                    const _FilterLabel('Ubicación'),
                    const SizedBox(height: 6),
                    _FilterDropdown(
                      value: tempUbi,
                      items: _ubicaciones,
                      onChanged: (val) => setModalState(() => tempUbi = val!),
                    ),
                    const SizedBox(height: 16),

                    // Campo 3: Rango de fecha
                    const _FilterLabel('Rango de fecha'),
                    const SizedBox(height: 6),
                    _FilterDropdown(
                      value: tempRango,
                      items: _rangosFecha,
                      onChanged: (val) => setModalState(() => tempRango = val!),
                    ),
                    const SizedBox(height: 24),

                    // Botones Limpiar / Aplicar
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setModalState(() {
                                tempTipo = 'Todos';
                                tempUbi = 'Todas';
                                tempRango = 'Todos';
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.lavender,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _filtroTipo = tempTipo;
                                _filtroUbicacion = tempUbi;
                                _filtroRangoFecha = tempRango;
                                _currentPage = 1;
                              });
                              Navigator.pop(context);
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
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int movimientosHoy = mockMovimientos
        .where((m) => m.fecha == mockFechaHoy)
        .length;
    final int transferenciasHoy = mockMovimientos
        .where((m) => m.fecha == mockFechaHoy && m.tipo == 'Transferencia')
        .length;
    final int ajustesHoy = mockMovimientos
        .where((m) => m.fecha == mockFechaHoy && m.tipo != 'Transferencia')
        .length;

    final filtered = _filteredMovimientos;

    final int totalPages = filtered.isEmpty
        ? 1
        : (filtered.length / _itemsPerPage).ceil();
    final int effectivePage = (_currentPage > totalPages && totalPages > 0)
        ? totalPages
        : _currentPage;
    final int startIndex = (effectivePage - 1) * _itemsPerPage;
    final int endIndex = (startIndex + _itemsPerPage < filtered.length)
        ? startIndex + _itemsPerPage
        : filtered.length;
    final displayedMovimientos = filtered.isEmpty
        ? <Movimiento>[]
        : filtered.sublist(startIndex, endIndex);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: AppSpacing.md, bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Subheader de fecha ───────────────────────────────────────
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(
                'Hoy · domingo 16/08',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── KPI Cards ────────────────────────────────────────────────
            MovimientosStatsRow(
              movimientosHoy: movimientosHoy,
              transferenciasHoy: transferenciasHoy,
              ajustesHoy: ajustesHoy,
            ),
            const SizedBox(height: AppSpacing.md),

            // ── Barra de búsqueda y filtro ───────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: SearchFilterRow(
                hintText: 'Buscar movimiento, producto o folio...',
                onSearchChanged: (query) {
                  setState(() {
                    _searchQuery = query.trim().toLowerCase();
                    _currentPage = 1;
                  });
                },
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
                    'Movimientos recientes',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(width: 8),
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
                      '${filtered.length}',
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

            // ── Lista de cards ───────────────────────────────────────────
            if (displayedMovimientos.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    'Sin resultados para los filtros aplicados.',
                    style: TextStyle(color: AppColors.muted, fontSize: 13),
                  ),
                ),
              )
            else
              Column(
                children: displayedMovimientos
                    .map((m) => MovimientoCard(movimiento: m))
                    .toList(),
              ),
            const SizedBox(height: 12),

            // ── Paginación ───────────────────────────────────────────────
            if (totalPages > 1)
              _MovimientosPaginationRow(
                currentPage: effectivePage,
                totalPages: totalPages,
                onPrevious: () {
                  if (effectivePage > 1) {
                    setState(() => _currentPage = effectivePage - 1);
                  }
                },
                onNext: () {
                  if (effectivePage < totalPages) {
                    setState(() => _currentPage = effectivePage + 1);
                  }
                },
              ),
          ],
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
        'Movimientos de Inventario',
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
                (val) => DropdownMenuItem(
                  value: val,
                  child: Text(
                    val,
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

class _MovimientosPaginationRow extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _MovimientosPaginationRow({
    required this.currentPage,
    required this.totalPages,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final bool canGoPrev = currentPage > 1;
    final bool canGoNext = currentPage < totalPages;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton.icon(
            onPressed: canGoPrev ? onPrevious : null,
            icon: Icon(
              Icons.chevron_left,
              size: 18,
              color: canGoPrev ? AppColors.ink : AppColors.muted,
            ),
            label: Text(
              'Anterior',
              style: TextStyle(
                color: canGoPrev ? AppColors.ink : AppColors.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.line),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: canGoNext ? AppColors.primary : AppColors.line,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}
