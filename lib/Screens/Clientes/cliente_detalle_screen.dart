import 'package:flutter/material.dart';

import '../../models/app_models.dart';
import '../../theme/app_theme.dart';
import 'cliente_form_screen.dart';
import 'widgets/cliente_detalle_widgets.dart';

class ClienteDetalleScreen extends StatelessWidget {
  final Cliente cliente;
  final Color avatarColor;

  const ClienteDetalleScreen({
    super.key,
    required this.cliente,
    required this.avatarColor,
  });

  Future<void> _openEditForm(BuildContext context) async {
    final resultado = await Navigator.push<Cliente>(
      context,
      MaterialPageRoute(builder: (_) => ClienteFormScreen(cliente: cliente)),
    );
    if (context.mounted && resultado != null) {
      Navigator.pop(context, resultado);
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Detalle del Cliente'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClienteDetalleHero(cliente: cliente, avatarColor: avatarColor),
            Transform.translate(
              offset: const Offset(0, -24),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: ClienteDetalleCardData(cliente: cliente),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.lg,
              ),
              child: ClienteDetalleEditButton(
                onPressed: () => _openEditForm(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
