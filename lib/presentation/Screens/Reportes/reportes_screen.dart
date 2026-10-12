import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../models/dashboard_metrics.dart';
import '../../models/mocks/mock_productos.dart';
import '../../models/mocks/mock_transacciones.dart';
import '../../theme/app_theme.dart';
import '../../widgets/charts/average_ticket_chart.dart';
import '../../widgets/charts/inventory_rotation_chart.dart';
import '../../widgets/charts/sales_by_period_chart.dart';
import '../../widgets/charts/top_products_chart.dart';
import 'widgets/reportes_filtros_bar.dart';

class ReportesScreen extends StatefulWidget {
  const ReportesScreen({super.key});

  @override
  State<ReportesScreen> createState() => _ReportesScreenState();
}

class _ReportesScreenState extends State<ReportesScreen> {
  String _filtroProducto = 'Todos';
  String _filtroLinea = 'Todas';
  String _filtroTipoVenta = 'Todos';
  String _filtroFechaRango = 'Todos';
  DateTime? _fechaDesde;
  DateTime? _fechaHasta;

  DateTime? _parseFecha(String fechaStr) {
    try {
      final datePart = fechaStr.split(',').first.trim();
      final parts = datePart.split('/');
      if (parts.length == 3) {
        final d = int.parse(parts[0]);
        final m = int.parse(parts[1]);
        var y = int.parse(parts[2]);
        if (y < 100) y += 2000;
        return DateTime(y, m, d);
      }
    } catch (_) {}
    return null;
  }

  bool _coincideProducto(String nombreItem, String nombreFiltro) {
    if (nombreFiltro == 'Todos') return true;
    final itemLower = nombreItem.toLowerCase();
    final filtroLower = nombreFiltro.toLowerCase();
    if (itemLower == filtroLower) return true;

    // Comparación flexible quitando conectores y unidades
    final cleanItem = itemLower
        .replaceAll('de ', '')
        .replaceAll('oz', '')
        .replaceAll(' ', '');
    final cleanFiltro = filtroLower
        .replaceAll('de ', '')
        .replaceAll('oz', '')
        .replaceAll(' ', '');
    if (cleanItem.contains(cleanFiltro) || cleanFiltro.contains(cleanItem)) {
      return true;
    }

    // Comprobar por tokens significativos (fresa, coco, etc.)
    final tokens = filtroLower
        .split(RegExp(r'[\s,]+'))
        .where((w) => w.length > 3 && w != 'sorbete' && w != 'tradicional')
        .toList();
    if (tokens.isNotEmpty) {
      return tokens.every((token) => itemLower.contains(token));
    }
    return false;
  }

  bool _productoPerteneceALinea(String nombreProducto, String lineaFiltro) {
    if (lineaFiltro == 'Todas') return true;
    final nombreLower = nombreProducto.toLowerCase();
    final filtroLower = lineaFiltro.toLowerCase();

    if (filtroLower == 'tradicional' &&
        (nombreLower.contains('tradicional') ||
            nombreLower.startsWith('sorbete tradicional'))) {
      return true;
    }
    if ((filtroLower == 'nieves' || filtroLower == 'nieve') &&
        nombreLower.contains('nieve')) {
      return true;
    }
    if (filtroLower == 'paleta' && nombreLower.contains('paleta')) {
      return true;
    }
    if ((filtroLower == 'fantacia' || filtroLower == 'fantasía') &&
        (nombreLower.contains('borrachito') ||
            nombreLower.contains('fantasia') ||
            nombreLower.contains('fantasía'))) {
      return true;
    }
    if (filtroLower == 'lights' &&
        (nombreLower.contains('light') || nombreLower.contains('lights'))) {
      return true;
    }

    final p = mockProductos.firstWhere(
      (prod) => prod.nombre.toLowerCase() == nombreLower,
      orElse: () => const Producto(
        id: -1,
        nombre: '',
        linea: '',
        sabor: '',
        presentacion: '',
        precioDetalle: 0,
        precioMayoreo: 0,
        estado: '',
        imgUrl: '',
        stockMinimo: 0,
        stockActual: 0,
      ),
    );
    if (p.id != -1 && p.linea.isNotEmpty) {
      return p.linea.toLowerCase() == filtroLower;
    }
    return false;
  }

  bool _evaluarFecha(Transaccion t) {
    if (_filtroFechaRango == 'Este mes') {
      if (!t.fecha.contains('/08/26') && !t.fecha.contains('/08/2026')) {
        return false;
      }
    } else if (_filtroFechaRango == 'Este año') {
      if (!t.fecha.contains('/26') && !t.fecha.contains('/2026')) {
        return false;
      }
    }

    if (_fechaDesde != null || _fechaHasta != null) {
      final f = _parseFecha(t.fecha);
      if (f != null) {
        if (_fechaDesde != null &&
            f.isBefore(DateTime(
              _fechaDesde!.year,
              _fechaDesde!.month,
              _fechaDesde!.day,
            ))) {
          return false;
        }
        if (_fechaHasta != null &&
            f.isAfter(DateTime(
              _fechaHasta!.year,
              _fechaHasta!.month,
              _fechaHasta!.day,
              23,
              59,
              59,
            ))) {
          return false;
        }
      }
    }

    return true;
  }

