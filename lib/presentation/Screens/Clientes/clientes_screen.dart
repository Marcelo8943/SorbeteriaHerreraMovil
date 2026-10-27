import 'package:flutter/material.dart';
import 'package:herrera_system/data/models/cliente_model.dart';
import 'package:herrera_system/presentation/Screens/Clientes/clientes_module.dart';
import 'package:herrera_system/presentation/providers/cliente_provider.dart';

import '../../../session.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/h_stat_card.dart';
import '../../widgets/search_filter_row.dart';
import 'cliente_detalle_screen.dart';
import 'cliente_form_screen.dart';
import 'widgets/clientes_widgets.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  late final ClientesModule _module;
  ClienteProvider get _provider => _module.provider;

  @override
  void initState() {
    super.initState();
    _module = ClientesModule.create();
    _provider.addListener(_onProviderChanged);
    _provider.cargar();
  }

  void _onProviderChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _provider.removeListener(_onProviderChanged);
    _module.dispose();
    super.dispose();
  }

  Future<void> _openClientForm({ClienteModel? cliente}) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (_) => ClienteFormScreen(
          service: _module.service,
          cliente: cliente,
        ),
      ),
    );
    if (saved == true && mounted) await _provider.cargar(page: 1);
  }

  Future<void> _openClientDetails(ClienteModel cliente, int index) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (_) => ClienteDetalleScreen(
          cliente: cliente,
          avatarColor: ClienteCardItem.colorForIndex(index),
          service: _module.service,
        ),
      ),
    );
    if (changed == true && mounted) await _provider.cargar();
  }

  Future<void> _showFilterModal() async {
    List<DepartamentoCliente> departments;
    try {
      departments = await _module.service.obtenerDepartamentos();
    } catch (exception) {
      if (mounted) _showMessage('No se pudieron cargar los departamentos.');
      return;
    }
    if (!mounted) return;

    var selectedDepartment = _provider.departmentId;
    var selectedMunicipality = _provider.municipalityId;
    var municipalities = <MunicipioCliente>[];
    if (selectedDepartment != null) {
      try {
        municipalities = await _module.service.obtenerMunicipios(
          selectedDepartment,
        );
      } catch (_) {
        if (mounted) _showMessage('No se pudieron cargar los municipios.');
        return;
      }
    }

    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setModalState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filtrar clientes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      icon: const Icon(Icons.close, color: AppColors.ink),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _filterDropdown<int>(
                  label: 'Departamento',
                  value: selectedDepartment ?? 0,
                  items: [
                    const DropdownMenuItem(value: 0, child: Text('Todos')),
                    ...departments.map(
                      (item) => DropdownMenuItem(
                        value: item.id,
                        child: Text(item.nombre),
                      ),
                    ),
                  ],
                  onChanged: (value) async {
                    selectedDepartment = value == 0 ? null : value;
                    selectedMunicipality = null;
                    setModalState(() => municipalities = []);
                    if (selectedDepartment != null) {
                      try {
                        final result = await _module.service.obtenerMunicipios(
                          selectedDepartment!,
                        );
                        setModalState(() => municipalities = result);
                      } catch (_) {
                        _showMessage('No se pudieron cargar los municipios.');
                      }
                    }
                  },
                ),
                const SizedBox(height: 12),
                _filterDropdown<int>(
                  label: 'Municipio',
                  value: selectedMunicipality ?? 0,
                  items: [
                    const DropdownMenuItem(value: 0, child: Text('Todos')),
                    ...municipalities.map(
                      (item) => DropdownMenuItem(
                        value: item.id,
                        child: Text(item.nombre),
                      ),
                    ),
                  ],
                  onChanged: (value) => setModalState(
                    () => selectedMunicipality = value == 0 ? null : value,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => setModalState(() {
                          selectedDepartment = null;
                          selectedMunicipality = null;
                          municipalities = [];
                        }),
                        child: const Text('Limpiar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(sheetContext);
                          _provider.aplicarFiltros(
                            newDepartmentId: selectedDepartment,
                            newMunicipalityId: selectedMunicipality,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        child: const Text(
                          'Aplicar',
                          style: TextStyle(color: AppColors.textOnPrimary),
                        ),
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

  Widget _filterDropdown<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.lavender,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stats = _provider.estadisticas;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              subtitle: 'Gestión de clientes',
              trailing: Session.esAdmin
                  ? ElevatedButton(
                      onPressed: () => _openClientForm(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: AppColors.textOnPrimary,
                      ),
                    )
                  : const SizedBox(width: 48, height: 48),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _provider.cargar,
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    const Text(
                      'Clientes',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const Text(
                      'Consulta y administra tu cartera de clientes.',
                      style: TextStyle(fontSize: 12.5, color: AppColors.muted),
                    ),
                    const SizedBox(height: 14),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          HStatCard(
                            title: 'Activos',
                            value: '${stats?.activos ?? 0}',
                            bgColor: AppToneColors.soft[AppTone.teal]!,
                            iconColor: AppToneColors.intense[AppTone.teal]!,
                            icon: Icons.people,
                          ),
                          const SizedBox(width: 10),
                          HStatCard(
                            title: 'Municipios',
                            value: '${stats?.municipios ?? 0}',
                            bgColor: AppToneColors.soft[AppTone.red]!,
                            iconColor: AppToneColors.intense[AppTone.red]!,
                            icon: Icons.location_on,
                          ),
                          const SizedBox(width: 10),
                          HStatCard(
                            title: 'Puntos de venta',
                            value: '${stats?.puntosVentaActivos ?? 0}',
                            bgColor: AppToneColors.soft[AppTone.purple]!,
                            iconColor: AppToneColors.intense[AppTone.purple]!,
                            icon: Icons.store,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    SearchFilterRow(
                      hintText: 'Buscar clientes...',
                      onSearchChanged: _provider.buscar,
                      onFilterTap: _showFilterModal,
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        const Text(
                          'Lista de Clientes',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_provider.totalRecords}',
                            style: const TextStyle(
                              color: AppColors.textOnPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_provider.cargando)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 36),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (_provider.error != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        child: Column(
                          children: [
                            Text(
                              'No se pudieron cargar los clientes. ${_provider.error}',
                              textAlign: TextAlign.center,
                            ),
                            TextButton(
                              onPressed: _provider.cargar,
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      )
                    else if (_provider.clientes.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(child: Text('No se encontraron clientes')),
                      )
                    else
                      Column(
                        children: List.generate(_provider.clientes.length, (i) {
                          final cliente = _provider.clientes[i];
                          final index =
                              (_provider.currentPage - 1) * ClienteProvider.pageSize +
                              i;
                          return ClienteCardItem(
                            cliente: cliente,
                            index: index,
                            onTap: () => _openClientDetails(cliente, index),
                          );
                        }),
                      ),
                    const SizedBox(height: 12),
                    if (!_provider.cargando && _provider.totalPages > 0)
                      ClientePaginationRow(
                        currentPage: _provider.currentPage,
                        totalPages: _provider.totalPages,
                        onPrevious: _provider.currentPage > 1
                            ? () => _provider.cargar(
                                page: _provider.currentPage - 1,
                              )
                            : null,
                        onNext: _provider.currentPage < _provider.totalPages
                            ? () => _provider.cargar(
                                page: _provider.currentPage + 1,
                              )
                            : null,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
