import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../models/mocks/mock_logs.dart';
import '../../theme/app_theme.dart';
import '../../widgets/h_stat_card.dart';
import '../../widgets/search_filter_row.dart';
import '../Productos/widgets/productos_widgets.dart';
import 'widgets/log_card.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  int _currentPage = 1;
  static const int _itemsPerPage = 10;

  String _searchQuery = '';
  String _filtroTipo = 'Todos';
  String _filtroModulo = 'Todos';
  String _filtroRangoFecha = 'Todos';

  static const List<String> _tiposEvento = [
    'Todos',
    'Creación',
    'Edición',
    'Desactivación',
    'Inicio de sesión',
  ];

  static const List<String> _modulos = [
    'Todos',
    'Precios',
    'Clientes',
    'Productos',
    'Usuarios',
    'Sistema',
  ];

  static const List<String> _rangosFecha = [
    'Todos',
    'Hoy',
    'Últimos 7 días',
    'Este mes',
    'Este año',
  ];

  List<LogEvento> get _filteredLogs {
    return mockLogs.where((l) {
      final query = _searchQuery.toLowerCase();
      final matchSearch =
          query.isEmpty ||
          l.descripcion.toLowerCase().contains(query) ||
          l.usuario.toLowerCase().contains(query) ||
          l.modulo.toLowerCase().contains(query);

      final matchTipo =
          _filtroTipo == 'Todos' ||
          l.tipo.toLowerCase() == _filtroTipo.toLowerCase() ||
          (_filtroTipo.toLowerCase() == 'desactivado' &&
              l.tipo == 'Desactivación');

      final matchModulo =
          _filtroModulo == 'Todos' ||
          l.modulo.toLowerCase() == _filtroModulo.toLowerCase() ||
          l.modulo.toLowerCase().startsWith(
            _filtroModulo.toLowerCase().substring(0, 4),
          );

      // 4. Rango de fecha
      final matchFecha = _evaluarRangoFecha(l, _filtroRangoFecha);

      return matchSearch && matchTipo && matchModulo && matchFecha;
    }).toList();
  }

  bool _evaluarRangoFecha(LogEvento l, String rango) {
    switch (rango) {
      case 'Hoy':
        return l.fecha == '16/08/2026' || l.fechaRelativa.startsWith('hace');
      case 'Últimos 7 días':
        return l.fechaRelativa.startsWith('hace') ||
            l.fechaRelativa == 'ayer' ||
            (l.fecha.endsWith('/08/2026') &&
                (l.fecha.startsWith('10') ||
                    l.fecha.startsWith('11') ||
                    l.fecha.startsWith('12') ||
                    l.fecha.startsWith('13') ||
                    l.fecha.startsWith('14') ||
                    l.fecha.startsWith('15') ||
                    l.fecha.startsWith('16')));
      case 'Este mes':
        return l.fecha.contains('/08/2026');
      case 'Este año':
        return l.fecha.contains('/2026');
      case 'Todos':
      default:
        return true;
    }
  }

  void _showFilterModal() {
    String tempTipo = _filtroTipo;
    String tempModulo = _filtroModulo;
    String tempRangoFecha = _filtroRangoFecha;

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
                    // Handle superior
                    Center(
                      child: Container(
                        width: 44,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: AppColors.line,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // Encabezado
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filtrar eventos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.ink,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.lavender,
                              borderRadius: BorderRadius.circular(10),
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

                    // 1. Tipo de evento
                    const _FilterLabel('Tipo de evento'),
                    const SizedBox(height: 6),
                    _FilterDropdown(
                      value: tempTipo,
                      items: _tiposEvento,
                      onChanged: (val) => setModalState(() => tempTipo = val!),
                    ),
                    const SizedBox(height: 16),

                    // 2. Módulo
                    const _FilterLabel('Módulo'),
                    const SizedBox(height: 6),
                    _FilterDropdown(
                      value: tempModulo,
                      items: _modulos,
                      onChanged: (val) =>
                          setModalState(() => tempModulo = val!),
                    ),
                    const SizedBox(height: 16),

                    // 3. Rango de fecha
                    const _FilterLabel('Rango de fecha'),
                    const SizedBox(height: 6),
                    _FilterDropdown(
                      value: tempRangoFecha,
                      items: _rangosFecha,
                      onChanged: (val) =>
                          setModalState(() => tempRangoFecha = val!),
                    ),
                    const SizedBox(height: 24),

                    // Botones Limpiar / Aplicar
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setModalState(() {
                                tempTipo = 'Todos';
                                tempModulo = 'Todos';
                                tempRangoFecha = 'Todos';
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.lavender,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
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
                                _filtroTipo = tempTipo;
                                _filtroModulo = tempModulo;
                                _filtroRangoFecha = tempRangoFecha;
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
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int eventosMes = mockLogs
        .where((l) => l.fecha.contains('/08/2026'))
        .length;
    final int iniciosSesion = mockLogs
        .where((l) => l.tipo == 'Inicio de sesión')
        .length;
    final int ediciones = mockLogs.where((l) => l.tipo == 'Edición').length;

    final filtered = _filteredLogs;
    final int totalPages = filtered.isEmpty
        ? 1
        : (filtered.length / _itemsPerPage).ceil();
    final int effectivePage = (_currentPage > totalPages && totalPages > 0)
        ? totalPages
        : _currentPage;
    final int startIndex = (effectivePage - 1) * _itemsPerPage;
    final int endIndex = (startIndex + _itemsPerPage < filtered.length)
        ? startIndex + _itemsPerPage
        : filtered.length;
    final displayedLogs = filtered.isEmpty
        ? <LogEvento>[]
        : filtered.sublist(startIndex, endIndex);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: AppSpacing.md, bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: [
                  HStatCard(
                    title: 'Eventos (mes)',
                    value: eventosMes.toString(),
                    bgColor: AppToneColors.soft[AppTone.teal]!,
                    iconColor: AppToneColors.intense[AppTone.teal]!,
                    icon: Icons.description_outlined,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  HStatCard(
                    title: 'Inicios de sesión',
                    value: iniciosSesion.toString(),
                    bgColor: AppToneColors.soft[AppTone.blue]!,
                    iconColor: AppToneColors.intense[AppTone.blue]!,
                    icon: Icons.lock_outline,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  HStatCard(
                    title: 'Ediciones',
                    value: ediciones.toString(),
                    bgColor: AppToneColors.soft[AppTone.yellow]!,
                    iconColor: AppToneColors.intense[AppTone.yellow]!,
                    icon: Icons.edit_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: SearchFilterRow(
                hintText: 'Buscar evento, usuario o módulo...',
                onSearchChanged: (val) {
                  setState(() {
                    _searchQuery = val.trim();
                    _currentPage = 1;
                  });
                },
                onFilterTap: _showFilterModal,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 4,
              ),
              child: Row(
                children: [
                  const Text(
                    'Eventos recientes',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
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
                      color: AppToneColors.soft[AppTone.teal],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${filtered.length}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppToneColors.intense[AppTone.teal],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),

            if (displayedLogs.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    'Sin resultados para los filtros aplicados.',
                    style: TextStyle(color: AppColors.muted, fontSize: 13),
                  ),
                ),
              )
            else
              Column(
                children: displayedLogs
                    .map((log) => LogCard(log: log))
                    .toList(),
              ),
            const SizedBox(height: 12),

            if (totalPages > 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: ProductoPaginationRow(
                  currentPage: effectivePage,
                  totalPages: totalPages,
                  onPrevious: effectivePage > 1
                      ? () => setState(() => _currentPage = effectivePage - 1)
                      : null,
                  onNext: effectivePage < totalPages
                      ? () => setState(() => _currentPage = effectivePage + 1)
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.card,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          size: 18,
          color: AppColors.ink,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        'Logs del Sistema',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      ),
    );
  }
}

class _FilterLabel extends StatelessWidget {
  final String text;
  const _FilterLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _FilterDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.lavender,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: AppColors.card,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.muted),
          items: items
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
          onChanged: onChanged,
        ),
      ),
    );
  }
}
