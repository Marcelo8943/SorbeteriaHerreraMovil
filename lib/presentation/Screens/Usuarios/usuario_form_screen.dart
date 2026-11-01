import 'package:flutter/material.dart';
import 'package:herrera_system/presentation/providers/roles_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/view_status.dart';
import '../../../data/models/roles_model.dart';
import '../../../data/models/user_model.dart';

import '../../providers/user_form_provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';
import 'widgets/usuario_form_widgets.dart';

class UsuarioFormScreen extends StatefulWidget {
  final UserModel? usuario;

  const UsuarioFormScreen({super.key, this.usuario});

  @override
  State<UsuarioFormScreen> createState() => _UsuarioFormScreenState();
}

class _UsuarioFormScreenState extends State<UsuarioFormScreen> {
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _apellidoCtrl;
  late final TextEditingController _usuarioCtrl;
  late final TextEditingController _correoCtrl;
  late final TextEditingController _cedulaCtrl;
  late final TextEditingController _passwordCtrl;
  String? _rol;
  bool _activo = true;

  bool get _esEdicion => widget.usuario != null;

  @override
  void initState() {
    super.initState();
    final usuario = widget.usuario;
    _nombreCtrl = TextEditingController(text: usuario?.firstName ?? '');
    _apellidoCtrl = TextEditingController(text: usuario?.lastName ?? '');
    _usuarioCtrl = TextEditingController(text: usuario?.userName ?? '');
    _correoCtrl = TextEditingController(text: usuario?.email ?? '');
    _cedulaCtrl = TextEditingController(text: usuario?.idNumber ?? '');
    _passwordCtrl = TextEditingController();
    _rol = usuario?.roles.isNotEmpty == true ? usuario!.roles.first : null;
    _activo = usuario?.isActive ?? true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<RolesProvider>().loadRoles();
      context.read<UserFormProvider>().reset();
    });
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _apellidoCtrl.dispose();
    _usuarioCtrl.dispose();
    _correoCtrl.dispose();
    _cedulaCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    final formProvider = context.read<UserFormProvider>();
    bool saved;

    if (_esEdicion) {
      final usuario = UserModel.fromUpdateJson(
        id: widget.usuario!.id,
        userName: _usuarioCtrl.text.trim(),
        email: _correoCtrl.text.trim(),
        idNumber: _cedulaCtrl.text.trim(),
        firstName: _nombreCtrl.text.trim(),
        lastName: _apellidoCtrl.text.trim(),
        roleName: _rol ?? '',
        isActive: _activo,
      );
      saved = await formProvider.updateUser(widget.usuario!.id, usuario);
    } else {
      final usuario = UserModel.fromCreateJson(
        userName: _usuarioCtrl.text.trim(),
        email: _correoCtrl.text.trim(),
        idNumber: _cedulaCtrl.text.trim(),
        firstName: _nombreCtrl.text.trim(),
        lastName: _apellidoCtrl.text.trim(),
        password: _passwordCtrl.text,
        roleName: _rol ?? '',
      );
      saved = await formProvider.createUser(usuario);
    }

    if (!mounted) return;
    if (saved) {
      await context.read<UserProvider>().getAll();
      if (mounted) Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              formProvider.errorMessage ?? 'No se pudo guardar el usuario.',
            ),
          ),
        );
    }
  }

  List<String> _roleNames(List<RolesModel> roles) {
    return roles.map((role) => role.roleName).toList();
  }

  @override
  Widget build(BuildContext context) {
    final formStatus = context.watch<UserFormProvider>().status;
    final rolesProvider = context.watch<RolesProvider>();
    final roles = _roleNames(rolesProvider.roles);
    final isSaving = formStatus == ViewStatus.loading;
    if (rolesProvider.status == ViewStatus.success) {
      if (_rol != null && !roles.contains(_rol)) _rol = null;
      if (_rol == null && !_esEdicion && roles.isNotEmpty) _rol = roles.first;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
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
          _esEdicion ? 'Editar Usuario' : 'Nuevo Usuario',
          style: const TextStyle(
            color: AppColors.ink,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
                  UserFormField(
                    label: 'Nombre *',
                    hintText: 'Nombre',
                    controller: _nombreCtrl,
                  ),
                  const SizedBox(height: 16),
                  UserFormField(
                    label: 'Apellido *',
                    hintText: 'Apellido',
                    controller: _apellidoCtrl,
                  ),
                  const SizedBox(height: 16),
                  UserFormField(
                    label: 'Usuario *',
                    hintText: 'usuario',
                    controller: _usuarioCtrl,
                  ),
                  const SizedBox(height: 16),
                  UserFormField(
                    label: 'Correo electrónico *',
                    hintText: 'correo@ejemplo.com',
                    controller: _correoCtrl,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  UserFormField(
                    label: 'Cédula *',
                    hintText: '041221006100F',
                    controller: _cedulaCtrl,
                  ),
                  if (!_esEdicion) ...[
                    const SizedBox(height: 16),
                    UserFormField(
                      label: 'Contraseña *',
                      hintText: 'Contraseña',
                      controller: _passwordCtrl,
                      obscureText: true,
                    ),
                  ],
                  const SizedBox(height: 16),
                  if (rolesProvider.status == ViewStatus.loading ||
                      rolesProvider.status == ViewStatus.initial)
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(),
                    )
                  else if (rolesProvider.status == ViewStatus.error)
                    TextButton(
                      onPressed: rolesProvider.loadRoles,
                      child: Text(
                        rolesProvider.errorMessage ??
                            'No se pudieron cargar los roles. Toca para reintentar.',
                      ),
                    )
                    else if (roles.isEmpty)
                      const Text('No hay roles disponibles.')
                  else
                    UserFormDropdown(
                      label: 'Rol *',
                      value: _rol,
                      items: roles,
                      onChanged: (val) => setState(() => _rol = val),
                    ),
                  if (_esEdicion) ...[
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Usuario activo',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.ink,
                          ),
                        ),
                        Switch.adaptive(
                          value: _activo,
                          onChanged: (val) => setState(() => _activo = val),
                          activeThumbColor: AppColors.textOnPrimary,
                          activeTrackColor: AppColors.primary,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isSaving || roles.isEmpty ? null : _guardar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.textOnPrimary,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check,
                            color: AppColors.textOnPrimary,
                            size: 22,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Guardar usuario',
                            style: TextStyle(
                              color: AppColors.textOnPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
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
