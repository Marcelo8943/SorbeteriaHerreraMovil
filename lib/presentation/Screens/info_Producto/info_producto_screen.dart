import 'package:flutter/material.dart';

import '../../models/app_models.dart';
import '../../models/mocks/mock_catalogo.dart';
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
  late final List<Linea> _lineas;
  late final List<Presentacion> _presentaciones;

  @override
  void initState() {
    super.initState();
    _lineas = List<Linea>.of(mockLineas);
    _presentaciones = List<Presentacion>.of(mockPresentaciones);
  }

  int get _total => _lineas.length + _presentaciones.length;

  int get _activos =>
      _lineas.where((item) => item.estado == 'Activo').length +
      _presentaciones.where((item) => item.estado == 'Activo').length;

  void _mostrarDetalle({
    required int id,
    required String nombre,
    required String estado,
    required bool esLinea,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => SafeArea(
        child: InfoProductoDetalleScreen(
          nombre: nombre,
          estado: estado,
          esLinea: esLinea,
          onGuardar: (nombre, estado) {
            _guardarElemento(
              id: id,
              nombre: nombre,
              estado: estado,
              esLinea: esLinea,
            );
            Navigator.of(modalContext).pop();
          },
        ),
      ),
    );
  }

  void _guardarElemento({
    required int id,
    required String nombre,
    required String estado,
    required bool esLinea,
  }) {
    setState(() {
      if (esLinea) {
        final index = _lineas.indexWhere((item) => item.id == id);
        if (index != -1) {
          _lineas[index] = Linea(id: id, nombre: nombre, estado: estado);
        }
      } else {
        final index = _presentaciones.indexWhere((item) => item.id == id);
        if (index != -1) {
          _presentaciones[index] = Presentacion(
            id: id,
            nombre: nombre,
            estado: estado,
          );
        }
      }
    });
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
          onCrear: (nombre) {
            _crearElemento(nombre, esLinea);
            Navigator.of(modalContext).pop();
          },
        ),
      ),
    );
  }

  void _crearElemento(String nombre, bool esLinea) {
    setState(() {
      if (esLinea) {
        final siguienteId =
            _lineas.fold<int>(0, (maxId, item) => item.id > maxId ? item.id : maxId) +
            1;
        _lineas.add(Linea(id: siguienteId, nombre: nombre));
      } else {
        final siguienteId = _presentaciones
                .fold<int>(0, (maxId, item) => item.id > maxId ? item.id : maxId) +
            1;
        _presentaciones.add(
          Presentacion(id: siguienteId, nombre: nombre),
        );
      }
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
            if (_mostrarLineas)
              for (final item in _lineas)
                InfoProductoItemCard(
                  nombre: item.nombre,
                  estado: item.estado,
                  esLinea: true,
                  onTap: () => _mostrarDetalle(
                    id: item.id,
                    nombre: item.nombre,
                    estado: item.estado,
                    esLinea: true,
                  ),
                )
            else
              for (final item in _presentaciones)
                InfoProductoItemCard(
                  nombre: item.nombre,
                  estado: item.estado,
                  esLinea: false,
                  onTap: () => _mostrarDetalle(
                    id: item.id,
                    nombre: item.nombre,
                    estado: item.estado,
                    esLinea: false,
                  ),
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
