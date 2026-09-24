import 'package:flutter/material.dart';

import '../../models/app_models.dart';
import '../../models/mocks/mock_catalogo.dart';
import '../../models/mocks/mock_productos.dart';
import '../../theme/app_theme.dart';
import '../../widgets/h_stat_card.dart';
import '../../widgets/search_filter_row.dart';
import 'widgets/productos_widgets.dart';

class ProductosScreen extends StatefulWidget {
  const ProductosScreen({super.key});

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  late final List<Producto> _productos;
  String _busqueda = '';
  String _linea = 'Todas';
  String _sabor = 'Todos';
  String _estado = 'Todos';
  String _presentacion = 'Todas';
  int _paginaActual = 1;
  static const _productosPorPagina = 10;

  List<String> get _lineas => [
        'Todas',
        ...{...mockLineas.map((linea) => linea.nombre), ..._productos.map((producto) => producto.linea)},
      ];

  List<String> get _presentaciones => [
        'Todas',
        ...{
          ...mockPresentaciones.map((presentacion) => presentacion.nombre.trim()),
          ..._productos.map((producto) => producto.presentacion),
        },
      ];

  List<String> get _sabores => [
        'Todos',
        ...{
          ...mockSabores.map((sabor) => sabor.nombre),
          ..._productos.map((producto) => producto.sabor.trim()),
        },
      ];

  @override
  void initState() {
    super.initState();
    _productos = List<Producto>.from(mockProductos);
  }

  List<Producto> get _filtrados {
    final query = _busqueda.trim().toLowerCase();
    return _productos.where((producto) {
      final texto = producto.nombre.toLowerCase().contains(query) || producto.sabor.toLowerCase().contains(query);
      return (query.isEmpty || texto) &&
          (_linea == 'Todas' || producto.linea.toLowerCase() == _linea.toLowerCase()) &&
          (_sabor == 'Todos' || producto.sabor.trim().toLowerCase() == _sabor.toLowerCase()) &&
          (_estado == 'Todos' || producto.estado == _estado) &&
          (_presentacion == 'Todas' || producto.presentacion == _presentacion);
    }).toList();
  }

  void _toggleEstado(Producto producto) {
    final index = _productos.indexWhere((item) => item.id == producto.id);
    if (index < 0) return;
    setState(() {
      _productos[index] = Producto(
        id: producto.id,
        nombre: producto.nombre,
        linea: producto.linea,
        sabor: producto.sabor,
        presentacion: producto.presentacion,
        precioDetalle: producto.precioDetalle,
        precioMayoreo: producto.precioMayoreo,
        estado: producto.estado == 'Activo' ? 'Inactivo' : 'Activo',
        imgUrl: producto.imgUrl,
      );
    });
  }

