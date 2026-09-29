import 'package:flutter/material.dart';
import 'widgets/clientes_widgets.dart';
import '../../theme/app_theme.dart';
import 'cliente_detalle_screen.dart';
import 'cliente_form_screen.dart';
import '../../widgets/search_filter_row.dart';
import '../../widgets/h_stat_card.dart';
import '../../widgets/app_top_bar.dart';

// Importación de modelos y mock por entidad
import '../../models/app_models.dart';
import '../../models/mocks/mock_clientes.dart';
import '../../session.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  // Fuente de datos desde mock_clientes.dart
  final List<Cliente> _allClientes = List<Cliente>.unmodifiable(mockClientes);

  void _openClientForm({Cliente? cliente}) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(builder: (_) => ClienteFormScreen(cliente: cliente)),
    );
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

  void _showFilterModal() {
    String tempDepto = 'Todos';
    String tempMuni = 'Todos';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SafeArea(
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
                          onPressed: () => Navigator.pop(context),
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
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final clientes = _allClientes;

    final int totalPages = (clientes.length / _itemsPerPage).ceil();
    final int effectivePage = _currentPage > totalPages && totalPages > 0
        ? totalPages
        : _currentPage;

    final int startIndex = (effectivePage - 1) * _itemsPerPage;
    final int endIndex = (startIndex + _itemsPerPage < clientes.length)
        ? startIndex + _itemsPerPage
        : clientes.length;

    final List<Cliente> displayedClientes = clientes.isEmpty
        ? []
        : clientes.sublist(startIndex, endIndex);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              subtitle: 'Gestión de clientes',
              trailing: Session.esAdmin
                  ? ElevatedButton(
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
                    )
                  : const SizedBox(width: 48, height: 48),
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
                            '${clientes.length}',
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
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (context) => ClienteDetalleScreen(
                                  cliente: cliente,
                                  avatarColor: ClienteCardItem.colorForIndex(
                                    index,
                                  ),
                                ),
                              ),
                            );
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
