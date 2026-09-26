import '../app_models.dart';

const List<Transaccion> mockTransacciones = [
  Transaccion(
    id: 1,
    folio: 'V-00128',
    tipo: 'Venta',
    relacionado: 'Roberto Argüello',
    detalle: 'Heladería & Snacks Masaya · Catarina',
    tipoVenta: 'Detalle',
    fecha: '16/08/26, 09:40 a.m.',
    fechaRelativa: 'hace 2 h',
    realizadoPor: 'William Cortez',
    rol: 'Gerente',
    estado: 'Completado',
    items: [
      ItemTransaccion(
        producto: 'Sorbete Tradicional Fresa 4 Oz',
        cantidad: 8,
        precio: 45,
      ),
      ItemTransaccion(
        producto: 'Sorbete Tradicional Coco 8 Oz',
        cantidad: 4,
        precio: 70,
      ),
    ],
  ),
  Transaccion(
    id: 2,
    folio: 'P-00064',
    tipo: 'Pedido',
    relacionado: 'Luisa Fernanda Campos',
    detalle: 'Minisuper Diriomo · entrega 18/08',
    fecha: '16/08/26, 07:15 a.m.',
    fechaRelativa: 'hace 5 h',
    realizadoPor: 'María Herrera',
    rol: 'Gerente',
    estado: 'Pendiente',
    items: [
      ItemTransaccion(
        producto: 'Sorbete Tradicional Vainilla 8 Oz',
        cantidad: 15,
        precio: 70,
      ),
      ItemTransaccion(
        producto: 'Nieve de Chocolate 1/4 Galón',
        cantidad: 10,
        precio: 110,
      ),
    ],
  ),

  Transaccion(
    id: 3,
    folio: 'V-00129',
    tipo: 'Venta',
    relacionado: 'Nohelia Cortes',
    detalle: 'Heladería & Snacks Masaya · Catarina',
    tipoVenta: 'Detalle',
    fecha: '16/08/26, 10:15 a.m.',
    fechaRelativa: 'hace 1 h',
    realizadoPor: 'William Cortez',
    rol: 'Gerente',
    estado: 'Completado',
    items: [
      ItemTransaccion(
        producto: 'Sorbete Tradicional Fresa 4 Oz',
        cantidad: 5,
        precio: 45,
      ),
      ItemTransaccion(
        producto: 'Sorbete Tradicional Coco 8 Oz',
        cantidad: 3,
        precio: 70,
      ),
    ],
  ),

  Transaccion(
    id: 4,
    folio: 'V-00130',
    tipo: 'Venta',
    relacionado: 'Maria jose lopez',
    detalle: 'Pulperia cermen · Masaya',
    tipoVenta: 'Detalle',
    fecha: '16/08/26, 11:00 a.m.',
    fechaRelativa: 'hace 30 min',
    realizadoPor: 'María Herrera',
    rol: 'Gerente',
    estado: 'Completado',
    items: [
      ItemTransaccion(
        producto: 'Sorbete Tradicional Vainilla 8 Oz',
        cantidad: 10,
        precio: 70,
      ),
      ItemTransaccion(
        producto: 'Nieve de Chocolate 1/4 Galón',
        cantidad: 5,
        precio: 110,
      ),
    ],
  ),

  Transaccion(
    id: 5,
    folio: 'P-00065',
    tipo: 'Pedido',
    relacionado: 'Ana Sofía Sevilla',
    detalle: 'Distribuidora La Fe · entrega 20/08',
    fecha: '16/08/26, 12:30 p.m.',
    fechaRelativa: 'hace 15 min',
    realizadoPor: 'William Cortez',
    rol: 'Gerente',
    estado: 'Pendiente',
    items: [
      ItemTransaccion(
        producto: 'Sorbete Tradicional Fresa 4 Oz',
        cantidad: 20,
        precio: 45,
      ),
      ItemTransaccion(
        producto: 'Sorbete Tradicional Coco 8 Oz',
        cantidad: 10,
        precio: 70,
      ),
    ],
  ),
  Transaccion(
    id: 6,
    folio: 'V-00131',
    tipo: 'Venta',
    relacionado: 'Carlos Martínez',
    detalle: 'Heladería & Snacks Masaya · Catarina',
    tipoVenta: 'Detalle',
    fecha: '16/08/26, 01:15 p.m.',
    fechaRelativa: 'hace 5 min',
    realizadoPor: 'María Herrera',
    rol: 'Gerente',
    estado: 'Completado',
    items: [
      ItemTransaccion(
        producto: 'Sorbete Tradicional Vainilla 8 Oz',
        cantidad: 8,
        precio: 70,
      ),
      ItemTransaccion(
        producto: 'Nieve de Chocolate 1/4 Galón',
        cantidad: 4,
        precio: 110,
      ),
    ],
  ),
];
