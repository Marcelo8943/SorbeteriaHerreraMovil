import 'package:flutter/material.dart';
import 'package:herrera_system/data/models/cliente_model.dart';
import 'package:herrera_system/services/cliente_service.dart';

import '../../theme/app_theme.dart';
import 'widgets/cliente_form_widgets.dart';

class ClienteFormScreen extends StatefulWidget {
  final ClienteModel? cliente;
  final ClienteService service;

  const ClienteFormScreen({
    super.key,
    required this.service,
    this.cliente,
  });

  @override
  State<ClienteFormScreen> createState() => _ClienteFormScreenState();
}

class _ClienteFormScreenState extends State<ClienteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _apellidoCtrl;
  late final TextEditingController _puntoVentaCtrl;
  late final TextEditingController _direccionPuntoVentaCtrl;
  late final TextEditingController _telefonoCtrl;
  List<DepartamentoCliente> _departamentos = const [];
  List<MunicipioCliente> _municipios = const [];
  int? _departmentId;
  int? _municipalityId;
  bool _esActivo = true;
  bool _cargandoCatalogos = true;
  bool _guardando = false;
  String? _errorCatalogos;
  String? _errorGuardar;

  bool get _esEdicion => widget.cliente != null;

  @override
  void initState() {
    super.initState();
    final cliente = widget.cliente;
    _nombreCtrl = TextEditingController(text: cliente?.firstName ?? '');
    _apellidoCtrl = TextEditingController(text: cliente?.lastName ?? '');
    _puntoVentaCtrl = TextEditingController(text: cliente?.pointOfSale ?? '');
    _direccionPuntoVentaCtrl = TextEditingController(
      text: cliente?.posAddress ?? '',
    );
    _telefonoCtrl = TextEditingController(text: cliente?.phone ?? '');
    _departmentId = cliente?.departmentId;
    _municipalityId = cliente?.municipalityId;
    _esActivo = cliente?.isActive ?? true;
    _cargarCatalogos();
  }

  Future<void> _cargarCatalogos() async {
    setState(() {
      _cargandoCatalogos = true;
      _errorCatalogos = null;
    });
    try {
      final departments = await widget.service.obtenerDepartamentos();
      final municipalities = _departmentId == null
          ? <MunicipioCliente>[]
          : await widget.service.obtenerMunicipios(_departmentId!);
      if (!mounted) return;
      setState(() {
        _departamentos = departments;
        _municipios = municipalities;
        _cargandoCatalogos = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _cargandoCatalogos = false;
        _errorCatalogos = 'No se pudieron cargar departamentos y municipios.';
      });
    }
  }

  Future<void> _cargarMunicipios(int departmentId) async {
    setState(() {
      _municipios = const [];
      _municipalityId = null;
      _cargandoCatalogos = true;
      _errorCatalogos = null;
    });
    try {
      final municipalities = await widget.service.obtenerMunicipios(departmentId);
      if (!mounted) return;
      setState(() {
        _municipios = municipalities;
        _cargandoCatalogos = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _cargandoCatalogos = false;
        _errorCatalogos = 'No se pudieron cargar los municipios.';
      });
    }
  }

  String? _validarNombre(String? value, String campo) {
    final nombre = value?.trim() ?? '';
    if (nombre.isEmpty) return 'Ingrese el $campo';
    if (nombre.length < 2 ||
        !RegExp(r"^[A-Za-zÀ-ÿÑñÜü\s'-]+$").hasMatch(nombre)) {
      return 'Ingrese un $campo válido';
    }
    return null;
  }

  String? _validarTelefono(String? value) {
    final telefono = value?.trim() ?? '';
    if (telefono.isEmpty) return 'Ingrese el teléfono';
    if (!RegExp(r'^[+\d\s()-]+$').hasMatch(telefono)) {
      return 'Ingrese un teléfono válido';
    }
    final digits = telefono.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 8 && !(digits.length == 11 && digits.startsWith('505'))) {
      return 'Ingrese un teléfono válido de 8 dígitos';
    }
    return null;
  }

  Future<void> _guardarFormulario() async {
    if (!_formKey.currentState!.validate()) return;
    if (_municipalityId == null) {
      setState(() => _errorGuardar = 'Seleccione un municipio.');
      return;
    }
    setState(() {
      _guardando = true;
      _errorGuardar = null;
    });
    try {
      final args = {
        'municipalityId': _municipalityId!,
        'firstName': _nombreCtrl.text.trim(),
        'lastName': _apellidoCtrl.text.trim(),
        'phone': _telefonoCtrl.text.trim(),
        'pointOfSale': _puntoVentaCtrl.text.trim(),
        'posAddress': _direccionPuntoVentaCtrl.text.trim(),
      };
      if (_esEdicion) {
        await widget.service.actualizarCliente(
          id: widget.cliente!.id,
          isActive: _esActivo,
          municipalityId: args['municipalityId'] as int,
          firstName: args['firstName'] as String,
          lastName: args['lastName'] as String,
          phone: args['phone'] as String,
          pointOfSale: args['pointOfSale'] as String,
          posAddress: args['posAddress'] as String,
        );
      } else {
        await widget.service.crearCliente(
          municipalityId: args['municipalityId'] as int,
          firstName: args['firstName'] as String,
          lastName: args['lastName'] as String,
          phone: args['phone'] as String,
          pointOfSale: args['pointOfSale'] as String,
          posAddress: args['posAddress'] as String,
        );
      }
      if (mounted) Navigator.pop(context, true);
    } catch (exception) {
      if (!mounted) return;
      setState(() {
        _guardando = false;
        _errorGuardar = exception.toString().replaceFirst(
          RegExp(r'^[^:]+: '),
          '',
        );
      });
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _apellidoCtrl.dispose();
    _puntoVentaCtrl.dispose();
    _direccionPuntoVentaCtrl.dispose();
    _telefonoCtrl.dispose();
    super.dispose();
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
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.ink),
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
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CustomFormField(
                      label: 'Nombre', controller: _nombreCtrl,
                      icon: Icons.person_outline,
                      validator: (value) => _validarNombre(value, 'nombre'),
                    ),
                    const SizedBox(height: 16),
                    CustomFormField(
                      label: 'Apellido', controller: _apellidoCtrl,
                      icon: Icons.person_outline,
                      validator: (value) => _validarNombre(value, 'apellido'),
                    ),
                    const SizedBox(height: 16),
                    CustomFormField(
                      label: 'Teléfono', controller: _telefonoCtrl,
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: _validarTelefono,
                    ),
                    const SizedBox(height: 16),
                    _catalogDropdown(
                      label: 'Departamento',
                      value: _departmentId,
                      entries: _departamentos.map((item) => (item.id, item.nombre)),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _departmentId = value);
                        _cargarMunicipios(value);
                      },
                    ),
                    const SizedBox(height: 16),
                    _catalogDropdown(
                      label: 'Municipio',
                      value: _municipalityId,
                      entries: _municipios.map((item) => (item.id, item.nombre)),
                      onChanged: (value) =>
                          setState(() => _municipalityId = value),
                      enabled: !_cargandoCatalogos && _municipios.isNotEmpty,
                    ),
                    if (_cargandoCatalogos) ...[
                      const SizedBox(height: 12),
                      const LinearProgressIndicator(),
                    ],
                    if (_errorCatalogos != null) ...[
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: _cargarCatalogos,
                        icon: const Icon(Icons.refresh),
                        label: Text(_errorCatalogos!),
                      ),
                    ],
                    const SizedBox(height: 16),
                    CustomFormField(
                      label: 'Punto de venta', controller: _puntoVentaCtrl,
                      icon: Icons.storefront_outlined,
                      validator: (value) => value == null || value.trim().isEmpty
                          ? 'Ingrese el punto de venta'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    CustomFormField(
                      label: 'Dirección del punto de venta',
                      controller: _direccionPuntoVentaCtrl,
                      icon: Icons.location_on_outlined,
                      validator: (value) => value == null || value.trim().isEmpty
                          ? 'Ingrese la dirección del punto de venta'
                          : null,
                    ),
                    if (_esEdicion) ...[
                      const SizedBox(height: 16),
                      ClienteEstadoSwitch(
                        activo: _esActivo,
                        onChanged: (value) => setState(() => _esActivo = value),
                      ),
                    ],
                    if (_errorGuardar != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _errorGuardar!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FormSubmitButton(
                label: _guardando ? 'Guardando...' : 'Guardar cliente',
                onPressed: _guardando ? null : _guardarFormulario,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _catalogDropdown({
    required String label,
    required int? value,
    required Iterable<(int, String)> entries,
    required ValueChanged<int?> onChanged,
    bool enabled = true,
  }) {
    final items = entries.toList();
    final selectedValue = items.any((item) => item.$1 == value) ? value : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: selectedValue,
          validator: (item) => item == null ? 'Seleccione $label' : null,
          decoration: InputDecoration(
            prefixIcon: Icon(
              label == 'Departamento' ? Icons.map_outlined : Icons.location_city_outlined,
              color: AppColors.muted,
              size: 20,
            ),
          ),
          items: items
              .map((item) => DropdownMenuItem(value: item.$1, child: Text(item.$2)))
              .toList(),
          onChanged: enabled ? onChanged : null,
        ),
      ],
    );
  }
}
