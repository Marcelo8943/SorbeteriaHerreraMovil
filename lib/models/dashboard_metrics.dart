import '../models/app_models.dart';

/// Un punto de la gráfica de ventas por período (ej. un día, una semana).
class PuntoVenta {
  final String etiqueta; // ej. "16 Ago", "Semana 33"
  final double monto;

  const PuntoVenta({required this.etiqueta, required this.monto});
}

/// Un producto y cuánto se vendió de él, para el top de más vendidos.
class ProductoVendido {
  final String nombre;
  final int cantidad;

  const ProductoVendido({required this.nombre, required this.cantidad});
}

List<PuntoVenta> ventasPorPeriodo(
  List<Transaccion> transacciones, {
  required String Function(Transaccion t) agruparPor,
}) {
  final Map<String, double> totales = {};

  for (final t in transacciones) {
    if (t.tipo != 'Venta') continue;
    final clave = agruparPor(t);
    totales[clave] = (totales[clave] ?? 0) + t.monto;
  }

  return totales.entries
      .map((e) => PuntoVenta(etiqueta: e.key, monto: e.value))
      .toList();
}

List<PuntoVenta> ticketPromedioPorPeriodo(
  List<Transaccion> transacciones, {
  required String Function(Transaccion t) agruparPor,
}) {
  final Map<String, double> totales = {};
  final Map<String, int> conteos = {};

  for (final t in transacciones) {
    if (t.tipo != 'Venta') continue;
    final clave = agruparPor(t);
    totales[clave] = (totales[clave] ?? 0) + t.monto;
    conteos[clave] = (conteos[clave] ?? 0) + 1;
  }

  return totales.entries.map((e) {
    final count = conteos[e.key] ?? 1;
    final promedio = count > 0 ? e.value / count : 0.0;
    return PuntoVenta(etiqueta: e.key, monto: promedio);
  }).toList();
}

List<ProductoVendido> topProductos(
  List<Transaccion> transacciones, {
  int limite = 5,
}) {
  final Map<String, int> cantidades = {};

  for (final t in transacciones) {
    if (t.tipo != 'Venta') continue;
    for (final item in t.items) {
      cantidades[item.producto] =
          (cantidades[item.producto] ?? 0) + item.cantidad;
    }
  }

  final lista =
      cantidades.entries
          .map((e) => ProductoVendido(nombre: e.key, cantidad: e.value))
          .toList()
        ..sort((a, b) => b.cantidad.compareTo(a.cantidad));

  return lista.take(limite).toList();
}

double rotacionInventario(
  List<Transaccion> transacciones,
  List<Producto> productos,
) {
  return 0;
}

double ticketPromedio(List<Transaccion> transacciones) {
  final ventas = transacciones.where((t) => t.tipo == 'Venta').toList();
  if (ventas.isEmpty) return 0;

  final totalVendido = ventas.fold<double>(0, (sum, t) => sum + t.monto);
  return totalVendido / ventas.length;
}
