import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../theme/app_theme.dart';
import 'cliente_form_widgets.dart';

class ClienteFormScreen extends StatefulWidget {
  final Cliente? cliente; // null => Agregar, !null => Editar

  const ClienteFormScreen({super.key, this.cliente});

  @override
  State<ClienteFormScreen> createState() => _ClienteFormScreenState();
}

class _ClienteFormScreenState extends State<ClienteFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nombreCtrl;
  late TextEditingController _puntoVentaCtrl;
  late TextEditingController _telefonoCtrl;
  String? _departamento;
  String? _municipio;

  static const _departamentos = [
    'Masaya',
    'Granada',
    'Managua',
    'Carazo',
    'Rivas',
    'León',
    'Chinandega',
    'Estelí',
    'Matagalpa',
    'Jinotega',
  ];

  static const _municipios = [
    'Catarina',
    'Diriomo',
    'Tipitapa',
    'Jinotepe',
    'Granada',
    'Rivas',
    'León',
    'Chinandega',
    'Estelí',
    'Matagalpa',
    'Jinotega',
    'Masaya',
  ];

  bool get _esEdicion => widget.cliente != null;

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.cliente?.nombre ?? '');
    _puntoVentaCtrl = TextEditingController(
      text: widget.cliente?.puntoVenta ?? '',
    );
    _telefonoCtrl = TextEditingController(text: widget.cliente?.telefono ?? '');
    _departamento = widget.cliente?.departamento;
    _municipio = widget.cliente?.municipio;
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _puntoVentaCtrl.dispose();
    _telefonoCtrl.dispose();
    super.dispose();
  }

  void _guardarFormulario() {
    if (_formKey.currentState!.validate()) {
      final partesNombre = _nombreCtrl.text.trim().split(' ');
      String? inicialesCalc;
      if (partesNombre.length >= 2) {
        inicialesCalc = '${partesNombre[0][0]}${partesNombre[1][0]}'
            .toUpperCase();
      } else if (partesNombre.isNotEmpty && partesNombre[0].isNotEmpty) {
        inicialesCalc = partesNombre[0][0].toUpperCase();
      }

      final clienteResultado = Cliente(
        id: widget.cliente?.id ?? DateTime.now().millisecondsSinceEpoch,
        nombre: _nombreCtrl.text.trim(),
        puntoVenta: _puntoVentaCtrl.text.trim(),
        telefono: _telefonoCtrl.text.trim(),
        departamento: _departamento!,
        municipio: _municipio!,
        clienteDesde: widget.cliente?.clienteDesde ?? '22/09/2026',
        iniciales: widget.cliente?.iniciales ?? inicialesCalc,
      );

      Navigator.pop(context, clienteResultado);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: AppColors.ink,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _esEdicion ? 'Editar Cliente' : 'Nuevo Cliente',
          style: const TextStyle(
            color: AppColors.ink,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CustomFormField(
                      label: 'Nombre completo',
                      controller: _nombreCtrl,
                      icon: Icons.person_outline,
                      validator: (val) => val == null || val.trim().isEmpty
                          ? 'Ingrese el nombre'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    CustomFormField(
                      label: 'Teléfono',
                      controller: _telefonoCtrl,
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (val) => val == null || val.trim().isEmpty
                          ? 'Ingrese el teléfono'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    CustomFormDropdown(
                      label: 'Departamento',
                      value: _departamento,
                      items: _departamentos,
                      icon: Icons.map_outlined,
                      onChanged: (value) =>
                          setState(() => _departamento = value),
                      validator: (value) =>
                          value == null ? 'Seleccione el departamento' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomFormDropdown(
                      label: 'Municipio',
                      value: _municipio,
                      items: _municipios,
                      icon: Icons.location_city_outlined,
                      onChanged: (value) => setState(() => _municipio = value),
                      validator: (value) =>
                          value == null ? 'Seleccione el municipio' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomFormField(
                      label: 'Punto de venta',
                      controller: _puntoVentaCtrl,
                      icon: Icons.storefront_outlined,
                      validator: (val) => val == null || val.trim().isEmpty
                          ? 'Ingrese el punto de venta'
                          : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FormSubmitButton(
                label: 'Guardar cliente',
                onPressed: _guardarFormulario,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
