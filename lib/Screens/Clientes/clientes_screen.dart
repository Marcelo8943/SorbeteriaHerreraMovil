import 'package:flutter/material.dart';
import 'widgets.dart';
import '../ClientesDetalle/cliente_detalle_screen.dart';
import '../../theme/app_theme.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({Key? key}) : super(key: key);

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  String _searchQuery = '';
  String _selectedDepartamento = 'Todos';
  String _selectedMunicipio = 'Todos';

  final List<Map<String, String>> _allClientes = const [
    {
      'nombre': 'Roberto Argüello',
      'municipio': 'Catarina',
      'departamento': 'Masaya',
      'puntoVenta': 'Heladería & Snacks Masaya',
      'iniciales': 'RA',
    },
    {
      'nombre': 'Luisa Fernanda Campos',
      'municipio': 'Diriomo',
      'departamento': 'Granada',
      'puntoVenta': 'Minisuper Diriomo',
      'iniciales': 'LF',
    },
    {
      'nombre': 'Nohelia Cortes',
      'municipio': 'Tipitapa',
      'departamento': 'Managua',
      'puntoVenta': 'Teresa',
      'iniciales': 'NC',
    },
    {
      'nombre': 'Carlos Gutiérrez',
      'municipio': 'Jinotepe',
      'departamento': 'Carazo',
      'puntoVenta': 'Pulpería El Rosario',
      'iniciales': 'CG',
    },
    {
      'nombre': 'Ana Sofía Sevilla',
      'municipio': 'Granada',
      'departamento': 'Granada',
      'puntoVenta': 'Distribuidora La Fe',
      'iniciales': 'AS',
    },
    {
      'nombre': 'Jorge Luis Torres',
      'municipio': 'Rivas',
      'departamento': 'Rivas',
      'puntoVenta': 'Variedades San José',
      'iniciales': 'JT',
    },
    {
      'nombre': 'Elena Rostrán',
      'municipio': 'León',
      'departamento': 'León',
      'puntoVenta': 'Super Comercio Rostrán',
      'iniciales': 'ER',
    },
    {
      'nombre': 'Félix Salgado',
      'municipio': 'Chinandega',
      'departamento': 'Chinandega',
      'puntoVenta': 'Sorbetería La Fuente',
      'iniciales': 'FS',
    },
    {
      'nombre': 'Lucía Bermúdez',
      'municipio': 'Estelí',
      'departamento': 'Estelí',
      'puntoVenta': 'Comercial El Carmen',
      'iniciales': 'LB',
    },
    {
      'nombre': 'Gabriel Peralta',
      'municipio': 'Matagalpa',
      'departamento': 'Matagalpa',
      'puntoVenta': 'Variedades Peralta',
      'iniciales': 'GP',
    },
    {
      'nombre': 'Sonia Blandón',
      'municipio': 'Jinotega',
      'departamento': 'Jinotega',
      'puntoVenta': 'Pulpería La Bendición',
      'iniciales': 'SB',
    },
    {
      'nombre': 'Víctor Ruiz',
      'municipio': 'Masaya',
      'departamento': 'Masaya',
      'puntoVenta': 'Distribuidora Ruiz',
      'iniciales': 'VR',
    },
  ];

  final List<String> _departamentos = ['Todos', 'Masaya', 'Granada', 'Managua', 'Carazo', 'Rivas', 'León', 'Chinandega', 'Estelí', 'Matagalpa', 'Jinotega'];
  final List<String> _municipios = ['Todos', 'Catarina', 'Diriomo', 'Tipitapa', 'Jinotepe', 'Granada', 'Rivas', 'León', 'Chinandega', 'Estelí', 'Matagalpa', 'Jinotega', 'Masaya'];

  // Búsqueda filtrada ÚNICAMENTE por nombre del cliente
  List<Map<String, String>> get _filteredClientes {
    return _allClientes.where((cliente) {
      final matchesSearch = cliente['nombre']!
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());

      final matchesDepto = _selectedDepartamento == 'Todos' ||
          cliente['departamento'] == _selectedDepartamento;

      final matchesMuni = _selectedMunicipio == 'Todos' ||
          cliente['municipio'] == _selectedMunicipio;

      return matchesSearch && matchesDepto && matchesMuni;
    }).toList();
  }

  void _showFilterModal() {
    String tempDepto = _selectedDepartamento;
    String tempMuni = _selectedMunicipio;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
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
                        onPressed: () => Navigator.pop(context),
                        icon: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.lavender,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.close, size: 18, color: AppColors.ink),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Departamento', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.ink)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(color: AppColors.lavender, borderRadius: BorderRadius.circular(12)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: tempDepto,
                        isExpanded: true,
                        dropdownColor: AppColors.card,
                        icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.muted),
                        items: _departamentos.map((val) => DropdownMenuItem(value: val, child: Text(val, style: const TextStyle(color: AppColors.ink, fontSize: 13.5)))).toList(),
                        onChanged: (val) => setModalState(() => tempDepto = val!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Municipio', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.ink)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(color: AppColors.lavender, borderRadius: BorderRadius.circular(12)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: tempMuni,
                        isExpanded: true,
                        dropdownColor: AppColors.card,
                        icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.muted),
                        items: _municipios.map((val) => DropdownMenuItem(value: val, child: Text(val, style: const TextStyle(color: AppColors.ink, fontSize: 13.5)))).toList(),
                        onChanged: (val) => setModalState(() => tempMuni = val!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setModalState(() {
                              tempDepto = 'Todos';
                              tempMuni = 'Todos';
                            });
                          },
                          child: const Text('Limpiar', style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedDepartamento = tempDepto;
                              _selectedMunicipio = tempMuni;
                              _currentPage = 1;
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Aplicar', style: TextStyle(color: AppColors.textOnPrimary, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredClientes;
    
    final int totalPages = (filteredList.length / _itemsPerPage).ceil();
    final int effectivePage = _currentPage > totalPages && totalPages > 0 ? totalPages : _currentPage;
    
    final int startIndex = (effectivePage - 1) * _itemsPerPage;
    final int endIndex = (startIndex + _itemsPerPage < filteredList.length) ? startIndex + _itemsPerPage : filteredList.length;

    final List<Map<String, String>> displayedClientes =
        filteredList.isEmpty ? [] : filteredList.sublist(startIndex, endIndex);

    final bool isFilterActive = _selectedDepartamento != 'Todos' || _selectedMunicipio != 'Todos';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Topbar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
              color: AppColors.lavender,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 42,
                          height: 42,
                          color: AppColors.primary,
                          child: const Icon(Icons.icecream, color: AppColors.textOnPrimary),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Sorbetería Herrera', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.ink)),
                          Text('Gestión de clientes', style: TextStyle(color: AppColors.muted, fontSize: 11.5)),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                    ),
                    child: const Icon(Icons.add, color: AppColors.textOnPrimary),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Clientes', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.ink, letterSpacing: -0.5)),
                    const Text('Consulta y administra tu cartera de clientes.', style: TextStyle(fontSize: 12.5, color: AppColors.muted)),
                    const SizedBox(height: 14),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ClienteStatCard(title: 'Activos', value: '${_allClientes.length}', bgColor: AppToneColors.soft[AppTone.teal]!, iconColor: AppToneColors.intense[AppTone.teal]!, icon: Icons.people),
                          const SizedBox(width: 10),
                          ClienteStatCard(title: 'Municipios', value: '13', bgColor: AppToneColors.soft[AppTone.red]!, iconColor: AppToneColors.intense[AppTone.red]!, icon: Icons.location_on),
                          const SizedBox(width: 10),
                          ClienteStatCard(title: 'Puntos de venta', value: '15', bgColor: AppToneColors.soft[AppTone.purple]!, iconColor: AppToneColors.intense[AppTone.purple]!, icon: Icons.store),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    ClienteSearchFilterRow(
                      isFilterActive: isFilterActive,
                      onSearchChanged: (val) => setState(() { _searchQuery = val; _currentPage = 1; }),
                      onFilterTap: _showFilterModal,
                    ),
                    const SizedBox(height: 18),

                    Row(
                      children: [
                        const Text('Lista de Clientes', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.ink)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                          child: Text('${filteredList.length}', style: const TextStyle(color: AppColors.textOnPrimary, fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Column(
                      children: displayedClientes.map((item) {
                        return ClienteCardItem(
                          nombre: item['nombre']!,
                          puntoVenta: item['puntoVenta']!,
                          municipio: '${item['municipio']} (${item['departamento']})',
                          iniciales: item['iniciales']!,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ClienteDetalleScreen(clienteData: item),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 12),

                    ClientePaginationRow(
                      currentPage: effectivePage,
                      totalPages: totalPages,
                      onPrevious: () { if (effectivePage > 1) setState(() => _currentPage = effectivePage - 1); },
                      onNext: () { if (effectivePage < totalPages) setState(() => _currentPage = effectivePage + 1); },
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