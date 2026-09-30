import 'package:flutter/material.dart';
import '../../../models/mocks/mock_catalogo.dart';
import '../../../models/mocks/mock_productos.dart';
import '../../../models/mocks/mock_transacciones.dart';
import '../../../theme/app_theme.dart';

class ReportesFiltrosBar extends StatelessWidget {
  final String filtroProducto;
  final String filtroLinea;
  final String filtroTipoVenta;
  final String filtroFechaRango;
  final DateTime? fechaDesde;
  final DateTime? fechaHasta;
  final void Function({
    required String producto,
    required String linea,
    required String tipoVenta,
    required String fechaRango,
    DateTime? fechaDesde,
    DateTime? fechaHasta,
  })
  onFiltrosAplicados;
  final void Function(String tipoFiltro) onRemoverFiltro;

  const ReportesFiltrosBar({
    super.key,
    required this.filtroProducto,
    required this.filtroLinea,
    required this.filtroTipoVenta,
    required this.filtroFechaRango,
    this.fechaDesde,
    this.fechaHasta,
    required this.onFiltrosAplicados,
    required this.onRemoverFiltro,
  });

  String _formatearFecha(DateTime fecha) {
    final d = fecha.day.toString().padLeft(2, '0');
    final m = fecha.month.toString().padLeft(2, '0');
    final y = fecha.year.toString();
    return '$d/$m/$y';
  }

  int get filtrosActivosCount {
    int count = 0;
    if (filtroProducto != 'Todos') count++;
    if (filtroLinea != 'Todas') count++;
    if (filtroTipoVenta != 'Todos') count++;
    if (filtroFechaRango != 'Todos' ||
        fechaDesde != null ||
        fechaHasta != null) {
      count++;
    }
    return count;
  }

  String _textoPeriodo() {
    if (fechaDesde != null && fechaHasta != null) {
      return '${_formatearFecha(fechaDesde!)} - ${_formatearFecha(fechaHasta!)}';
    }
    if (filtroFechaRango == 'Este mes') {
      return 'Este mes (Ago 2026)';
    }
    if (filtroFechaRango == 'Este año') {
      return 'Este año (2026)';
    }
    return 'Todo el período';
  }

