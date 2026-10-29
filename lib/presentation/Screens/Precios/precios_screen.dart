import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/di/injection.dart';
import '../../../data/models/precio_general_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/precio_provider.dart';
import '../../theme/app_theme.dart';
import 'precio_form_screen.dart';
import 'widgets/precios_widgets.dart';

class PreciosScreen extends StatelessWidget {
  const PreciosScreen({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (_) => getIt<PrecioProvider>(),
    child: const _PreciosContent(),
  );
}

class _PreciosContent extends StatefulWidget {
  const _PreciosContent();

  @override
  State<_PreciosContent> createState() => _PreciosContentState();
}

class _PreciosContentState extends State<_PreciosContent> {
  Future<void> _editarPrecio(
    BuildContext context,
    PrecioProvider provider,
    PrecioGeneralModel precio,
  ) async {
    final valores = await showModalBottomSheet<(double, double)>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PrecioFormScreen(precio: precio),
    );
    if (valores == null) return;

    await provider.actualizarPrecios(
      precio: precio,
      retailPrice: valores.$1,
      wholesalePrice: valores.$2,
    );
    if (!mounted) return;

    final error = provider.error;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error ?? 'Precios actualizados correctamente.'),
        backgroundColor: error == null ? AppColors.primary : AppColors.error,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<PrecioProvider>().cargar();
    });
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
        title: const Text('Precios'),
      ),
      body: SafeArea(
        top: false,
        child: Consumer2<AuthProvider, PrecioProvider>(
          builder: (context, authProvider, provider, _) => RefreshIndicator(
            onRefresh: provider.cargar,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.xl,
              ),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: PrecioResumenCard(
                        titulo: 'Combinaciones con precio',
                        valor: '${provider.combinacionesConPrecio}',
                        icono: Icons.sell_outlined,
                        tono: AppTone.teal,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: PrecioResumenCard(
                        titulo: 'Pendientes',
                        valor: '${provider.combinacionesPendientes}',
                        icono: Icons.price_change_outlined,
                        tono: AppTone.yellow,
                      ),
                    ),
                  ],
                ),
                if (provider.guardando)
                  const Padding(
                    padding: EdgeInsets.only(top: AppSpacing.sm),
                    child: LinearProgressIndicator(),
                  ),
                const SizedBox(height: AppSpacing.lg),
                const Text(
                  'Precios generales por línea',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                PreciosLineaSelector(
                  seleccionada: provider.lineaSeleccionada,
                  opciones: provider.lineas,
                  onSeleccionar: provider.seleccionarLinea,
                ),
                const SizedBox(height: AppSpacing.sm),
                if (provider.cargando && provider.precios.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (provider.error != null && provider.precios.isEmpty)
                  _EstadoPrecios(
                    mensaje: provider.error!,
                    onReintentar: provider.cargar,
                  )
                else if (provider.preciosVisibles.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                    child: Center(
                      child: Text(
                        'No hay precios generales para mostrar.',
                        style: TextStyle(color: AppColors.muted),
                      ),
                    ),
                  )
                else
                  for (final precio in provider.preciosVisibles) ...[
                    PrecioGeneralCard(
                      precio: precio,
                      nombreLinea: precio.lineName,
                      onTap: authProvider.isAuthenticated && !provider.guardando
                          ? () => _editarPrecio(context, provider, precio)
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                if (provider.error != null && provider.precios.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: Text(
                      'No se pudieron actualizar los precios: ${provider.error}',
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EstadoPrecios extends StatelessWidget {
  final String mensaje;
  final VoidCallback onReintentar;

  const _EstadoPrecios({required this.mensaje, required this.onReintentar});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
    child: Column(
      children: [
        const Icon(Icons.cloud_off_outlined, color: AppColors.error, size: 36),
        const SizedBox(height: AppSpacing.sm),
        Text(mensaje, textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(
          onPressed: onReintentar,
          icon: const Icon(Icons.refresh),
          label: const Text('Reintentar'),
        ),
      ],
    ),
  );
}
