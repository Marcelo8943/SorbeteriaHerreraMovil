import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../models/mocks/mock_catalogo.dart';
import '../../theme/app_theme.dart';
import 'widgets/producto_form_widgets.dart';
import 'widgets/producto_imagen.dart';

class ProductoFormScreen extends StatefulWidget {
  final Producto? producto;

  const ProductoFormScreen({super.key, this.producto});

  @override
  State<ProductoFormScreen> createState() => _ProductoFormScreenState();
}

class _ProductoFormScreenState extends State<ProductoFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nombreController;
  late TextEditingController _imagenUrlController;
  late TextEditingController _precioDetalleController;
  late TextEditingController _precioMayoreoController;

  late String _lineaSeleccionada;
  late String _presentacionSeleccionada;
  late String _saborSeleccionado;
  late bool _esActivo;

  @override
  void initState() {
    super.initState();
    final p = widget.producto;

    _nombreController = TextEditingController(text: p?.nombre ?? '');
    _imagenUrlController = TextEditingController(text: p?.imgUrl ?? '');
    _precioDetalleController = TextEditingController(
      text: p != null ? p.precioDetalle.toStringAsFixed(p.precioDetalle.truncateToDouble() == p.precioDetalle ? 0 : 2) : '',
    );
    _precioMayoreoController = TextEditingController(
      text: p != null ? p.precioMayoreo.toStringAsFixed(p.precioMayoreo.truncateToDouble() == p.precioMayoreo ? 0 : 2) : '',
    );

    _lineaSeleccionada = p?.linea ?? mockLineas.first.nombre;
    _presentacionSeleccionada = p?.presentacion ?? mockPresentaciones.first.nombre;
    _saborSeleccionado = p?.sabor ?? mockSabores.first.nombre;
    _esActivo = (p?.estado ?? 'Activo') == 'Activo';
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _imagenUrlController.dispose();
    _precioDetalleController.dispose();
    _precioMayoreoController.dispose();
    super.dispose();
  }

  void _guardar() {
    if (_formKey.currentState!.validate()) {
      final precioDetalle = double.parse(_precioDetalleController.text.trim());
      final precioMayoreo = double.parse(_precioMayoreoController.text.trim());
      final productoResultado = Producto(
        id: widget.producto?.id ?? DateTime.now().millisecondsSinceEpoch,
        nombre: _nombreController.text.trim(),
        linea: _lineaSeleccionada,
        sabor: _saborSeleccionado,
        presentacion: _presentacionSeleccionada,
        precioDetalle: precioDetalle,
        precioMayoreo: precioMayoreo,
        estado: _esActivo ? 'Activo' : 'Inactivo',
        imgUrl: _imagenUrlController.text.trim(),
      );

      Navigator.of(context).pop(productoResultado);
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.producto != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.ink),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          esEdicion ? 'Editar Producto' : 'Nuevo Producto',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre del producto
                  ProductoFormField(
                    label: 'Nombre del producto *',
                    hintText: 'Ej. Sorbete Tradicional Fresa 4 Oz',
                    controller: _nombreController,
                    validator: (val) => val == null || val.trim().isEmpty ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 16),

                  // Línea
                  ProductoDropdownField(
                    label: 'Línea',
                    value: _lineaSeleccionada,
                    items: _opcionesConValor(mockLineas.map((e) => e.nombre).toList(), _lineaSeleccionada),
                    validator: (valor) => valor == null ? 'Seleccione una línea' : null,
                    onChanged: (val) {
                      if (val != null) setState(() => _lineaSeleccionada = val);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Presentación
                  ProductoDropdownField(
                    label: 'Presentación',
                    value: _presentacionSeleccionada,
                    items: _opcionesConValor(mockPresentaciones.map((e) => e.nombre).toList(), _presentacionSeleccionada),
                    validator: (valor) => valor == null ? 'Seleccione una presentación' : null,
                    onChanged: (val) {
                      if (val != null) setState(() => _presentacionSeleccionada = val);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Sabor
                  ProductoDropdownField(
                    label: 'Sabor',
                    value: _saborSeleccionado,
                    items: _opcionesConValor(mockSabores.map((e) => e.nombre).toList(), _saborSeleccionado),
                    validator: (valor) => valor == null ? 'Seleccione un sabor' : null,
                    onChanged: (val) {
                      if (val != null) setState(() => _saborSeleccionado = val);
                    },
                  ),
                  const SizedBox(height: 16),

                  ProductoFormField(
                    label: 'URL de imagen *',
                    controller: _imagenUrlController,
                    hintText: 'https://ejemplo.com/imagen.jpg',
                    keyboardType: TextInputType.url,
                    validator: _validarImagen,
                  ),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _imagenUrlController,
                    builder: (context, value, child) {
                      final referencia = value.text.trim();
                      if (referencia.isEmpty) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Container(
                          height: 120,
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F7FB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ProductoImagen(
                            referencia: referencia,
                            iconSize: 40,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Precio detalle
                  ProductoFormField(
                    label: 'Precio detalle (C\$) *',
                    controller: _precioDetalleController,
                    hintText: '45.00',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: _validarPrecio,
                  ),
                  const SizedBox(height: 16),

                  // Precio mayoreo
                  ProductoFormField(
                    label: 'Precio mayoreo (C\$) *',
                    controller: _precioMayoreoController,
                    hintText: '40.00',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: _validarPrecio,
                  ),
                  const SizedBox(height: 20),

                  // Estado del producto
                  ProductoEstadoSwitch(
                    activo: _esActivo,
                    onChanged: (val) {
                      setState(() => _esActivo = val);
                    },
                  ),
                  const SizedBox(height: 24),

                  // Botón Guardar
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _guardar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00C88C),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.check, size: 20, color: Colors.white),
                      label: Text(
                        esEdicion ? 'Actualizar producto' : 'Guardar producto',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<String> _opcionesConValor(List<String> opciones, String valorActual) =>
      {...opciones, valorActual}.toList();

  String? _validarPrecio(String? valor) {
    if (valor == null || valor.trim().isEmpty) return 'Ingrese el precio';
    final precio = double.tryParse(valor.trim());
    if (precio == null || !precio.isFinite || precio < 0) {
      return 'Ingrese un precio válido';
    }
    return null;
  }

  String? _validarImagen(String? valor) {
    final referencia = valor?.trim() ?? '';
    if (referencia.isEmpty) return 'Ingrese la URL de la imagen';
    if (referencia.startsWith('assets/')) return null;
    final uri = Uri.tryParse(referencia);
    if (uri == null ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty) {
      return 'Ingrese una URL válida (http o https)';
    }
    return null;
  }
}
