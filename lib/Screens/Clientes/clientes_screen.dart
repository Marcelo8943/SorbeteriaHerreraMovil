import 'package:flutter/material.dart';
import 'widgets/clientes_widgets.dart';
import '../../theme/app_theme.dart';
import 'cliente_detalle_screen.dart';
import 'cliente_form_screen.dart';
import '../../widgets/search_filter_row.dart';
import '../../widgets/h_stat_card.dart';

// Importación de modelos y mock por entidad
import '../../models/app_models.dart';
import '../../models/mocks/mock_clientes.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  String _searchQuery = '';
  String _selectedDepartamento = 'Todos';
  String _selectedMunicipio = 'Todos';

  // Fuente de datos desde mock_clientes.dart
  final List<Cliente> _allClientes = List<Cliente>.from(mockClientes);

  Future<void> _openClientForm({Cliente? cliente}) async {
    final resultado = await Navigator.push<Cliente>(
      context,
      MaterialPageRoute(builder: (_) => ClienteFormScreen(cliente: cliente)),
    );

    if (!mounted || resultado == null) return;

    setState(() {
      final index = _allClientes.indexWhere((item) => item.id == resultado.id);
      if (index == -1) {
        _allClientes.insert(0, resultado);
      } else {
        _allClientes[index] = resultado;
      }
      _currentPage = 1;
    });
  }

  final List<String> _departamentos = [
    'Todos',
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

  final List<String> _municipios = [
    'Todos',
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

  // Búsqueda filtrada ÚNICAMENTE por nombre del cliente
  List<Cliente> get _filteredClientes {
    return _allClientes.where((cliente) {
      final matchesSearch = cliente.nombre.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );

      final matchesDepto =
          _selectedDepartamento == 'Todos' ||
          cliente.departamento == _selectedDepartamento;

      final matchesMuni =
          _selectedMunicipio == 'Todos' ||
          cliente.municipio == _selectedMunicipio;

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
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Departamento',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.lavender,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: tempDepto,
                        isExpanded: true,
                        dropdownColor: AppColors.card,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.muted,
                        ),
                        items: _departamentos
                            .map(
                              (val) => DropdownMenuItem(
                                value: val,
                                child: Text(
                                  val,
                                  style: const TextStyle(
                                    color: AppColors.ink,
                                    fontSize: 13.5,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) =>
                            setModalState(() => tempDepto = val!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Municipio',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.lavender,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: tempMuni,
                        isExpanded: true,
                        dropdownColor: AppColors.card,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.muted,
                        ),
                        items: _municipios
                            .map(
                              (val) => DropdownMenuItem(
                                value: val,
                                child: Text(
                                  val,
                                  style: const TextStyle(
                                    color: AppColors.ink,
                                    fontSize: 13.5,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) =>
                            setModalState(() => tempMuni = val!),
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
                          child: const Text(
                            'Limpiar',
                            style: TextStyle(
                              color: AppColors.ink,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Aplicar',
                            style: TextStyle(
                              color: AppColors.textOnPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
    final int effectivePage = _currentPage > totalPages && totalPages > 0
        ? totalPages
        : _currentPage;

    final int startIndex = (effectivePage - 1) * _itemsPerPage;
    final int endIndex = (startIndex + _itemsPerPage < filteredList.length)
        ? startIndex + _itemsPerPage
        : filteredList.length;

    final List<Cliente> displayedClientes = filteredList.isEmpty
        ? []
        : filteredList.sublist(startIndex, endIndex);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Topbar
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 12,
              ),
              color: AppColors.lavender,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // LOGO NATIVO
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
                            border: Border.all(
                              color: const Color(0xFF004B39),
                              width: 1.5,
                            ),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Sorbetería Herrera',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppColors.ink,
                            ),
                          ),
                          Text(
                            'Gestión de clientes',
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _openClientForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: AppColors.textOnPrimary,
                    ),
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

                    // Uso del widget global HStatCard
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          HStatCard(
                            title: 'Activos',
                            value: '${_allClientes.length}',
                            bgColor: AppToneColors.soft[AppTone.teal]!,
                            iconColor: AppToneColors.intense[AppTone.teal]!,
                            icon: Icons.people,
                          ),
                          const SizedBox(width: 10),
                          HStatCard(
                            title: 'Municipios',
                            value: '13',
                            bgColor: AppToneColors.soft[AppTone.red]!,
                            iconColor: AppToneColors.intense[AppTone.red]!,
                            icon: Icons.location_on,
                          ),
                          const SizedBox(width: 10),
                          HStatCard(
                            title: 'Puntos de venta',
                            value: '15',
                            bgColor: AppToneColors.soft[AppTone.purple]!,
                            iconColor: AppToneColors.intense[AppTone.purple]!,
                            icon: Icons.store,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Llamada a SearchFilterRow
                    SearchFilterRow(
                      hintText: 'Buscar clientes...',
                      onSearchChanged: (val) => setState(() {
                        _searchQuery = val;
                        _currentPage = 1;
                      }),
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
                            '${filteredList.length}',
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

                    Column(
                      children: List.generate(displayedClientes.length, (
                        index,
                      ) {
                        final cliente = displayedClientes[index];
                        return ClienteCardItem(
                          cliente: cliente,
                          index: index,
                          onTap: () {
                            Navigator.push<Cliente>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ClienteDetalleScreen(
                                  cliente: cliente,
                                  avatarColor: ClienteCardItem.colorForIndex(
                                    index,
                                  ),
                                ),
                              ),
                            ).then((resultado) {
                              if (!mounted || resultado == null) return;
                              setState(() {
                                final clienteIndex = _allClientes.indexWhere(
                                  (item) => item.id == resultado.id,
                                );
                                if (clienteIndex != -1) {
                                  _allClientes[clienteIndex] = resultado;
                                }
                              });
                            });
                          },
                        );
                      }),
                    ),

                    const SizedBox(height: 12),

                    ClientePaginationRow(
                      currentPage: effectivePage,
                      totalPages: totalPages,
                      onPrevious: () {
                        if (effectivePage > 1)
                          setState(() => _currentPage = effectivePage - 1);
                      },
                      onNext: () {
                        if (effectivePage < totalPages)
                          setState(() => _currentPage = effectivePage + 1);
                      },
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
