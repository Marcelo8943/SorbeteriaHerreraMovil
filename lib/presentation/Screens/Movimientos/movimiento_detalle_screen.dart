import 'package:flutter/material.dart';
import 'package:herrera_system/data/models/inventory_movement_header_model.dart';
import 'package:herrera_system/presentation/providers/inventory_movements_provider.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import 'widgets/movimiento_detalle_widgets.dart';

class MovimientoDetalleScreen extends StatefulWidget {
  const MovimientoDetalleScreen({super.key, required this.movementId});

  final int movementId;

  @override
  State<MovimientoDetalleScreen> createState() =>
      _MovimientoDetalleScreenState();
}

class _MovimientoDetalleScreenState extends State<MovimientoDetalleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<InventoryMovementsProvider>().loadMovementDetail(
          widget.movementId,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final movements = context.watch<InventoryMovementsProvider>();
    final header = movements.movementDetail;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: AppColors.ink,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Detalle del movimiento'),
      ),
      body: SafeArea(top: false, child: _buildBody(movements, header)),
    );
  }

  Widget _buildBody(
    InventoryMovementsProvider movements,
    InventoryMovementHeaderModel? header,
  ) {
    if (movements.isDetailLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (movements.detailErrorMessage != null) {
      return MovimientoDetalleError(
        message: movements.detailErrorMessage!,
        onRetry: () => movements.loadMovementDetail(widget.movementId),
      );
    }

    if (header == null) {
      return const MovimientoDetalleEmpty(
        message: 'No se encontró el movimiento solicitado.',
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xl,
      ),
      children: [
        MovimientoHeaderCard(header: header),
        const SizedBox(height: AppSpacing.lg),
        const Text(
          'Detalle de líneas',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (movements.movementDetailItems.isEmpty)
          const MovimientoDetalleEmpty(
            message: 'Este movimiento no tiene líneas registradas.',
          )
        else
          ...movements.movementDetailItems.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: MovimientoDetailItemCard(item: item),
            ),
          ),
      ],
    );
  }
}
