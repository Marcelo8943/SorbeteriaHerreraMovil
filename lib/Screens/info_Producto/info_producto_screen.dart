import 'package:flutter/material.dart';

import '../../models/mocks/mock_info_producto.dart';
import '../../theme/app_theme.dart';
import '../../widgets/h_stat_card.dart';
import 'info_producto_detalle_screen.dart';
import 'info_producto_form_screen.dart';
import 'widgets/info_producto_widgets.dart';

class InfoProductoScreen extends StatefulWidget {
  const InfoProductoScreen({super.key});

  @override
  State<InfoProductoScreen> createState() => _InfoProductoScreenState();
}

class _InfoProductoScreenState extends State<InfoProductoScreen> {
  bool _mostrarLineas = true;

  List<InfoProductoMockItem> get _items =>
      _mostrarLineas ? mockInfoLineas : mockInfoPresentaciones;

  int get _total => mockInfoLineas.length + mockInfoPresentaciones.length;

  int get _activos => [
        ...mockInfoLineas,
        ...mockInfoPresentaciones,
      ].where((item) => item.estado == 'Activo').length;

  void _mostrarDetalle(InfoProductoMockItem item) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        child: InfoProductoDetalleScreen(item: item, esLinea: _mostrarLineas),
      ),
    );
  }

  void _mostrarFormulario() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        child: InfoProductoFormScreen(esLinea: _mostrarLineas),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.lavender,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Info del Producto'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: ElevatedButton(
              onPressed: _mostrarFormulario,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12),
              ),
              child: const Icon(Icons.add, color: AppColors.textOnPrimary),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.xl,
          ),
          children: [
            const Text(
              'Líneas y presentaciones del sistema.',
              style: TextStyle(color: AppColors.muted, fontSize: 14),
            ),
            const SizedBox(height: AppSpacing.md),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  HStatCard(
                    title: 'Total',
                    value: '$_total',
                    bgColor: AppToneColors.soft[AppTone.teal]!,
                    iconColor: AppToneColors.intense[AppTone.teal]!,
                    icon: Icons.sell_outlined,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  HStatCard(
                    title: 'Activos',
                    value: '$_activos',
                    bgColor: AppToneColors.soft[AppTone.purple]!,
                    iconColor: AppToneColors.intense[AppTone.purple]!,
                    icon: Icons.check,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  HStatCard(
                    title: 'Inactivos',
                    value: '${_total - _activos}',
                    bgColor: AppToneColors.soft[AppTone.red]!,
                    iconColor: AppToneColors.intense[AppTone.red]!,
                    icon: Icons.close,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            InfoProductoSeccionSelector(
              lineasSeleccionadas: _mostrarLineas,
              onChanged: (mostrarLineas) =>
                  setState(() => _mostrarLineas = mostrarLineas),
            ),
            const SizedBox(height: AppSpacing.md),
            for (final item in _items)
              InfoProductoItemCard(
                item: item,
                esLinea: _mostrarLineas,
                onTap: () => _mostrarDetalle(item),
              ),
            const SizedBox(height: AppSpacing.sm),
            const Center(
              child: Text(
                'Página 1 de 1',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
