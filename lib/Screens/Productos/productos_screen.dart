import 'package:flutter/material.dart';

import '../../models/app_models.dart';
import '../../models/mocks/mock_catalogo.dart';
import '../../models/mocks/mock_productos.dart';
import '../../theme/app_theme.dart';
import '../../widgets/h_stat_card.dart';
import 'producto_form_screen.dart';
import 'producto_detalle_screen.dart';
import 'widgets/productos_widgets.dart';

class ProductosScreen extends StatefulWidget {
  const ProductosScreen({super.key});

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  late final List<Producto> _productos;
  int _paginaActual = 1;
  static const _productosPorPagina = 10;

  @override
  void initState() {
    super.initState();
    _productos = List<Producto>.unmodifiable(mockProductos);
  }

  void _abrirDetalle(Producto producto) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => ProductoDetalleScreen(producto: producto),
      ),
    );
  }

  void _abrirFormulario({Producto? producto}) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => ProductoFormScreen(producto: producto),
      ),
    );
  }

  void _mostrarFiltros() {
    var linea = 'Todas';
    var sabor = 'Todos';
    var presentacion = 'Todas';
    var estado = 'Todos';
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
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
              _campoFiltro('Línea', linea, ['Todas', ...mockLineas.map((item) => item.nombre)], (value) => setModalState(() => linea = value!)),
              _campoFiltro('Sabor', sabor, ['Todos', ...mockSabores.map((item) => item.nombre)], (value) => setModalState(() => sabor = value!)),
              _campoFiltro('Presentación', presentacion, ['Todas', ...mockPresentaciones.map((item) => item.nombre)], (value) => setModalState(() => presentacion = value!)),
              _campoFiltro('Estado', estado, const ['Todos', 'Activo', 'Inactivo'], (value) => setModalState(() => estado = value!)),
              Row(children: [
                Expanded(child: TextButton(onPressed: () => setModalState(() { linea = 'Todas'; sabor = 'Todos'; presentacion = 'Todas'; estado = 'Todos'; }), child: const Text('Limpiar'))),
                const SizedBox(width: 8),
                Expanded(child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Aplicar'))),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campoFiltro(String label, String value, List<String> options, ValueChanged<String?> onChanged) {
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

  Widget _barraBusqueda() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: AppColors.lavender, borderRadius: BorderRadius.circular(14)),
            child: Row(children: [
              const Icon(Icons.search, color: AppColors.muted),
              const SizedBox(width: 8),
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 13, color: AppColors.muted),
                  ),
                ),
              ),
            ]),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14)),
          child: IconButton(
            icon: const Icon(Icons.tune, color: AppColors.ink, size: 28),
            onPressed: _mostrarFiltros,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final activos = _productos.where((producto) => producto.estado == 'Activo').length;
    final filtrados = _productos;
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
            ProductoTopBar(onAdd: () => _abrirFormulario()),
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
          _barraBusqueda(),
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
                          onTap: () => _abrirDetalle(productosDePagina[index]),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: index + 1 < productosDePagina.length
                            ? ProductoCard(
                            producto: productosDePagina[index + 1],
                                onTap: () => _abrirDetalle(productosDePagina[index + 1]),
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
