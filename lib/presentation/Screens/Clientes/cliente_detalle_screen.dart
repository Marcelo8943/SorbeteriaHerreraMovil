import 'package:flutter/material.dart';
import 'package:herrera_system/data/models/cliente_model.dart';
import 'package:herrera_system/services/cliente_service.dart';

import '../../../session.dart';
import '../../theme/app_theme.dart';
import 'cliente_form_screen.dart';
import 'widgets/cliente_detalle_widgets.dart';

class ClienteDetalleScreen extends StatefulWidget {
  final ClienteModel cliente;
  final Color avatarColor;
  final ClienteService service;

  const ClienteDetalleScreen({
    super.key,
    required this.cliente,
    required this.avatarColor,
    required this.service,
  });

  @override
  State<ClienteDetalleScreen> createState() => _ClienteDetalleScreenState();
}

class _ClienteDetalleScreenState extends State<ClienteDetalleScreen> {
  late ClienteModel _cliente = widget.cliente;
  bool _cargando = true;
  bool _eliminando = false;
  bool _fueModificado = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarDetalle();
  }

  Future<void> _cargarDetalle() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final cliente = await widget.service.obtenerCliente(widget.cliente.id);
      if (!mounted) return;
      setState(() {
        _cliente = cliente;
        _cargando = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _cargando = false;
        _error = 'No se pudo actualizar el detalle del cliente.';
      });
    }
  }

  Future<void> _openEditForm() async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (_) => ClienteFormScreen(
          service: widget.service,
          cliente: _cliente,
        ),
      ),
    );
    if (saved == true && mounted) {
      _fueModificado = true;
      await _cargarDetalle();
    }
  }

  Future<void> _deleteCliente() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar cliente'),
        content: Text('¿Desea eliminar a ${_cliente.nombreCompleto}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _eliminando = true);
    try {
      await widget.service.eliminarCliente(_cliente.id);
      if (mounted) Navigator.pop(context, true);
    } catch (exception) {
      if (!mounted) return;
      setState(() => _eliminando = false);
      final message = exception.toString().replaceFirst(
        RegExp(r'^[^:]+: '),
        '',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo eliminar el cliente. $message')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.lavender,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context, _fueModificado),
        ),
        title: const Text('Detalle del Cliente'),
        actions: [
          if (Session.esAdmin)
            IconButton(
              tooltip: 'Eliminar cliente',
              onPressed: _eliminando ? null : _deleteCliente,
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _cargarDetalle,
              child: ListView(
                children: [
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextButton.icon(
                        onPressed: _cargarDetalle,
                        icon: const Icon(Icons.refresh),
                        label: Text(_error!),
                      ),
                    ),
                  ClienteDetalleHero(
                    cliente: _cliente,
                    avatarColor: widget.avatarColor,
                  ),
                  Transform.translate(
                    offset: const Offset(0, -24),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      child: ClienteDetalleCardData(cliente: _cliente),
                    ),
                  ),
                  if (Session.esAdmin)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md,
                        0,
                        AppSpacing.md,
                        AppSpacing.lg,
                      ),
                      child: ClienteDetalleEditButton(
                        onPressed: _openEditForm,
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
