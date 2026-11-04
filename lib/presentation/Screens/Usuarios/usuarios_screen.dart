import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/view_status.dart';
import '../../theme/app_theme.dart';
import '../../../data/models/user_model.dart';
import '../../providers/roles_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/error_view.dart';
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
  String _searchText = '';
  String _selectedRole = 'Todos';
  String _selectedStatus = 'Todos';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<UserProvider>().getAll();
        context.read<RolesProvider>().loadRoles();
      }
    });
  }

  // Navegación al formulario de nuevo usuario
  Future<void> _openUserForm({UserModel? usuario}) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => UsuarioFormScreen(usuario: usuario)),
    );
  }

  // BottomSheet modal de filtros
  void _showFilterModal() {
    var selectedRole = _selectedRole;
    var selectedStatus = _selectedStatus;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final rolesProvider = context.watch<RolesProvider>();
          final roleNames = rolesProvider.roles
              .map((role) => role.roleName)
              .toSet()
              .toList();
          final roleOptions = ['Todos', ...roleNames];
          if (!roleOptions.contains(selectedRole)) selectedRole = 'Todos';

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
                  if (rolesProvider.status == ViewStatus.loading ||
                      rolesProvider.status == ViewStatus.initial)
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (rolesProvider.status == ViewStatus.error)
                    TextButton(
                      onPressed: rolesProvider.loadRoles,
                      child: Text(
                        rolesProvider.errorMessage ??
                            'No se pudieron cargar los roles. Reintentar.',
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.lavender,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedRole,
                          isExpanded: true,
                          dropdownColor: AppColors.card,
                          items: roleOptions
                              .map(
                                (role) => DropdownMenuItem(
                                  value: role,
                                  child: Text(role),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setModalState(() => selectedRole = value);
                            }
                          },
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
                        value: selectedStatus,
                        isExpanded: true,
                        dropdownColor: AppColors.card,
                        items: const [
                          DropdownMenuItem(
                            value: 'Todos',
                            child: Text('Todos'),
                          ),
                          DropdownMenuItem(
                            value: 'Activo',
                            child: Text('Activo'),
                          ),
                          DropdownMenuItem(
                            value: 'Inactivo',
                            child: Text('Inactivo'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setModalState(() => selectedStatus = value);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedRole = 'Todos';
                              _selectedStatus = 'Todos';
                              _currentPage = 1;
                            });
                            Navigator.pop(context);
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
                              _selectedRole = selectedRole;
                              _selectedStatus = selectedStatus;
                              _currentPage = 1;
                            });
                            Navigator.pop(context);
                          },
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final usuarios = userProvider.users;
    final filteredUsers = usuarios.where((usuario) {
      final query = _searchText.toLowerCase();
      final matchesSearch =
          query.isEmpty ||
          usuario.fullName.toLowerCase().contains(query) ||
          usuario.userName.toLowerCase().contains(query) ||
          usuario.email.toLowerCase().contains(query);
      final matchesRole =
          _selectedRole == 'Todos' ||
          usuario.roles.any(
            (role) => role.toLowerCase() == _selectedRole.toLowerCase(),
          );
      final matchesStatus =
          _selectedStatus == 'Todos' ||
          (_selectedStatus == 'Activo' && usuario.isActive) ||
          (_selectedStatus == 'Inactivo' && !usuario.isActive);
      return matchesSearch && matchesRole && matchesStatus;
    }).toList();
    final totalPages = filteredUsers.isEmpty
        ? 1
        : (filteredUsers.length / _itemsPerPage).ceil();
    final currentPage = _currentPage.clamp(1, totalPages).toInt();
    final startIndex = (currentPage - 1) * _itemsPerPage;
    final pageUsers = filteredUsers
        .skip(startIndex)
        .take(_itemsPerPage)
        .toList();

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
              child: RefreshIndicator(
                onRefresh: () => context.read<UserProvider>().getAll(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 14),

                      // Barra de búsqueda con botón de filtros
                      SearchFilterRow(
                        hintText: 'Buscar por nombre o usuario...',
                        onFilterTap: _showFilterModal,
                        onSearchChanged: (value) {
                          setState(() {
                            _searchText = value.trim();
                            _currentPage = 1;
                          });
                        },
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
                              '${filteredUsers.length}',
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
                      if (userProvider.viewStatus == ViewStatus.initial ||
                          userProvider.viewStatus == ViewStatus.loading)
                        const LoadingView(message: 'Cargando usuarios...')
                      else if (userProvider.viewStatus == ViewStatus.error)
                        ErrorView(
                          errorMessage:
                              userProvider.errorMessage ??
                              'No se pudieron cargar los usuarios.',
                          onRetry: () => userProvider.getAll(),
                        )
                      else if (filteredUsers.isEmpty)
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: Text(
                                usuarios.isEmpty
                                    ? 'No hay usuarios registrados.'
                                    : 'No hay usuarios que coincidan con la búsqueda o los filtros.',
                              ),
                            ),
                          ),
                        )
                      else
                        Column(
                          children: pageUsers.map((usuario) {
                            return UsuarioCardItem(
                              usuario: usuario,
                              onTap: () async {
                                await Navigator.push<bool>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => UsuarioDetalleScreen(
                                      usuario: usuario,
                                      avatarColor:
                                          usuario.roleName == 'Administrador'
                                          ? AppColors.primary
                                          : AppToneColors.intense[AppTone
                                                .purple]!,
                                    ),
                                  ),
                                );
                                // El formulario refresca la lista al guardar.
                              },
                            );
                          }).toList(),
                        ),

                      const SizedBox(height: 14),

                      UsuarioPaginationRow(
                        currentPage: _currentPage,
                        totalPages: totalPages,
                        onPrevious: () {
                          if (currentPage > 1) {
                            setState(() => _currentPage = currentPage - 1);
                          }
                        },
                        onNext: () {
                          if (currentPage < totalPages) {
                            setState(() => _currentPage = currentPage + 1);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
