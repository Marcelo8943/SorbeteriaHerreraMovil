import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../models/mocks/mock_inventario.dart';
import '../../theme/app_theme.dart';
import '../../widgets/search_filter_row.dart';
import 'widgets/inventario_stats_row.dart';
import 'widgets/inventario_producto_card.dart';

class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  // ── Paginación ────────────────────────────────────────────────────────────
  int _currentPage = 1;
  static const int _itemsPerPage = 10;

  // ── Estado de filtros activos ─────────────────────────────────────────────
  String _searchQuery = '';
  String _filtroLinea = 'Todas';
  String _filtroSabor = 'Todos';
  String _filtroPresentacion = 'Todas';
  String _filtroEstado = 'Todos';

  // ── Opciones de cada filtro extraídas de las pantallas de diseño ────────────
  static const List<String> _lineas = [
    'Todas',
    'Tradicionales',
    'Lights',
    'Nieves',
    'Paletas',
    'Fantasía',
    'Especiales',
  ];

  static const List<String> _sabores = [
    'Todos',
    'Albaricoque',
    'Almendra',
    'Borrachito',
    'Café',
    'Coco',
    'Chocolate',
    'Chicle',
    'Crema',
    'Fresa',
    'Frijolito',
    'Guanábana',
    'Limón',
    'Lúcuma',
    'Mango',
    'Maracuyá',
    'Menta',
    'Mora',
    'Nancite',
    'Tamarindo',
    'Vainilla',
  ];

  static const List<String> _presentaciones = [
    'Todas',
    '4 Onzas',
    '8 Onzas',
    '1/4 Galón',
    '1/2 Galón',
    '1 Galón',
    'Litro',
    '1 libra',
  ];

  static const List<String> _estados = ['Todos', 'OK', 'Stock bajo'];

  List<InventarioProducto> get _filteredProductos {
    return mockInventario.where((p) {
      final matchSearch =
          _searchQuery.isEmpty ||
          p.nombreProducto.toLowerCase().contains(_searchQuery);

      final matchLinea =
          _filtroLinea == 'Todas' ||
          p.linea.toLowerCase() == _filtroLinea.toLowerCase() ||
          (_filtroLinea == 'Tradicionales' &&
              p.linea.toLowerCase() == 'tradicional') ||
          (_filtroLinea == 'Fantasía' && p.linea.toLowerCase() == 'fantacia');

      final matchSabor =
          _filtroSabor == 'Todos' ||
          p.sabor.toLowerCase() == _filtroSabor.toLowerCase() ||
          p.sabor.toLowerCase().contains(_filtroSabor.toLowerCase()) ||
          _filtroSabor.toLowerCase().contains(p.sabor.toLowerCase());

      final matchPresentacion =
          _filtroPresentacion == 'Todas' ||
          p.presentacion.toLowerCase() == _filtroPresentacion.toLowerCase();

      final matchEstado =
          _filtroEstado == 'Todos' ||
          (_filtroEstado == 'OK' && !p.stockBajo) ||
          (_filtroEstado == 'Stock bajo' && p.stockBajo);

      return matchSearch &&
          matchLinea &&
          matchSabor &&
          matchPresentacion &&
          matchEstado;
    }).toList();
  }

  void _showFilterModal() {
    String tempLinea = _filtroLinea;
    String tempSabor = _filtroSabor;
    String tempPresentacion = _filtroPresentacion;
    String tempEstado = _filtroEstado;

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
                    // ── Pill handle superior ──────────────────────────────
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

                    // ── Encabezado ────────────────────────────────────────
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

                    // ── Línea ─────────────────────────────────────────────
                    const _FilterLabel('Línea'),
                    const SizedBox(height: 6),
                    _FilterDropdown(
                      value: tempLinea,
                      items: _lineas,
                      onChanged: (val) => setModalState(() => tempLinea = val!),
                    ),
                    const SizedBox(height: 16),

                    // ── Sabor ─────────────────────────────────────────────
                    const _FilterLabel('Sabor'),
                    const SizedBox(height: 6),
                    _FilterDropdown(
                      value: tempSabor,
                      items: _sabores,
                      onChanged: (val) => setModalState(() => tempSabor = val!),
                    ),
                    const SizedBox(height: 16),

                    // ── Presentación ──────────────────────────────────────
                    const _FilterLabel('Presentación'),
                    const SizedBox(height: 6),
                    _FilterDropdown(
                      value: tempPresentacion,
                      items: _presentaciones,
                      onChanged: (val) =>
                          setModalState(() => tempPresentacion = val!),
                    ),
                    const SizedBox(height: 16),

                    // ── Estado ────────────────────────────────────────────
                    const _FilterLabel('Estado'),
                    const SizedBox(height: 6),
                    _FilterDropdown(
                      value: tempEstado,
                      items: _estados,
                      onChanged: (val) =>
                          setModalState(() => tempEstado = val!),
                    ),
                    const SizedBox(height: 24),

                    // ── Botones ───────────────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setModalState(() {
                                tempLinea = 'Todas';
                                tempSabor = 'Todos';
                                tempPresentacion = 'Todas';
                                tempEstado = 'Todos';
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
                              // Aplica los filtros a la pantalla y vuelve a pág 1
                              setState(() {
                                _filtroLinea = tempLinea;
                                _filtroSabor = tempSabor;
                                _filtroPresentacion = tempPresentacion;
                                _filtroEstado = tempEstado;
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
    final int stockBajoCount = mockInventario.where((p) => p.stockBajo).length;

    // Filtra el mock con los filtros activos
    final filtered = _filteredProductos;

    // Paginación sobre la lista filtrada
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
    final displayedProductos = filtered.isEmpty
        ? <InventarioProducto>[]
        : filtered.sublist(startIndex, endIndex);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: AppSpacing.md, bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 1. KPI Cards ─────────────────────────────────────────────
            InventarioStatsRow(
              stockBajoCount: stockBajoCount,
              lotesPorVencer: mockLotesPorVencer,
            ),

            const SizedBox(height: AppSpacing.md),

            // ── 2. Barra de búsqueda + filtro ────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: SearchFilterRow(
                hintText: 'Buscar producto...',
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

            // ── 3. Encabezado "Stock por producto" ────────────────────────
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

            // ── 4. Lista filtrada y paginada ──────────────────────────────
            if (displayedProductos.isEmpty)
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
                children: displayedProductos
                    .map((p) => InventarioProductoCard(producto: p))
                    .toList(),
              ),

            const SizedBox(height: 12),

            // ── 5. Paginación ─────────────────────────────────────────────
            if (totalPages > 1)
              _InventarioPaginationRow(
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
        'Inventario',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      ),
    );
  }
}

// ── Etiqueta de sección del filtro ────────────────────────────────────────────
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

// ── Dropdown reutilizable para el modal de filtros ────────────────────────────
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

// ── Fila de paginación ────────────────────────────────────────────────────────
class _InventarioPaginationRow extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _InventarioPaginationRow({
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
              side: BorderSide(color: AppColors.line),
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
