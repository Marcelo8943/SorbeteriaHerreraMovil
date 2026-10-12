import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../theme/app_theme.dart';
import 'widgets/usuario_form_widgets.dart';

class UsuarioFormScreen extends StatefulWidget {
  final Usuario? usuario;

  const UsuarioFormScreen({super.key, this.usuario});

  @override
  State<UsuarioFormScreen> createState() => _UsuarioFormScreenState();
}

class _UsuarioFormScreenState extends State<UsuarioFormScreen> {
  late TextEditingController _nombreCtrl;
  late TextEditingController _usuarioCtrl;
  late TextEditingController _correoCtrl;
  String? _rol;
  bool _activo = true;

  bool get _esEdicion => widget.usuario != null;

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.usuario?.nombre ?? '');
    _usuarioCtrl = TextEditingController(
      text: widget.usuario != null ? '@${widget.usuario!.usuario}' : '',
    );
    _correoCtrl = TextEditingController(text: widget.usuario?.correo ?? '');
    _rol = widget.usuario?.rol ?? 'Gerente';
    _activo = widget.usuario?.estado != 'Inactivo';
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _usuarioCtrl.dispose();
    _correoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    label: 'Nombre completo *',
                    hintText: 'Ej. Nohelia Cortes',
                    controller: _nombreCtrl,
                  ),
                  const SizedBox(height: 16),
                  UserFormField(
                    label: 'Usuario *',
                    hintText: '@usuario',
                    controller: _usuarioCtrl,
                  ),
                  const SizedBox(height: 16),
                  UserFormField(
                    label: 'Correo electrónico *',
                    hintText: 'correo@herrera.com',
                    controller: _correoCtrl,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  UserFormDropdown(
                    label: 'Rol',
                    value: _rol,
                    items: const ['Administrador', 'Gerente'],
                    onChanged: (val) => setState(() => _rol = val),
                  ),
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
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check, color: AppColors.textOnPrimary, size: 22),
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
