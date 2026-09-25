import 'package:flutter/material.dart';

import '../../models/app_models.dart';
import '../../models/mocks/mock_precios.dart';
import '../../theme/app_theme.dart';
import 'precio_form_screen.dart';
import 'widgets/precios_widgets.dart';

class PreciosScreen extends StatefulWidget {
  final bool esAdministrador;

  const PreciosScreen({super.key, this.esAdministrador = true});

  @override
  State<PreciosScreen> createState() => _PreciosScreenState();
}

class _PreciosScreenState extends State<PreciosScreen> {
  late final List<PrecioGeneral> _precios;
  final List<PrecioEspecial> _preciosEspeciales = mockPreciosEspeciales;
  String _lineaSeleccionada = 'Todas';

  @override
  void initState() {
    super.initState();
    _precios = List<PrecioGeneral>.from(mockPreciosGenerales);
  }

  List<PrecioGeneral> get _preciosVisibles => _lineaSeleccionada == 'Todas'
      ? _precios
      : _precios.where((precio) => precio.linea == _lineaSeleccionada).toList();

  int get _productosConPrecio => _precios.fold(
        0,
        (total, precio) => total + precio.cantidadProductos,
      );

  Future<void> _editarPrecio(PrecioGeneral precio) async {
    if (!widget.esAdministrador) return;
    final actualizado = await showModalBottomSheet<PrecioGeneral>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PrecioFormScreen(precio: precio),
    );
    if (actualizado == null || !mounted) return;

    final indice = _precios.indexWhere((item) => item.id == actualizado.id);
    if (indice < 0) return;
    setState(() => _precios[indice] = actualizado);
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
                      valor: '${_preciosEspeciales.length}',
                      icono: Icons.star_border,
                      tono: AppTone.yellow,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Última actualización: 23/06/26, 04:56 p. m.',
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
                  nombreLinea: _nombreLinea(precio.linea),
                  onTap: widget.esAdministrador
                      ? () => _editarPrecio(precio)
                      : null,
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Text(
                  widget.esAdministrador
                      ? 'Toca una presentación para editar su precio.'
                      : 'Solo un administrador puede editar los precios.',
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
              for (var index = 0; index < _preciosEspeciales.length; index++) ...[
                PrecioEspecialCard(precio: _preciosEspeciales[index]),
                if (index + 1 < _preciosEspeciales.length)
                  const SizedBox(height: AppSpacing.sm),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _nombreLinea(String linea) {
    switch (linea) {
      case 'Tradicional':
        return 'Tradicional';
      case 'Paleta':
        return 'Paleta';
      default:
        return linea;
    }
  }
}
