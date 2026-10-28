import 'package:flutter/material.dart';

import '../../../data/models/app_models.dart';
import '../../../data/models/producto_catalogo_model.dart';
import '../../../session.dart';
import '../../theme/app_theme.dart';
import 'producto_form_screen.dart';
import 'widgets/producto_detalle_widgets.dart';

class ProductoDetalleScreen extends StatefulWidget {
  final Producto producto;
  final Future<ProductoDetalleModel> Function(int id) cargarDetalle;
  final bool permitirEdicion;

  const ProductoDetalleScreen({
    super.key,
    required this.producto,
    required this.cargarDetalle,
    this.permitirEdicion = true,
  });

  @override
  State<ProductoDetalleScreen> createState() => _ProductoDetalleScreenState();
}

class _ProductoDetalleScreenState extends State<ProductoDetalleScreen> {
  late Future<ProductoDetalleModel> _detalleFuture;

  @override
  void initState() {
    super.initState();
    _detalleFuture = widget.cargarDetalle(widget.producto.id);
  }

  Future<void> _abrirFicha(Producto producto) async {
    final resultado = await Navigator.of(context).push<Producto>(
      MaterialPageRoute<Producto>(
        builder: (_) => ProductoFormScreen(producto: producto),
      ),
    );
    if (resultado != null && mounted) {
      Navigator.pop(context, resultado);
    }
  }

  Producto _combinarDetalle(ProductoDetalleModel detalle) => Producto(
    id: detalle.id,
    nombre: detalle.nombre.isEmpty ? widget.producto.nombre : detalle.nombre,
    linea: widget.producto.linea,
    sabor: widget.producto.sabor,
    presentacion: widget.producto.presentacion,
    precioDetalle: widget.producto.precioDetalle,
    precioMayoreo: widget.producto.precioMayoreo,
    estado: detalle.activo ? 'Activo' : 'Inactivo',
    imgUrl: detalle.imagenUrl ?? widget.producto.imgUrl,
    stockMinimo: detalle.stockMinimo,
    stockActual: widget.producto.stockActual,
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 18),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text('Detalle del Producto'),
    ),
    body: FutureBuilder<ProductoDetalleModel>(
      future: _detalleFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _estadoError(snapshot.error.toString());
        }

        final detalle = snapshot.data!;
        final producto = _combinarDetalle(detalle);
        return SingleChildScrollView(
          child: Column(
            children: [
              HeaderSeccion(producto: producto),
              Transform.translate(
                offset: const Offset(0, -30),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Column(
                    children: [
                      TarjetaInformacion(producto: producto),
                      const SizedBox(height: 16),
                      _TarjetaDatosTecnicos(detalle: detalle),
                      if (Session.esAdmin && widget.permitirEdicion) ...[
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _abrirFicha(producto),
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            label: const Text('Editar producto'),
                          ),
                        ),
                      ],
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );

  Widget _estadoError(String mensaje) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 40),
          const SizedBox(height: 12),
          const Text(
            'No se pudo cargar el detalle del producto.',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(mensaje, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => setState(
              () => _detalleFuture = widget.cargarDetalle(widget.producto.id),
            ),
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    ),
  );
}

class _TarjetaDatosTecnicos extends StatelessWidget {
  final ProductoDetalleModel detalle;

  const _TarjetaDatosTecnicos({required this.detalle});

  @override
  Widget build(BuildContext context) {
    final createdAt = detalle.createdAt;
    final fecha = createdAt == null
        ? 'No disponible'
        : '${createdAt.day.toString().padLeft(2, '0')}/'
              '${createdAt.month.toString().padLeft(2, '0')}/'
              '${createdAt.year}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: AppSpacing.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DATOS DEL REGISTRO',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _DatoTecnico(
                  label: 'ID PRODUCTO',
                  valor: '${detalle.id}',
                ),
              ),
              Expanded(
                child: _DatoTecnico(
                  label: 'STOCK MÍNIMO',
                  valor: '${detalle.stockMinimo}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _DatoTecnico(label: 'FECHA DE REGISTRO', valor: fecha),
        ],
      ),
    );
  }
}

class _DatoTecnico extends StatelessWidget {
  final String label;
  final String valor;

  const _DatoTecnico({required this.label, required this.valor});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: AppColors.muted,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        valor,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
      ),
    ],
  );
}
