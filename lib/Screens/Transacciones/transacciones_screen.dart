import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../models/mocks/mock_transacciones.dart';
import '../../theme/app_theme.dart';
import '../../widgets/h_stat_card.dart';
import '../../widgets/search_filter_row.dart';
import '../Productos/widgets/productos_widgets.dart';
import 'widgets/transaccion_card.dart';

class TransaccionesScreen extends StatefulWidget {
  const TransaccionesScreen({super.key});

  @override
  State<TransaccionesScreen> createState() => _TransaccionesScreenState();
}

class _TransaccionesScreenState extends State<TransaccionesScreen> {
  int _currentPage = 1;
  static const int _itemsPerPage = 10;

  String _searchQuery = '';
  String _filtroTipo = 'Todos';
  String _filtroRangoFecha = 'Hoy';
  String _filtroTipoVenta = 'Todos';

  static const List<String> _tiposTransaccion = [
    'Todos',
    'Venta',
    'Pedido',
    'Reabastecimiento',
  ];

  static const List<String> _rangosFecha = [
    'Todos',
    'Hoy',
    'Últimos 7 días',
    'Este mes',
    'Este año',
  ];

  static const List<String> _tiposVenta = ['Todos', 'Detalle', 'Mayoreo'];

  List<Transaccion> get _filteredTransacciones {
    return mockTransacciones.where((t) {
      // 1. Búsqueda por texto (folio, relacionado o productos)
      final query = _searchQuery.toLowerCase();
      final matchSearch =
          query.isEmpty ||
          t.folio.toLowerCase().contains(query) ||
          t.relacionado.toLowerCase().contains(query) ||
          t.items.any((i) => i.producto.toLowerCase().contains(query));

      final matchTipo = _filtroTipo == 'Todos' || t.tipo == _filtroTipo;

      final matchFecha = _evaluarRangoFecha(t, _filtroRangoFecha);

      final matchTipoVenta =
          _filtroTipoVenta == 'Todos' ||
          (t.tipoVenta != null && t.tipoVenta == _filtroTipoVenta);

      return matchSearch && matchTipo && matchFecha && matchTipoVenta;
    }).toList();
  }

  bool _evaluarRangoFecha(Transaccion t, String rango) {
    switch (rango) {
      case 'Hoy':
        return t.fecha.startsWith('16/08/26') ||
            t.fechaRelativa.startsWith('hace');
      case 'Últimos 7 días':
        return t.fechaRelativa.startsWith('hace') ||
            t.fechaRelativa == 'ayer' ||
            (t.fecha.contains('/08/26') &&
                (t.fecha.startsWith('10') ||
                    t.fecha.startsWith('11') ||
                    t.fecha.startsWith('12') ||
                    t.fecha.startsWith('13') ||
                    t.fecha.startsWith('14') ||
                    t.fecha.startsWith('15') ||
                    t.fecha.startsWith('16')));
      case 'Este mes':
        return t.fecha.contains('/08/26');
      case 'Este año':
        return t.fecha.contains('/26');
      case 'Todos':
      default:
        return true;
    }
  }

  void _showFilterModal() {
    String tempTipo = _filtroTipo;
    String tempRango = _filtroRangoFecha;
    String tempTipoVenta = _filtroTipoVenta;

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
                          'Filtrar transacciones',
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

                    const _FilterLabel('Tipo de transacción'),
                    const SizedBox(height: 6),
                    _FilterDropdown(
                      value: tempTipo,
                      items: _tiposTransaccion,
                      onChanged: (val) => setModalState(() => tempTipo = val!),
                    ),
                    const SizedBox(height: 16),

                    const _FilterLabel('Rango de fecha'),
                    const SizedBox(height: 6),
                    _FilterDropdown(
                      value: tempRango,
                      items: _rangosFecha,
                      onChanged: (val) => setModalState(() => tempRango = val!),
                    ),
                    const SizedBox(height: 16),

                    const _FilterLabel(
                      'Tipo de venta (opcional, no confirmado en API)',
                    ),
                    const SizedBox(height: 6),
                    _FilterDropdown(
                      value: tempTipoVenta,
                      items: _tiposVenta,
                      onChanged: (val) =>
                          setModalState(() => tempTipoVenta = val!),
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
                                tempRango = 'Todos';
                                tempTipoVenta = 'Todos';
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
                                _filtroRangoFecha = tempRango;
                                _filtroTipoVenta = tempTipoVenta;
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
    final transaccionesEnRango = mockTransacciones
        .where((t) => _evaluarRangoFecha(t, _filtroRangoFecha))
        .toList();

    final int ventasCount = transaccionesEnRango
        .where((t) => t.tipo == 'Venta')
        .length;
    final int pedidosCount = transaccionesEnRango
        .where((t) => t.tipo == 'Pedido')
        .length;
    final int reabastecCount = transaccionesEnRango
        .where((t) => t.tipo == 'Reabastecimiento')
        .length;

    final filtered = _filteredTransacciones;
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
    final displayedTransacciones = filtered.isEmpty
        ? <Transaccion>[]
        : filtered.sublist(startIndex, endIndex);

    final String sectionTitle = _filtroRangoFecha == 'Todos'
        ? 'Todas las transacciones'
        : 'Transacciones de  $_filtroRangoFecha';

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
          'Transacciones',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: AppSpacing.md, bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 14),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: [
                  HStatCard(
                    title: 'Ventas',
                    value: ventasCount.toString(),
                    bgColor: AppToneColors.soft[AppTone.teal]!,
                    iconColor: AppToneColors.intense[AppTone.teal]!,
                    icon: Icons.attach_money,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  HStatCard(
                    title: 'Pedidos',
                    value: pedidosCount.toString(),
                    bgColor: AppToneColors.soft[AppTone.blue]!,
                    iconColor: AppToneColors.intense[AppTone.blue]!,
                    icon: Icons.description_outlined,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  HStatCard(
                    title: 'Reabastec.',
                    value: reabastecCount.toString(),
                    bgColor: AppToneColors.soft[AppTone.purple]!,
                    iconColor: AppToneColors.intense[AppTone.purple]!,
                    icon: Icons.local_shipping_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: SearchFilterRow(
                hintText: 'Buscar transacción o folio...',
                onSearchChanged: (val) {
                  setState(() {
                    _searchQuery = val.trim();
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
                  Text(
                    sectionTitle,
                    style: const TextStyle(
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

            if (displayedTransacciones.isEmpty)
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
                children: displayedTransacciones
                    .map((t) => TransaccionCard(transaccion: t))
                    .toList(),
              ),
            const SizedBox(height: 12),

            if (totalPages > 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: ProductoPaginationRow(
                  currentPage: effectivePage,
                  totalPages: totalPages,
                  onPrevious: effectivePage > 1
                      ? () => setState(() => _currentPage = effectivePage - 1)
                      : null,
                  onNext: effectivePage < totalPages
                      ? () => setState(() => _currentPage = effectivePage + 1)
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _onSelectDateChip(String rango) {
    setState(() {
      _filtroRangoFecha = rango;
      _currentPage = 1;
    });
  }
}

class _DateChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DateChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(color: AppColors.line.withValues(alpha: 0.6)),
          boxShadow: isSelected ? AppSpacing.cardShadow : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? AppColors.textOnPrimary : AppColors.ink,
          ),
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