  List<Transaccion> get _transaccionesFiltradas {
    return mockTransacciones.where((t) {
      // 1. Tipo de venta
      if (_filtroTipoVenta != 'Todos') {
        if (t.tipoVenta == null || t.tipoVenta != _filtroTipoVenta) {
          return false;
        }
      }

      // 2. Rango de fecha
      if (!_evaluarFecha(t)) {
        return false;
      }

      // 3. Producto
      if (_filtroProducto != 'Todos') {
        final matches = t.items.any(
          (item) => _coincideProducto(item.producto, _filtroProducto),
        );
        if (!matches) return false;
      }

      // 4. Línea
      if (_filtroLinea != 'Todas') {
        final matches = t.items.any(
          (item) => _productoPerteneceALinea(item.producto, _filtroLinea),
        );
        if (!matches) return false;
      }

      return true;
    }).map((t) {
      if (_filtroProducto == 'Todos' && _filtroLinea == 'Todas') {
        return t;
      }
      final itemsFiltrados = t.items.where((item) {
        if (_filtroProducto != 'Todos' &&
            !_coincideProducto(item.producto, _filtroProducto)) {
          return false;
        }
        if (_filtroLinea != 'Todas' &&
            !_productoPerteneceALinea(item.producto, _filtroLinea)) {
          return false;
        }
        return true;
      }).toList();

      return Transaccion(
        id: t.id,
        folio: t.folio,
        tipo: t.tipo,
        relacionado: t.relacionado,
        detalle: t.detalle,
        tipoVenta: t.tipoVenta,
        fecha: t.fecha,
        fechaRelativa: t.fechaRelativa,
        realizadoPor: t.realizadoPor,
        rol: t.rol,
        estado: t.estado,
        items: itemsFiltrados,
      );
    }).where((t) => t.items.isNotEmpty).toList();
  }

  List<Producto> get _productosFiltrados {
    final filtrados = mockProductos.where((p) {
      if (_filtroProducto != 'Todos' &&
          !_coincideProducto(p.nombre, _filtroProducto)) {
        return false;
      }
      if (_filtroLinea != 'Todas' &&
          !_productoPerteneceALinea(p.nombre, _filtroLinea)) {
        return false;
      }
      return true;
    }).toList();

    if (filtrados.isEmpty && _filtroProducto == 'Todos') {
      return mockProductos;
    }
    return filtrados;
  }

  void _aplicarFiltros({
    required String producto,
    required String linea,
    required String tipoVenta,
    required String fechaRango,
    DateTime? fechaDesde,
    DateTime? fechaHasta,
  }) {
    setState(() {
      _filtroProducto = producto;
      _filtroLinea = linea;
      _filtroTipoVenta = tipoVenta;
      _filtroFechaRango = fechaRango;
      _fechaDesde = fechaDesde;
      _fechaHasta = fechaHasta;
    });
  }

  void _removerFiltro(String tipoFiltro) {
    setState(() {
      switch (tipoFiltro) {
        case 'fecha':
          _filtroFechaRango = 'Todos';
          _fechaDesde = null;
          _fechaHasta = null;
          break;
        case 'producto':
          _filtroProducto = 'Todos';
          break;
        case 'linea':
          _filtroLinea = 'Todas';
          break;
        case 'tipoVenta':
          _filtroTipoVenta = 'Todos';
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final transacciones = _transaccionesFiltradas;
    final productos = _productosFiltrados;

    final datosVentas = ventasPorPeriodo(
      transacciones,
      agruparPor: (t) => t.fecha.split(',').first,
    );

    final datosTopProductos = topProductos(transacciones);

    final datosTicket = ticketPromedioPorPeriodo(
      transacciones,
      agruparPor: (t) => t.fecha.split(',').first,
    );

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
          'Reportes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReportesFiltrosBar(
              filtroProducto: _filtroProducto,
              filtroLinea: _filtroLinea,
              filtroTipoVenta: _filtroTipoVenta,
              filtroFechaRango: _filtroFechaRango,
              fechaDesde: _fechaDesde,
              fechaHasta: _fechaHasta,
              onFiltrosAplicados: _aplicarFiltros,
              onRemoverFiltro: _removerFiltro,
            ),
            SalesByPeriodChart(
              datos: datosVentas,
            ),
            TopProductsChart(
              datos: datosTopProductos,
            ),
            InventoryRotationChart(
              productos: productos,
              transacciones: transacciones,
            ),
            AverageTicketChart(
              datos: datosTicket,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