  void _mostrarFiltros() {
    var linea = _linea;
    var sabor = _sabor;
    var estado = _estado;
    var presentacion = _presentacion;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.fromLTRB(16, 10, 16, MediaQuery.viewInsetsOf(context).bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Expanded(child: Text('Filtrar productos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800))),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ]),
              _dropdown('Línea', linea, _lineas, (value) => setModalState(() => linea = value!)),
              _dropdown('Sabor', sabor, _sabores, (value) => setModalState(() => sabor = value!)),
              _dropdown('Presentación', presentacion, _presentaciones, (value) => setModalState(() => presentacion = value!)),
              _dropdown('Estado', estado, const ['Todos', 'Activo', 'Inactivo'], (value) => setModalState(() => estado = value!)),
              Row(children: [
                Expanded(child: TextButton(onPressed: () => setModalState(() { linea = 'Todas'; sabor = 'Todos'; estado = 'Todos'; presentacion = 'Todas'; }), child: const Text('Limpiar'))),
                const SizedBox(width: 8),
                Expanded(child: ElevatedButton(onPressed: () { setState(() { _linea = linea; _sabor = sabor; _estado = estado; _presentacion = presentacion; _paginaActual = 1; }); Navigator.pop(context); }, child: const Text('Aplicar'))),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropdown(String label, String value, List<String> options, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(labelText: label),
        items: options.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activos = _productos.where((producto) => producto.estado == 'Activo').length;
    final filtrados = _filtrados;
    final totalPaginas = (filtrados.length / _productosPorPagina).ceil();
    final effectivePage = totalPaginas > 0 && _paginaActual > totalPaginas
      ? totalPaginas
      : _paginaActual;
    final startIndex = (effectivePage - 1) * _productosPorPagina;
    final endIndex = (startIndex + _productosPorPagina < filtrados.length)
      ? startIndex + _productosPorPagina
      : filtrados.length;
    final productosDePagina = filtrados.isEmpty
      ? <Producto>[]
      : filtrados.sublist(startIndex, endIndex);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            ProductoTopBar(onAdd: () {}),
            Expanded(
              child: ListView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 24), children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Productos', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 2),
          const Text('Administra el catálogo completo de productos.', style: TextStyle(color: AppColors.muted, fontSize: 12.5)),
          const SizedBox(height: 16),
          SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
            HStatCard(title: 'Registrados', value: '${_productos.length}', bgColor: AppToneColors.soft[AppTone.teal]!, iconColor: AppToneColors.intense[AppTone.teal]!, icon: Icons.inventory_2_outlined),
            const SizedBox(width: 10),
            HStatCard(title: 'Activos', value: '$activos', bgColor: AppToneColors.soft[AppTone.purple]!, iconColor: AppToneColors.intense[AppTone.purple]!, icon: Icons.check_circle_outline),
            const SizedBox(width: 10),
            HStatCard(title: 'Inactivos', value: '${_productos.length - activos}', bgColor: AppToneColors.soft[AppTone.red]!, iconColor: AppToneColors.intense[AppTone.red]!, icon: Icons.block_outlined),
          ])),
          const SizedBox(height: 16),
          SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: _lineas.map((linea) => Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(label: Text(linea), selected: _linea == linea, onSelected: (_) { setState(() { _linea = linea; _paginaActual = 1; }); }, selectedColor: AppColors.primary, labelStyle: TextStyle(color: _linea == linea ? Colors.white : AppColors.muted, fontSize: 12, fontWeight: FontWeight.w700), backgroundColor: AppColors.card, side: BorderSide.none))).toList())),
          const SizedBox(height: 8),
          SearchFilterRow(hintText: 'Buscar por nombre...', onSearchChanged: (value) { setState(() { _busqueda = value; _paginaActual = 1; }); }, onFilterTap: _mostrarFiltros),
          const SizedBox(height: 16),
          Row(children: [const Text('Resultados', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)), const SizedBox(width: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3), decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(99)), child: Text('${filtrados.length}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)))]),
          const SizedBox(height: 12),
        ]),
        const SizedBox(height: 4),
        if (filtrados.isEmpty)
          const SizedBox(height: 160, child: Center(child: Text('No se encontraron productos')))
        else
          Column(
            children: [
              for (var index = 0; index < productosDePagina.length; index += 2)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ProductoCard(
                          producto: productosDePagina[index],
                          onTap: () {},
                          onEstadoChanged: (_) => _toggleEstado(productosDePagina[index]),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: index + 1 < productosDePagina.length
                            ? ProductoCard(
                            producto: productosDePagina[index + 1],
                                onTap: () {},
                            onEstadoChanged: (_) => _toggleEstado(productosDePagina[index + 1]),
                              )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        if (filtrados.isNotEmpty)
          ProductoPaginationRow(
            currentPage: effectivePage,
            totalPages: totalPaginas,
            onPrevious: () {
              if (effectivePage > 1) {
                setState(() => _paginaActual = effectivePage - 1);
              }
            },
            onNext: () {
              if (effectivePage < totalPaginas) {
                setState(() => _paginaActual = effectivePage + 1);
              }
            },
          ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}