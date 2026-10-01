import 'package:flutter/material.dart';

import '../../models/app_models.dart';
import '../../models/mocks/mock_precios.dart';
import '../../theme/app_theme.dart';
import 'precio_form_screen.dart';
import 'widgets/precios_widgets.dart';

class PreciosScreen extends StatefulWidget {
  const PreciosScreen({super.key});

  @override
  State<PreciosScreen> createState() => _PreciosScreenState();
}

class _PreciosScreenState extends State<PreciosScreen> {
  String _lineaSeleccionada = 'Todas';
  late final List<PrecioGeneral> _preciosGenerales;

  @override
  void initState() {
    super.initState();
    _preciosGenerales = List<PrecioGeneral>.of(mockPreciosGenerales);
  }

  List<PrecioGeneral> get _preciosVisibles => _lineaSeleccionada == 'Todas'
      ? _preciosGenerales
      : _preciosGenerales
          .where((precio) => precio.linea == _lineaSeleccionada)
          .toList();

  int get _productosConPrecio => _preciosGenerales.fold(
        0,
        (total, precio) => total + precio.cantidadProductos,
      );

  Future<void> _abrirFormularioPrecio(
    BuildContext context,
    PrecioGeneral precio,
  ) async {
    final resultado = await showModalBottomSheet<PrecioGeneral>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PrecioFormScreen(precio: precio),
    );
    if (resultado == null || !mounted) return;

    setState(() {
      final index = _preciosGenerales.indexWhere(
        (item) => item.id == resultado.id,
      );
      if (index != -1) _preciosGenerales[index] = resultado;
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: PrecioResumenCard(
                      titulo: 'Con precio',
                      valor: '$_productosConPrecio',
                      icono: Icons.sell_outlined,
                      tono: AppTone.teal,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: PrecioResumenCard(
                      titulo: 'Especiales',
                      valor: '${mockPreciosEspeciales.length}',
                      icono: Icons.star_border,
                      tono: AppTone.yellow,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Última actualización: $mockPreciosUltimaActualizacion',
                style: TextStyle(color: AppColors.muted, fontSize: 12),
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
                seleccionada: _lineaSeleccionada,
                onSeleccionar: (linea) {
                  setState(() => _lineaSeleccionada = linea);
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final precio in _preciosVisibles) ...[
                PrecioGeneralCard(
                  precio: precio,
                  nombreLinea: precio.linea,
                  onTap: () => _abrirFormularioPrecio(context, precio),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Text(
                  'Toca una presentación para ver los campos de precio de ejemplo.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Precios especiales',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              for (var index = 0; index < mockPreciosEspeciales.length; index++) ...[
                PrecioEspecialCard(precio: mockPreciosEspeciales[index]),
                if (index + 1 < mockPreciosEspeciales.length)
                  const SizedBox(height: AppSpacing.sm),
              ],
            ],
          ),
        ),
      ),
    );
  }

}
