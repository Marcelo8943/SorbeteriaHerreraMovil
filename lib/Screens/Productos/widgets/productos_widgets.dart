import 'package:flutter/material.dart';
import '../../../../models/app_models.dart';
import '../../../../models/mocks/mock_catalogo.dart';
import '../../../../theme/app_theme.dart';
import 'producto_imagen.dart';

class ProductoTopBar extends StatelessWidget {
  final VoidCallback onAdd;

  const ProductoTopBar({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
      color: AppColors.lavender,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00684F),
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: const Color(0xFF004B39), width: 1.5),
                  ),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Herrera',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'serif',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sorbetería Herrera', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.ink)),
                  Text('Catálogo de productos', style: TextStyle(color: AppColors.muted, fontSize: 11.5)),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: onAdd,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(12),
            ),
            child: const Icon(Icons.add, color: AppColors.textOnPrimary),
          ),
        ],
      ),
    );
  }
}

class ProductoStatusBadge extends StatelessWidget {
  final String estado;

  const ProductoStatusBadge({super.key, required this.estado});

  @override
  Widget build(BuildContext context) {
    final activo = estado == 'Activo';
    final color = activo
        ? AppToneColors.intense[AppTone.teal]!
        : AppToneColors.intense[AppTone.red]!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: activo
            ? AppToneColors.soft[AppTone.teal]
            : AppToneColors.soft[AppTone.red],
        borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
      ),
      child: Text(
        estado,
        style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class ProductoCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback onTap;
  final ValueChanged<bool> onEstadoChanged;

  const ProductoCard({
    super.key,
    required this.producto,
    required this.onTap,
    required this.onEstadoChanged,
  });

  @override
  Widget build(BuildContext context) {
    final activo = producto.estado == 'Activo';
    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          boxShadow: AppSpacing.cardShadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 112,
              width: double.infinity,
              color: const Color(0xFFF6F7FB),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(12),
              child: ProductoImagen(
                referencia: producto.imgUrl,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [ProductoStatusBadge(estado: producto.estado)],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 36,
                    child: Text(
                      producto.nombre,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'C\$${producto.precioDetalle.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: AppToneColors.intense[AppTone.teal],
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${producto.linea} · ${producto.presentacion}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          activo ? 'Disponible' : 'Inactivo',
                          style: TextStyle(
                            color: activo
                                ? AppToneColors.intense[AppTone.teal]
                                : AppColors.muted,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24,
                        child: Transform.scale(
                          scale: 0.82,
                          child: Switch.adaptive(
                            value: activo,
                            onChanged: onEstadoChanged,
                            activeThumbColor: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductoPaginationRow extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const ProductoPaginationRow({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final canGoBack = currentPage > 1;
    final canGoNext = currentPage < totalPages && totalPages > 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton(
            onPressed: canGoBack ? onPrevious : null,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              side: BorderSide(
                color: canGoBack ? AppColors.primary : AppColors.line,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_ios_new,
                  size: 11,
                  color: canGoBack ? AppColors.primary : AppColors.muted,
                ),
                const SizedBox(width: 4),
                Text(
                  'Anterior',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: canGoBack ? AppColors.primary : AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            totalPages > 0 ? 'Página $currentPage de $totalPages' : 'Sin resultados',
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
          OutlinedButton(
            onPressed: canGoNext ? onNext : null,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              side: BorderSide(
                color: canGoNext ? AppColors.primary : AppColors.line,
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Siguiente',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: canGoNext ? AppColors.primary : AppColors.muted,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 11,
                  color: canGoNext ? AppColors.primary : AppColors.muted,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductoFormDialog extends StatefulWidget {
  final Producto? producto; // Null para nuevo, objeto para edición

  const ProductoFormDialog({super.key, this.producto});

  @override
  State<ProductoFormDialog> createState() => _ProductoFormDialogState();
}

class _ProductoFormDialogState extends State<ProductoFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nombreController;
  late TextEditingController _precioDetalleController;
  late TextEditingController _precioMayoreoController;

  String? _lineaSeleccionada;
  String? _presentacionSeleccionada;
  String? _saborSeleccionado;
  String _estadoSeleccionado = 'Activo';

  @override
  void initState() {
    super.initState();
    final p = widget.producto;

    _nombreController = TextEditingController(text: p?.nombre ?? '');
    _precioDetalleController = TextEditingController(
      text: p != null ? p.precioDetalle.toStringAsFixed(2) : '',
    );
    _precioMayoreoController = TextEditingController(
      text: p != null ? p.precioMayoreo.toStringAsFixed(2) : '',
    );

    _lineaSeleccionada = p?.linea ?? mockLineas.first.nombre;
    _presentacionSeleccionada = p?.presentacion ?? mockPresentaciones.first.nombre;
    _saborSeleccionado = p?.sabor ?? mockSabores.first.nombre;
    _estadoSeleccionado = p?.estado ?? 'Activo';
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _precioDetalleController.dispose();
    _precioMayoreoController.dispose();
    super.dispose();
  }

  void _guardar() {
    if (_formKey.currentState!.validate()) {
      final nuevoProducto = Producto(
        id: widget.producto?.id ?? DateTime.now().millisecondsSinceEpoch,
        nombre: _nombreController.text.trim(),
        linea: _lineaSeleccionada!,
        sabor: _saborSeleccionado!,
        presentacion: _presentacionSeleccionada!,
        precioDetalle: double.parse(_precioDetalleController.text),
        precioMayoreo: double.parse(_precioMayoreoController.text),
        estado: _estadoSeleccionado,
        imgUrl: widget.producto?.imgUrl ?? 'assets/images/productos/default.png',
      );

      Navigator.of(context).pop(nuevoProducto);
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.producto != null;

    return AlertDialog(
      title: Text(esEdicion ? 'Editar Producto' : 'Nuevo Producto'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Nombre del producto
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del Producto',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 12),

                // Selector de Línea
                DropdownButtonFormField<String>(
                  initialValue: _lineaSeleccionada,
                  decoration: const InputDecoration(
                    labelText: 'Línea',
                    border: OutlineInputBorder(),
                  ),
                  items: mockLineas.map((linea) {
                    return DropdownMenuItem(
                      value: linea.nombre,
                      child: Text(linea.nombre),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _lineaSeleccionada = val),
                ),
                const SizedBox(height: 12),

                // Selector de Sabor
                DropdownButtonFormField<String>(
                  initialValue: _saborSeleccionado,
                  decoration: const InputDecoration(
                    labelText: 'Sabor',
                    border: OutlineInputBorder(),
                  ),
                  items: mockSabores.map((sabor) {
                    return DropdownMenuItem(
                      value: sabor.nombre,
                      child: Text(sabor.nombre),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _saborSeleccionado = val),
                ),
                const SizedBox(height: 12),

                // Selector de Presentación
                DropdownButtonFormField<String>(
                  initialValue: _presentacionSeleccionada,
                  decoration: const InputDecoration(
                    labelText: 'Presentación',
                    border: OutlineInputBorder(),
                  ),
                  items: mockPresentaciones.map((pres) {
                    return DropdownMenuItem(
                      value: pres.nombre,
                      child: Text(pres.nombre),
                    );
                  }).toList(),
                  onChanged: (val) =>
                      setState(() => _presentacionSeleccionada = val),
                ),
                const SizedBox(height: 12),

                // Precios
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _precioDetalleController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Precio Detalle (C\$)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Requerido';
                          if (double.tryParse(value) == null) return 'Inválido';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _precioMayoreoController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Precio Mayoreo (C\$)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Requerido';
                          if (double.tryParse(value) == null) return 'Inválido';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Estado (Activo / Inactivo)
                DropdownButtonFormField<String>(
                  initialValue: _estadoSeleccionado,
                  decoration: const InputDecoration(
                    labelText: 'Estado',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Activo', child: Text('Activo')),
                    DropdownMenuItem(value: 'Inactivo', child: Text('Inactivo')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _estadoSeleccionado = val);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _guardar,
          child: Text(esEdicion ? 'Actualizar' : 'Guardar'),
        ),
      ],
    );
  }
}
