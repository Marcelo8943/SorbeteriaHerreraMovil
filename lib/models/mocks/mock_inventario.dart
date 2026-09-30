import '../app_models.dart';

/// KPI de lotes próximos a vencer — dato fijo de mock, no calculado dinámicamente.
const int mockLotesPorVencer = 4;

/// Lista de snapshots de inventario por producto.
/// Usa los MISMOS nombres que existen en mock_productos.dart.
/// stockBajo se evalúa automáticamente vía el getter InventarioProducto.stockBajo.
const List<InventarioProducto> mockInventario = [
  // ── TRADICIONAL ─────────────────────────────────────────────────────────
  InventarioProducto(
    productoId: 1,
    nombreProducto: 'Sorbete Tradicional de Albaricoque 8oz',
    linea: 'Tradicional',
    presentacion: '8 Onzas',
    sabor: 'Albaricoque',
    stockBodega: 8,
    stockReservado: 4,
    stockMostrador: 5,
    stockTotal: 17,
    stockMinimo: 10, // stockBajo = false (17 > 10)
  ),
  InventarioProducto(
    productoId: 7,
    nombreProducto: 'Sorbete Tradicional de Chocolate 1/4 Galón',
    linea: 'Tradicional',
    presentacion: '1/4 Galón',
    sabor: 'Chocolate',
    stockBodega: 2,
    stockReservado: 1,
    stockMostrador: 2,
    stockTotal: 5,
    stockMinimo: 10, // stockBajo = true (5 <= 10)
  ),
  InventarioProducto(
    productoId: 14,
    nombreProducto: 'Sorbete Tradicional de Vainilla 8oz',
    linea: 'Tradicional',
    presentacion: '8 Onzas',
    sabor: 'Vainilla',
    stockBodega: 3,
    stockReservado: 1,
    stockMostrador: 2,
    stockTotal: 6,
    stockMinimo: 8, // stockBajo = true (6 <= 8)
  ),
  InventarioProducto(
    productoId: 8,
    nombreProducto: 'Sorbete Tradicional de Fresas 8oz',
    linea: 'Tradicional',
    presentacion: '8 Onzas',
    sabor: 'Fresas',
    stockBodega: 10,
    stockReservado: 3,
    stockMostrador: 4,
    stockTotal: 17,
    stockMinimo: 10, // stockBajo = false (17 > 10)
  ),

  // ── LIGHTS ───────────────────────────────────────────────────────────────
  InventarioProducto(
    productoId: 18,
    nombreProducto: 'Sorbete Light de Frutas 1/2 Galón',
    linea: 'Lights',
    presentacion: '1/2 Galón',
    sabor: 'Frutas light',
    stockBodega: 3,
    stockReservado: 2,
    stockMostrador: 2,
    stockTotal: 7,
    stockMinimo: 10, // stockBajo = true (7 <= 10)
  ),
  InventarioProducto(
    productoId: 16,
    nombreProducto: 'Sorbete Light de Albaricoque 8oz',
    linea: 'Lights',
    presentacion: '8 Onzas',
    sabor: 'Albaricoque Light',
    stockBodega: 12,
    stockReservado: 3,
    stockMostrador: 5,
    stockTotal: 20,
    stockMinimo: 12, // stockBajo = false (20 > 12)
  ),
  InventarioProducto(
    productoId: 20,
    nombreProducto: 'Sorbete Light de Albaricoque 1/4 Galón',
    linea: 'Lights',
    presentacion: '1/4 Galón',
    sabor: 'Albaricoque Light',
    stockBodega: 2,
    stockReservado: 1,
    stockMostrador: 2,
    stockTotal: 5,
    stockMinimo: 6, // stockBajo = true (5 <= 6)
  ),

  // ── FANTACÍA ─────────────────────────────────────────────────────────────
  InventarioProducto(
    productoId: 31,
    nombreProducto: 'Sorbete Borrachito 1 libra',
    linea: 'Fantacia',
    presentacion: '1 libra',
    sabor: 'Borrachito',
    stockBodega: 14,
    stockReservado: 3,
    stockMostrador: 5,
    stockTotal: 22,
    stockMinimo: 12, // stockBajo = false (22 > 12)
  ),
  InventarioProducto(
    productoId: 32,
    nombreProducto: 'Sorbete Borrachito 1/4 Galón',
    linea: 'Fantacia',
    presentacion: '1/4 Galón',
    sabor: 'Borrachito',
    stockBodega: 4,
    stockReservado: 2,
    stockMostrador: 2,
    stockTotal: 8,
    stockMinimo: 10, // stockBajo = true (8 <= 10)
  ),

  // ── NIEVES ───────────────────────────────────────────────────────────────
  InventarioProducto(
    productoId: 46,
    nombreProducto: 'Nieve de Tamarindo 8oz',
    linea: 'Nieves',
    presentacion: '8 Onzas',
    sabor: 'Tamarindo',
    stockBodega: 10,
    stockReservado: 3,
    stockMostrador: 5,
    stockTotal: 18,
    stockMinimo: 9, // stockBajo = false (18 > 9)
  ),
  InventarioProducto(
    productoId: 48,
    nombreProducto: 'Nieve de frutas 1/4 Galón',
    linea: 'Nieves',
    presentacion: '1/4 Galón',
    sabor: 'Frutas',
    stockBodega: 4,
    stockReservado: 2,
    stockMostrador: 3,
    stockTotal: 9,
    stockMinimo: 11, // stockBajo = true (9 <= 11)
  ),
  InventarioProducto(
    productoId: 50,
    nombreProducto: 'Nieve de Nancite 8oz',
    linea: 'Nieves',
    presentacion: '8 Onzas',
    sabor: 'Nancite',
    stockBodega: 3,
    stockReservado: 2,
    stockMostrador: 2,
    stockTotal: 7,
    stockMinimo: 8, // stockBajo = true (7 <= 8)
  ),
];
