import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../data/models/app_models.dart';
import '../../../data/models/producto_catalogo_model.dart';
import '../../../data/repository/producto_repository.dart';
import '../../providers/producto_provider.dart';
import '../../../services/producto_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/h_stat_card.dart';
import 'producto_detalle_screen.dart';
import 'widgets/productos_widgets.dart';

class ProductosScreen extends StatefulWidget {
  const ProductosScreen({super.key});

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  static const _productosPorFila = 2;

  late final ApiClient _apiClient;
  late final ProductoProvider _provider;
  final TextEditingController _busquedaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient();
    _provider = ProductoProvider(
      ProductoService(ProductoRepository(_apiClient)),
    );
    _provider.cargar();
    _provider.cargarFiltros();
  }

  @override
  void dispose() {
    _busquedaController.dispose();
    _provider.dispose();
    _apiClient.dispose();
    super.dispose();
  }

  Future<void> _abrirDetalle(ProductoCatalogoModel producto) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => ProductoDetalleScreen(
          producto: _aProducto(producto),
          cargarDetalle: _provider.obtenerDetalle,
          permitirEdicion: true,
        ),
      ),
    );
  }

  Producto _aProducto(ProductoCatalogoModel producto) => Producto(
    id: producto.id,
    nombre: producto.nombre,
    linea: producto.linea,
    sabor: producto.sabor,
    presentacion: producto.presentacion,
    precioDetalle: producto.precioDetalle ?? 0,
    precioMayoreo: producto.precioMayoreo ?? 0,
    estado: producto.activo ? 'Activo' : 'Inactivo',
    imgUrl: producto.imagenUrl ?? '',
    stockMinimo: 0,
    stockActual: 0,
  );

  void _mostrarFiltros() {
    var lineaId = _provider.lineId ?? 0;
    var saborId = _provider.flavorId ?? 0;
    var presentacionId = _provider.presentationId ?? 0;
    var estado = _provider.active == null
        ? 0
        : _provider.active == true
        ? 1
        : 2;

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
              16,
              10,
              16,
              MediaQuery.viewInsetsOf(context).bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Filtrar productos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                if (_provider.errorFiltros != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      'No se pudieron cargar todos los filtros: ${_provider.errorFiltros}',
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ),
                _campoFiltro(
                  'Línea',
                  lineaId,
                  _opciones(_provider.lineas, 'Todas'),
                  (value) => setModalState(() => lineaId = value!),
                ),
                _campoFiltro(
                  'Sabor',
                  saborId,
                  _opciones(_provider.sabores, 'Todos'),
                  (value) => setModalState(() => saborId = value!),
                ),
                _campoFiltro(
                  'Presentación',
                  presentacionId,
                  _opciones(_provider.presentaciones, 'Todas'),
                  (value) => setModalState(() => presentacionId = value!),
                ),
                _campoFiltro('Estado', estado, const [
                  DropdownMenuItem(value: 0, child: Text('Todos')),
                  DropdownMenuItem(value: 1, child: Text('Activo')),
                  DropdownMenuItem(value: 2, child: Text('Inactivo')),
                ], (value) => setModalState(() => estado = value!)),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => setModalState(() {
                          lineaId = 0;
                          saborId = 0;
                          presentacionId = 0;
                          estado = 0;
                        }),
                        child: const Text('Limpiar'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _provider.aplicarFiltros(
                            newLineId: lineaId == 0 ? null : lineaId,
                            newFlavorId: saborId == 0 ? null : saborId,
                            newPresentationId: presentacionId == 0
                                ? null
                                : presentacionId,
                            newActive: estado == 0 ? null : estado == 1,
                          );
                          Navigator.pop(context);
                        },
                        child: const Text('Aplicar'),
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

  List<DropdownMenuItem<int>> _opciones(
    List<OpcionCatalogoProducto> options,
    String allLabel,
  ) => [
    DropdownMenuItem(value: 0, child: Text(allLabel)),
    ...options.map(
      (option) =>
          DropdownMenuItem(value: option.id, child: Text(option.nombre)),
    ),
  ];

  Widget _campoFiltro(
    String label,
    int value,
    List<DropdownMenuItem<int>> options,
    ValueChanged<int?> onChanged,
  ) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: DropdownButtonFormField<int>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: options,
      onChanged: onChanged,
    ),
  );

  Widget _barraBusqueda() => Row(
    children: [
      Expanded(
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
                  controller: _busquedaController,
                  onChanged: _provider.buscar,
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 13, color: AppColors.muted),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(width: 8),
      Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
        ),
        child: IconButton(
          icon: const Icon(Icons.tune, color: AppColors.ink, size: 28),
          onPressed: _mostrarFiltros,
        ),
      ),
    ],
  );

  Widget _contenido() {
    final provider = _provider;
    final estadisticas = provider.estadisticas;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              subtitle: 'Catálogo de productos',
              trailing: const SizedBox(width: 48, height: 48),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => provider.cargar(),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  children: [
                    Text(
                      'Productos',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Consulta el catálogo de productos.',
                      style: TextStyle(color: AppColors.muted, fontSize: 12.5),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          HStatCard(
                            title: 'Registrados',
                            value: estadisticas?.total.toString() ?? '—',
                            bgColor: AppToneColors.soft[AppTone.teal]!,
                            iconColor: AppToneColors.intense[AppTone.teal]!,
                            icon: Icons.inventory_2_outlined,
                          ),
                          const SizedBox(width: 10),
                          HStatCard(
                            title: 'Activos',
                            value: estadisticas?.activos.toString() ?? '—',
                            bgColor: AppToneColors.soft[AppTone.purple]!,
                            iconColor: AppToneColors.intense[AppTone.purple]!,
                            icon: Icons.check_circle_outline,
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _barraBusqueda(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          'Resultados',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            '${provider.totalRecords}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (provider.cargando && provider.productos.isEmpty)
                      const SizedBox(
                        height: 180,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (provider.error != null &&
                        provider.productos.isEmpty)
                      _estadoError(provider.error!)
                    else if (provider.productos.isEmpty)
                      const SizedBox(
                        height: 160,
                        child: Center(
                          child: Text('No se encontraron productos'),
                        ),
                      )
                    else ...[
                      if (provider.cargando)
                        const LinearProgressIndicator(minHeight: 2),
                      for (
                        var index = 0;
                        index < provider.productos.length;
                        index += _productosPorFila
                      )
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ProductoCard(
                                  producto: _aProducto(
                                    provider.productos[index],
                                  ),
                                  onTap: () =>
                                      _abrirDetalle(provider.productos[index]),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: index + 1 < provider.productos.length
                                    ? ProductoCard(
                                        producto: _aProducto(
                                          provider.productos[index + 1],
                                        ),
                                        onTap: () => _abrirDetalle(
                                          provider.productos[index + 1],
                                        ),
                                      )
                                    : const SizedBox(),
                              ),
                            ],
                          ),
                        ),
                      ProductoPaginationRow(
                        currentPage: provider.currentPage,
                        totalPages: provider.totalPages,
                        onPrevious: provider.currentPage > 1
                            ? () => provider.cargar(
                                page: provider.currentPage - 1,
                              )
                            : null,
                        onNext: provider.currentPage < provider.totalPages
                            ? () => provider.cargar(
                                page: provider.currentPage + 1,
                              )
                            : null,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _estadoError(String error) => SizedBox(
    height: 180,
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(error, textAlign: TextAlign.center),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => _provider.cargar(),
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _provider,
    builder: (context, _) => _contenido(),
  );
}
