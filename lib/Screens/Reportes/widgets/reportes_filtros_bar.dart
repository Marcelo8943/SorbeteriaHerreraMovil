import 'package:flutter/material.dart';
import '../../../models/mocks/mock_catalogo.dart';
import '../../../models/mocks/mock_productos.dart';
import '../../../theme/app_theme.dart';

class ReportesFiltrosBar extends StatefulWidget {
  const ReportesFiltrosBar({super.key});

  @override
  State<ReportesFiltrosBar> createState() => _ReportesFiltrosBarState();
}

class _ReportesFiltrosBarState extends State<ReportesFiltrosBar> {
  void _mostrarFiltros(BuildContext context) {
    String producto = 'Todos';
    String linea = 'Todas';
    String tipoVenta = 'Todos';
    String atajoFecha = '';

    final productosUnicos = <String>[
      'Todos',
      ...mockProductos.map((p) => p.nombre).toSet(),
    ];

    final lineasUnicas = <String>[
      'Todas',
      ...mockLineas.map((l) => l.nombre).toSet(),
    ];

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => SafeArea(
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
                        child: TextField(
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
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
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
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text('Este mes'),
                        selected: atajoFecha == 'Este mes',
                        onSelected: (val) {
                          setModalState(() {
                            atajoFecha = val ? 'Este mes' : '';
                          });
                        },
                        selectedColor: AppColors.primarySoft,
                        backgroundColor: AppColors.lavender,
                        labelStyle: TextStyle(
                          color: atajoFecha == 'Este mes'
                              ? AppColors.primary
                              : AppColors.ink,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Este año'),
                        selected: atajoFecha == 'Este año',
                        onSelected: (val) {
                          setModalState(() {
                            atajoFecha = val ? 'Este año' : '';
                          });
                        },
                        selectedColor: AppColors.primarySoft,
                        backgroundColor: AppColors.lavender,
                        labelStyle: TextStyle(
                          color: atajoFecha == 'Este año'
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
                      initialValue: producto,
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
                      onChanged: (val) => setModalState(() => producto = val!),
                    ),
                  ),

                  // Dropdown Línea
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: DropdownButtonFormField<String>(
                      initialValue: linea,
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
                      onChanged: (val) => setModalState(() => linea = val!),
                    ),
                  ),

                  // Dropdown Tipo de venta
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: DropdownButtonFormField<String>(
                      initialValue: tipoVenta,
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
                      onChanged: (val) => setModalState(() => tipoVenta = val!),
                    ),
                  ),

                  // Botones Limpiar y Aplicar
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setModalState(() {
                              producto = 'Todos';
                              linea = 'Todas';
                              tipoVenta = 'Todos';
                              atajoFecha = '';
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
                          onPressed: () => Navigator.pop(context),
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
        ),
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
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.line),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    size: 18,
                    color: AppColors.muted,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Período: Este mes (Ago 2026)',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
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
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.line),
              ),
              child: const Row(
                children: [
                  Icon(Icons.tune, color: AppColors.ink, size: 20),
                  SizedBox(width: 6),
                  Text(
                    'Filtros',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
