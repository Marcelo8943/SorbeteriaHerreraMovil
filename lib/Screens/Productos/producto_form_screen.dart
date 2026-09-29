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
  late TextEditingController _stockMinimoController;

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
    _stockMinimoController = TextEditingController(
      text: p?.stockMinimo.toString() ?? '0',
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
    _stockMinimoController.dispose();
    super.dispose();
  }

  void _cerrarVistaPrevia() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.producto != null;

    return Scaffold(
      backgroundColor: AppColors.background,
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
              color: AppColors.card,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.ink.withValues(alpha: 0.04),
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
                            color: AppColors.lavender,
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

                  // Stock mínimo del producto
                  ProductoFormField(
                    label: 'Mínimo stock',
                    controller: _stockMinimoController,
                    hintText: '0',
                    keyboardType: TextInputType.number,
                    validator: _validarStockMinimo,
                  ),
                  const SizedBox(height: 20),

                  if (esEdicion) ...[
                    // Estado del producto
                    ProductoEstadoSwitch(
                      activo: _esActivo,
                      onChanged: (val) {
                        setState(() => _esActivo = val);
                      },
                    ),
                    const SizedBox(height: 24),
                  ] else
                    const SizedBox(height: 24),

                  // Botón Guardar
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _cerrarVistaPrevia,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textOnPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.check, size: 20),
                      label: Text(
                        esEdicion ? 'Confirmar Edición' : 'Crear',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textOnPrimary,
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

  String? _validarStockMinimo(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Ingrese el mínimo de stock';
    }
    final stockMinimo = int.tryParse(valor.trim());
    if (stockMinimo == null || stockMinimo < 0) {
      return 'Ingrese una cantidad entera igual o mayor que 0';
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
