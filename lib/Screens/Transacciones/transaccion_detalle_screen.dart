import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../theme/app_theme.dart';
import 'widgets/transaccion_detalle_hero.dart';
import 'widgets/transaccion_detalle_card_data.dart';

class TransaccionDetalleScreen extends StatelessWidget {
  final Transaccion? transaccion;

  const TransaccionDetalleScreen({super.key, this.transaccion});

  @override
  Widget build(BuildContext context) {
    final Transaccion t =
        transaccion ??
        (ModalRoute.of(context)?.settings.arguments as Transaccion);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
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
          'Detalle de la Transacción',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TransaccionDetalleHero(transaccion: t),

            Transform.translate(
              offset: const Offset(0, -16),
              child: TransaccionDetalleCardData(transaccion: t),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
