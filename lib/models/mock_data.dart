import 'app_models.dart';

/// Datos de ejemplo (hardcodeados), adaptados del prototipo, para que
/// todas las pantallas puedan mostrar contenido real sin esperar a la
/// conexión con la API. NO son datos de producción.

const List<Cliente> mockClientes = [
  Cliente(id: 1, nombre: 'Roberto Argüello', telefono: '8777-6543', departamento: 'Masaya', municipio: 'Catarina', puntoVenta: 'Heladería & Snacks Masaya'),
  Cliente(id: 2, nombre: 'Luisa Fernanda Campos', telefono: '8456-7812', departamento: 'Granada', municipio: 'Diriomo', puntoVenta: 'Minisuper Diriomo'),
  Cliente(id: 3, nombre: 'Nohelia Cortes', telefono: '8943-6822', departamento: 'Managua', municipio: 'Tipitapa', puntoVenta: 'Teresa'),
];

const List<Producto> mockProductos = [
  Producto(id: 1, nombre: 'Sorbete Tradicional Fresa 4 Oz', linea: 'Tradicionales', sabor: 'Fresa', presentacion: '4 Onzas', precioDetalle: 45, precioMayoreo: 40, estado: 'Activo', imgUrl: ''),
  Producto(id: 2, nombre: 'Sorbete Tradicional Coco 8 Oz', linea: 'Tradicionales', sabor: 'Coco', presentacion: '8 Onzas', precioDetalle: 70, precioMayoreo: 65, estado: 'Activo', imgUrl: ''),
  Producto(id: 3, nombre: 'Nieve de Chocolate 1/4 Galón', linea: 'Nieves', sabor: 'Chocolate', presentacion: '1/4 Galón', precioDetalle: 110, precioMayoreo: 100, estado: 'Activo', imgUrl: ''),
];

const List<Usuario> mockUsuarios = [
  Usuario(id: 1, nombre: 'Nohelia Cortes', usuario: 'nohelia_cortes', cedula: '001-120580-0001A', correo: 'nohelia.cortes@gmail.com', rol: 'Administrador', estado: 'Activo'),
  Usuario(id: 2, nombre: 'William Cortez', usuario: 'willi', cedula: '0411020508100H', correo: 'cortezwilliam@gmail.com', rol: 'Gerente', estado: 'Activo'),
];

const List<Transaccion> mockTransacciones = [
  Transaccion(
    id: 1, folio: 'V-00128', tipo: 'Venta', relacionado: 'Roberto Argüello', detalle: 'Heladería & Snacks Masaya · Catarina', tipoVenta: 'Detalle', fecha: '16/08/26, 09:40 a.m.', fechaRelativa: 'hace 2 h', realizadoPor: 'William Cortez', rol: 'Gerente', estado: 'Completado',
    items: [
      ItemTransaccion(producto: 'Sorbete Tradicional Fresa 4 Oz', cantidad: 8, precio: 45),
      ItemTransaccion(producto: 'Sorbete Tradicional Coco 8 Oz', cantidad: 4, precio: 70),
    ],
  ),
  Transaccion(
    id: 2, folio: 'P-00064', tipo: 'Pedido', relacionado: 'Luisa Fernanda Campos', detalle: 'Minisuper Diriomo · entrega 18/08', fecha: '16/08/26, 07:15 a.m.', fechaRelativa: 'hace 5 h', realizadoPor: 'María Herrera', rol: 'Gerente', estado: 'Pendiente',
    items: [
      ItemTransaccion(producto: 'Sorbete Tradicional Vainilla 8 Oz', cantidad: 15, precio: 70),
      ItemTransaccion(producto: 'Nieve de Chocolate 1/4 Galón', cantidad: 10, precio: 110),
    ],
  ),
];

const List<Movimiento> mockMovimientos = [
  Movimiento(id: 1, folio: 'M-00058', tipo: 'Transferencia', producto: 'Sorbete Tradicional Coco 8 Oz', cantidad: 15, origen: 'Bodega', destino: 'Reserva', motivo: 'Stock apartado para atender Pedido P-00064 de Minisuper Diriomo.', referencia: 'Pedido P-00064', fecha: '16/08/26, 08:20 a.m.', fechaRelativa: 'hace 3 h', realizadoPor: 'Nohelia Cortes', rol: 'Administrador'),
  Movimiento(id: 3, folio: 'M-00056', tipo: 'Ajuste Negativo', producto: 'Sorbete Tradicional Vainilla 8 Oz', cantidad: 3, ubicacion: 'Mostrador', motivo: 'Producto dañado por falla de refrigeración (merma confirmada).', referencia: 'Conteo físico 16/08', fecha: '16/08/26, 07:10 a.m.', fechaRelativa: 'hace 6 h', realizadoPor: 'María Herrera', rol: 'Gerente'),
];

const List<LogEvento> mockLogs = [
  LogEvento(id: 1, tipo: 'Creación', modulo: 'Clientes', descripcion: 'Creó el cliente Raúl Herrera', usuario: 'Nohelia Cortes', fecha: '16/08/26, 09:24 a.m.', fechaRelativa: 'hace 2 h'),
  LogEvento(id: 2, tipo: 'Edición', modulo: 'Precios', descripcion: 'Editó el precio de 8 Onzas (Tradicionales): detalle C\$65 → C\$70 y mayoreo C\$60 → C\$65.', usuario: 'Nohelia Cortes', fecha: '15/08/26, 04:56 p.m.', fechaEdicion: '16/08/26, 08:02 a.m.', fechaRelativa: 'ayer'),
];
