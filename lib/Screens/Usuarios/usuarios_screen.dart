import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/app_models.dart';
import '../../models/mocks/mock_usuarios.dart';
import '../../widgets/h_stat_card.dart';
import '../../widgets/search_filter_row.dart';
import 'usuario_detalle_screen.dart';
import 'usuario_form_screen.dart';
import 'widgets/usuarios_widgets.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  // Navegación al formulario de nuevo usuario
  void _openUserForm({Usuario? usuario}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UsuarioFormScreen(usuario: usuario)),
    );
  }

  // BottomSheet modal de filtros
  void _showFilterModal() {
    String selectedRol = 'Administrador';
    String selectedEstado = 'Todos';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
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
                      'Filtrar usuarios',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Container(
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
                const Text(
                  'Rol',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
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
                      value: selectedRol,
                      isExpanded: true,
                      dropdownColor: AppColors.card,
                      items: const [
                        DropdownMenuItem(value: 'Todos', child: Text('Todos')),
                        DropdownMenuItem(
                          value: 'Administrador',
                          child: Text('Administrador'),
                        ),
                        DropdownMenuItem(
                          value: 'Gerente',
                          child: Text('Gerente'),
                        ),
                      ],
                      onChanged: (_) {},
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Estado',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
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
                      value: selectedEstado,
                      isExpanded: true,
                      dropdownColor: AppColors.card,
                      items: const [
                        DropdownMenuItem(value: 'Todos', child: Text('Todos')),
                        DropdownMenuItem(
                          value: 'Activo',
                          child: Text('Activo'),
                        ),
                        DropdownMenuItem(
                          value: 'Inactivo',
                          child: Text('Inactivo'),
                        ),
                      ],
                      onChanged: (_) {},
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
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
                            borderRadius: BorderRadius.circular(14),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Encabezado personalizado (Back + Título Usuarios + Botón +)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Usuarios',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.ink,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      onPressed: () => _openUserForm(),
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.add,
                        color: AppColors.textOnPrimary,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stat Cards
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          HStatCard(
                            title: 'Activos',
                            value: '4',
                            bgColor: AppToneColors.soft[AppTone.teal]!,
                            iconColor: AppToneColors.intense[AppTone.teal]!,
                            icon: Icons.people_outline,
                          ),
                          const SizedBox(width: 10),
                          HStatCard(
                            title: 'Administradores',
                            value: '2',
                            bgColor: AppToneColors.soft[AppTone.yellow]!,
                            iconColor: AppToneColors.intense[AppTone.yellow]!,
                            icon: Icons.shield_outlined,
                          ),
                          const SizedBox(width: 10),
                          HStatCard(
                            title: 'Gerentes',
                            value: '2',
                            bgColor: AppToneColors.soft[AppTone.purple]!,
                            iconColor: AppToneColors.intense[AppTone.purple]!,
                            icon: Icons.person_outline,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Barra de búsqueda con botón de filtros
                    SearchFilterRow(
                      hintText: 'Buscar por nombre o usuario...',
                      onFilterTap: _showFilterModal,
                    ),
                    const SizedBox(height: 18),

                    // Encabezado de Lista con Badge Contador
                    Row(
                      children: [
                        const Text(
                          'Lista de Usuarios',
                          style: TextStyle(
                            fontSize: 15,
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
                            '${mockUsuarios.length}',
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

                    // Lista de Tarjetas de Usuarios
                    Column(
                      children: List.generate(mockUsuarios.length, (index) {
                        final usuario = mockUsuarios[index];
                        return UsuarioCardItem(
                          usuario: usuario,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UsuarioDetalleScreen(
                                  usuario: usuario,
                                  avatarColor: usuario.rol == 'Administrador'
                                      ? AppColors.primary
                                      : AppToneColors.intense[AppTone.purple]!,
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),

                    const SizedBox(height: 14),

                    // Control de Paginación idéntico al de Clientes
                    UsuarioPaginationRow(
                      currentPage: _currentPage,
                      totalPages:
                          (mockUsuarios.length / _itemsPerPage).ceil() > 0
                          ? (mockUsuarios.length / _itemsPerPage).ceil()
                          : 1,
                      onPrevious: () {
                        if (_currentPage > 1) {
                          setState(() => _currentPage--);
                        }
                      },
                      onNext: () {
                        final totalPages = (mockUsuarios.length / _itemsPerPage)
                            .ceil();
                        if (_currentPage < totalPages) {
                          setState(() => _currentPage++);
                        }
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
