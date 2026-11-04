import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../data/models/info_producto_item.dart';
import '../../../data/repository/info_producto_repository.dart';
import '../../../services/info_producto_service.dart';
import '../../providers/info_producto_provider.dart';
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
  late final ApiClient _apiClient;
  late final InfoProductoProvider _provider;

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient();
    _provider = InfoProductoProvider(
      InfoProductoService(InfoProductoRepository(_apiClient)),
    );
    _provider.cargar();
  }

  @override
  void dispose() {
    _provider.dispose();
    _apiClient.dispose();
    super.dispose();
  }

  void _mostrarDetalle(InfoProductoItem item, bool esLinea) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => SafeArea(
        child: InfoProductoDetalleScreen(
          nombre: item.nombre,
          estado: item.estado,
          esLinea: esLinea,
          onGuardar: (nombre, estado) async {
            await _provider.actualizar(
              esLinea: esLinea,
              id: item.id,
              nombre: nombre,
              activo: estado == 'Activo',
            );
            if (modalContext.mounted) Navigator.of(modalContext).pop();
          },
        ),
      ),
    );
  }

  void _mostrarFormulario() {
    final esLinea = _mostrarLineas;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => SafeArea(
        child: InfoProductoFormScreen(
          esLinea: esLinea,
          onCrear: (nombre) async {
            await _provider.crear(esLinea: esLinea, nombre: nombre);
            if (modalContext.mounted) Navigator.of(modalContext).pop();
          },
        ),
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
              onPressed: _provider.guardando ? null : _mostrarFormulario,
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
        child: AnimatedBuilder(
          animation: _provider,
          builder: (context, _) => _buildContenido(),
        ),
      ),
    );
  }

  Widget _buildContenido() {
    final lineas = _provider.lineas;
    final presentaciones = _provider.presentaciones;
    final items = _mostrarLineas ? lineas : presentaciones;
    final total = lineas.length + presentaciones.length;
    final activos =
        lineas.where((item) => item.activo).length +
        presentaciones.where((item) => item.activo).length;

    return ListView(
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
                value: '$total',
                bgColor: AppToneColors.soft[AppTone.teal]!,
                iconColor: AppToneColors.intense[AppTone.teal]!,
                icon: Icons.sell_outlined,
              ),
              const SizedBox(width: AppSpacing.sm),
              HStatCard(
                title: 'Activos',
                value: '$activos',
                bgColor: AppToneColors.soft[AppTone.purple]!,
                iconColor: AppToneColors.intense[AppTone.purple]!,
                icon: Icons.check,
              ),
              const SizedBox(width: AppSpacing.sm),
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
        if (_provider.cargando)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_provider.error != null)
          _ErrorInfoProducto(
            mensaje: _provider.error!,
            onReintentar: _provider.cargar,
          )
        else if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Center(
              child: Text(
                _mostrarLineas
                    ? 'No hay líneas registradas.'
                    : 'No hay presentaciones registradas.',
                style: const TextStyle(color: AppColors.muted),
              ),
            ),
          )
        else
          for (final item in items)
            InfoProductoItemCard(
              nombre: item.nombre,
              estado: item.estado,
              esLinea: _mostrarLineas,
              onTap: _provider.guardando
                  ? null
                  : () => _mostrarDetalle(item, _mostrarLineas),
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
    );
  }
}

class _ErrorInfoProducto extends StatelessWidget {
  final String mensaje;
  final VoidCallback onReintentar;

  const _ErrorInfoProducto({required this.mensaje, required this.onReintentar});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
    child: Column(
      children: [
        const Icon(Icons.cloud_off_outlined, color: AppColors.muted, size: 36),
        const SizedBox(height: AppSpacing.sm),
        Text(mensaje, textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.sm),
        TextButton.icon(
          onPressed: onReintentar,
          icon: const Icon(Icons.refresh),
          label: const Text('Reintentar'),
        ),
      ],
    ),
  );
}
