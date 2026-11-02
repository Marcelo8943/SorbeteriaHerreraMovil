import 'package:flutter/material.dart';
import '../../../data/models/producto_vista_model.dart';
import '../../../presentation/providers/producto_form_provider.dart';
import '../../../presentation/providers/producto_provider.dart';
import '../../theme/app_theme.dart';
import 'widgets/producto_form_widgets.dart';
import 'widgets/producto_imagen.dart';

class ProductoFormScreen extends StatefulWidget {
  final ProductoVistaModel? producto;
  final ProductoProvider catalogoProvider;
  final ProductoFormProvider formProvider;

  const ProductoFormScreen({
    super.key,
    this.producto,
    required this.catalogoProvider,
    required this.formProvider,
  });

  @override
  State<ProductoFormScreen> createState() => _ProductoFormScreenState();
}

class _ProductoFormScreenState extends State<ProductoFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nombreController;
  late TextEditingController _imagenUrlController;
  late TextEditingController _stockMinimoController;

  int? _linePresentationId;
  int? _flavorId;
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

    _linePresentationId = p?.linePresentationId;
    _flavorId = p?.flavorId;
    _esActivo = (p?.estado ?? 'Activo') == 'Activo';
    _cargarCatalogos();
  }

  Future<void> _cargarCatalogos() async {
    await widget.catalogoProvider.cargarFiltros();
    if (!mounted) return;
    setState(() {
      _linePresentationId ??=
          widget.catalogoProvider.lineasPresentaciones.firstOrNull?.id;
      _flavorId ??= widget.catalogoProvider.sabores.firstOrNull?.id;
    });
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _imagenUrlController.dispose();
    _stockMinimoController.dispose();
    super.dispose();
  }

  Future<void> _guardarProducto() async {
    if (!_formKey.currentState!.validate()) return;
    if (_linePresentationId == null || _flavorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona línea, presentación y sabor.'),
        ),
      );
      return;
    }
    final guardado = await widget.formProvider.guardar(
      id: widget.producto?.id,
      linePresentationId: _linePresentationId!,
      flavorId: _flavorId!,
      nombre: _nombreController.text.trim(),
      imagenUrl: _imagenUrlController.text.trim().isEmpty
          ? null
          : _imagenUrlController.text.trim(),
      stockMinimo: int.parse(_stockMinimoController.text.trim()),
      activo: _esActivo,
    );
    if (!mounted) return;
    if (guardado) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.formProvider.error ?? 'No se pudo guardar el producto.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: Listenable.merge([widget.catalogoProvider, widget.formProvider]),
    builder: (context, _) => _buildForm(context),
  );

  Widget _buildForm(BuildContext context) {
    final esEdicion = widget.producto != null;
    final catalogo = widget.catalogoProvider;
    final linePresentation = catalogo.lineasPresentaciones
        .where((item) => item.id == _linePresentationId)
        .firstOrNull;
    final flavor = catalogo.sabores
        .where((item) => item.id == _flavorId)
        .firstOrNull;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: AppColors.ink,
          ),
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
                    validator: _validarNombre,
                  ),
                  const SizedBox(height: 16),

                  // Línea y presentación disponibles en la API
                  ProductoDropdownField(
                    label: 'Línea y presentación',
                    value: linePresentation?.label,
                    items: catalogo.lineasPresentaciones
                        .map((item) => item.label)
                        .toList(),
                    validator: (valor) =>
                        valor == null ? 'Seleccione una combinación' : null,
                    onChanged: (val) {
                      final opcion = catalogo.lineasPresentaciones
                          .where((item) => item.label == val)
                          .firstOrNull;
                      if (opcion != null) {
                        setState(() => _linePresentationId = opcion.id);
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Sabores disponibles en la API
                  ProductoDropdownField(
                    label: 'Sabor',
                    value: flavor?.nombre,
                    items: catalogo.sabores.map((item) => item.nombre).toList(),
                    validator: (valor) =>
                        valor == null ? 'Seleccione un sabor' : null,
                    onChanged: (val) {
                      final opcion = catalogo.sabores
                          .where((item) => item.nombre == val)
                          .firstOrNull;
                      if (opcion != null) setState(() => _flavorId = opcion.id);
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
                      onPressed: widget.formProvider.guardando
                          ? null
                          : _guardarProducto,
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
                        widget.formProvider.guardando
                            ? 'Guardando...'
                            : esEdicion
                            ? 'Confirmar Edición'
                            : 'Crear',
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

  String? _validarNombre(String? valor) {
    final nombre = valor?.trim() ?? '';
    if (nombre.isEmpty) return 'Ingrese el nombre del producto';
    if (nombre.length < 3) {
      return 'El nombre debe tener al menos 3 caracteres';
    }
    return null;
  }

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