  void _mostrarFiltros(BuildContext context) {
    String tempProducto = filtroProducto;
    String tempLinea = filtroLinea;
    String tempTipoVenta = filtroTipoVenta;
    String tempRango = filtroFechaRango;
    DateTime? tempDesde = fechaDesde;
    DateTime? tempHasta = fechaHasta;

    final productosEnTransacciones =
        mockTransacciones
            .expand((t) => t.items)
            .map((i) => i.producto)
            .toSet()
            .toList()
          ..sort();

    final otrosProductos =
        mockProductos
            .map((p) => p.nombre)
            .where((n) => !productosEnTransacciones.contains(n))
            .toSet()
            .toList()
          ..sort();

    final productosUnicos = <String>[
      'Todos',
      ...productosEnTransacciones,
      ...otrosProductos,
    ];

    final lineasUnicas = <String>[
      'Todas',
      ...mockLineas.map((l) => l.nombre).toSet(),
    ];

    final desdeController = TextEditingController(
      text: tempDesde != null ? _formatearFecha(tempDesde) : '',
    );
    final hastaController = TextEditingController(
      text: tempHasta != null ? _formatearFecha(tempHasta) : '',
    );

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          Future<void> seleccionarFechaDesde() async {
            final picked = await showDatePicker(
              context: context,
              initialDate: tempDesde ?? DateTime(2026, 8, 1),
              firstDate: DateTime(2025),
              lastDate: DateTime(2027),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: AppColors.primary,
                      onPrimary: AppColors.textOnPrimary,
                      surface: AppColors.card,
                      onSurface: AppColors.ink,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              setModalState(() {
                tempDesde = picked;
                desdeController.text = _formatearFecha(picked);
                tempRango = '';
              });
            }
          }

          Future<void> seleccionarFechaHasta() async {
            final picked = await showDatePicker(
              context: context,
              initialDate: tempHasta ?? DateTime(2026, 8, 31),
              firstDate: DateTime(2025),
              lastDate: DateTime(2027),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: AppColors.primary,
                      onPrimary: AppColors.textOnPrimary,
                      surface: AppColors.card,
                      onSurface: AppColors.ink,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              setModalState(() {
                tempHasta = picked;
                hastaController.text = _formatearFecha(picked);
                tempRango = '';
              });
            }
          }

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                12,
                AppSpacing.md,
                MediaQuery.viewInsetsOf(context).bottom + 24,
              ),
              child: SingleChildScrollView(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filtrar reportes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: AppColors.ink),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Rango de fecha
                    const Text(
                      'Rango de fecha',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: seleccionarFechaDesde,
                            child: IgnorePointer(
                              child: TextField(
                                controller: desdeController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: 'Desde',
                                  hintText: '01/08/2026',
                                  prefixIcon: const Icon(
                                    Icons.calendar_today_outlined,
                                    size: 16,
                                    color: AppColors.muted,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.line,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.line,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: seleccionarFechaHasta,
                            child: IgnorePointer(
                              child: TextField(
                                controller: hastaController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: 'Hasta',
                                  hintText: '16/08/2026',
                                  prefixIcon: const Icon(
                                    Icons.calendar_today_outlined,
                                    size: 16,
                                    color: AppColors.muted,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.line,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.line,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ChoiceChip(
                          label: const Text('Este mes'),
                          selected: tempRango == 'Este mes',
                          onSelected: (val) {
                            setModalState(() {
                              if (val) {
                                tempRango = 'Este mes';
                                tempDesde = DateTime(2026, 8, 1);
                                tempHasta = DateTime(2026, 8, 31);
                                desdeController.text = _formatearFecha(
                                  tempDesde!,
                                );
                                hastaController.text = _formatearFecha(
                                  tempHasta!,
                                );
                              } else {
                                tempRango = 'Todos';
                                tempDesde = null;
                                tempHasta = null;
                                desdeController.clear();
                                hastaController.clear();
                              }
                            });
                          },
                          selectedColor: AppColors.primarySoft,
                          backgroundColor: AppColors.lavender,
                          labelStyle: TextStyle(
                            color: tempRango == 'Este mes'
                                ? AppColors.primary
                                : AppColors.ink,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('Este año'),
                          selected: tempRango == 'Este año',
                          onSelected: (val) {
                            setModalState(() {
                              if (val) {
                                tempRango = 'Este año';
                                tempDesde = DateTime(2026, 1, 1);
                                tempHasta = DateTime(2026, 12, 31);
                                desdeController.text = _formatearFecha(
                                  tempDesde!,
                                );
                                hastaController.text = _formatearFecha(
                                  tempHasta!,
                                );
                              } else {
                                tempRango = 'Todos';
                                tempDesde = null;
                                tempHasta = null;
                                desdeController.clear();
                                hastaController.clear();
                              }
                            });
                          },
                          selectedColor: AppColors.primarySoft,
                          backgroundColor: AppColors.lavender,
                          labelStyle: TextStyle(
                            color: tempRango == 'Este año'
                                ? AppColors.primary
                                : AppColors.ink,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Dropdown Producto
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: DropdownButtonFormField<String>(
                        initialValue: tempProducto,
                        decoration: InputDecoration(
                          labelText: 'Producto',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.line),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.line),
                          ),
                        ),
                        isExpanded: true,
                        items: productosUnicos
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) =>
                            setModalState(() => tempProducto = val!),
                      ),
                    ),

                    // Dropdown Línea
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: DropdownButtonFormField<String>(
                        initialValue: tempLinea,
                        decoration: InputDecoration(
                          labelText: 'Línea',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.line),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.line),
                          ),
                        ),
                        items: lineasUnicas
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              ),
                            )
                            .toList(),
                        onChanged: (val) =>
                            setModalState(() => tempLinea = val!),
                      ),
                    ),

                    // Dropdown Tipo de venta
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: DropdownButtonFormField<String>(
                        initialValue: tempTipoVenta,
                        decoration: InputDecoration(
                          labelText: 'Tipo de venta',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.line),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.line),
                          ),
                        ),
                        items: const ['Todos', 'Detalle', 'Mayoreo']
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              ),
                            )
                            .toList(),
                        onChanged: (val) =>
                            setModalState(() => tempTipoVenta = val!),
                      ),
                    ),

                    // Botones Limpiar y Aplicar
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setModalState(() {
                                tempProducto = 'Todos';
                                tempLinea = 'Todas';
                                tempTipoVenta = 'Todos';
                                tempRango = 'Todos';
                                tempDesde = null;
                                tempHasta = null;
                                desdeController.clear();
                                hastaController.clear();
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
                              onFiltrosAplicados(
                                producto: tempProducto,
                                linea: tempLinea,
                                tipoVenta: tempTipoVenta,
                                fechaRango: tempRango.isEmpty
                                    ? 'Personalizado'
                                    : tempRango,
                                fechaDesde: tempDesde,
                                fechaHasta: tempHasta,
                              );
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
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        size: 18,
                        color: AppColors.muted,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Período: ${_textoPeriodo()}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => _mostrarFiltros(context),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: filtrosActivosCount > 0
                        ? AppColors.primarySoft
                        : AppColors.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: filtrosActivosCount > 0
                          ? AppColors.primary
                          : AppColors.line,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.tune,
                        color: filtrosActivosCount > 0
                            ? AppColors.primary
                            : AppColors.ink,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Filtros',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: filtrosActivosCount > 0
                              ? AppColors.primary
                              : AppColors.ink,
                        ),
                      ),
                      if (filtrosActivosCount > 0) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$filtrosActivosCount',
                            style: const TextStyle(
                              color: AppColors.textOnPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Chips de filtros activos
          if (filtrosActivosCount > 0) ...[
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  if (filtroFechaRango != 'Todos' ||
                      fechaDesde != null ||
                      fechaHasta != null)
                    _ActiveChip(
                      label: _textoPeriodo(),
                      onDeleted: () => onRemoverFiltro('fecha'),
                    ),
                  if (filtroProducto != 'Todos')
                    _ActiveChip(
                      label: 'Prod: $filtroProducto',
                      onDeleted: () => onRemoverFiltro('producto'),
                    ),
                  if (filtroLinea != 'Todas')
                    _ActiveChip(
                      label: 'Línea: $filtroLinea',
                      onDeleted: () => onRemoverFiltro('linea'),
                    ),
                  if (filtroTipoVenta != 'Todos')
                    _ActiveChip(
                      label: 'Venta: $filtroTipoVenta',
                      onDeleted: () => onRemoverFiltro('tipoVenta'),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActiveChip extends StatelessWidget {
  final String label;
  final VoidCallback onDeleted;

  const _ActiveChip({required this.label, required this.onDeleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.only(left: 10, right: 4, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: AppColors.lavender,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onDeleted,
            child: const Icon(Icons.close, size: 14, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
