class Cliente {
  final int id;
  final String nombre;
  final String telefono;
  final String departamento;
  final String municipio;
  final String puntoVenta;
  final String clienteDesde;
  final String? iniciales; // ej. "J.D." para "Juan Díaz"

  const Cliente({
    required this.id,
    required this.nombre,
    required this.telefono,
    required this.departamento,
    required this.municipio,
    required this.puntoVenta,
    required this.clienteDesde,
    this.iniciales,
  });
}

class Producto {
  final int id;
  final String nombre;
  final String linea; // ej. "Tradicionales", "Lights", "Nieves"
  final String sabor;
  final String presentacion; // ej. "8 Onzas", "1/4 Galón"
  final double precioDetalle;
  final double precioMayoreo;
  final String estado; // "Activo" | "Inactivo"
  final String imgUrl;

  const Producto({
    required this.id,
    required this.nombre,
    required this.linea,
    required this.sabor,
    required this.presentacion,
    required this.precioDetalle,
    required this.precioMayoreo,
    required this.estado,
    required this.imgUrl,
  });
}

class Usuario {
  final int id;
  final String nombre;
  final String usuario; // @handle
  final String cedula;
  final String correo;
  final String rol; // "Administrador" | "Gerente"
  final String estado; // "Activo" | "Inactivo"

  const Usuario({
    required this.id,
    required this.nombre,
    required this.usuario,
    required this.cedula,
    required this.correo,
    required this.rol,
    required this.estado,
  });

  bool get esAdministrador => rol == 'Administrador';
}

class Negocio {
  final String nombre;
  final String eslogan;
  final String direccion;
  final String telefono;
  final String correo;

  const Negocio({
    required this.nombre,
    required this.eslogan,
    required this.direccion,
    required this.telefono,
    required this.correo,
  });
}

class ItemTransaccion {
  final String producto;
  final int cantidad;
  final double precio;

  const ItemTransaccion({
    required this.producto,
    required this.cantidad,
    required this.precio,
  });

  double get subtotal => cantidad * precio;
}

/// tipo: "Venta" | "Pedido" | "Reabastecimiento"
class Transaccion {
  final int id;
  final String folio;
  final String tipo;
  final String relacionado; // cliente o resumen de productos
  final String detalle;
  final String? tipoVenta; // "Detalle" | "Mayoreo" (null si no aplica)
  final String fecha;
  final String fechaRelativa;
  final String realizadoPor;
  final String rol;
  final String estado; // "Completado" | "Pendiente" | etc.
  final List<ItemTransaccion> items;

  const Transaccion({
    required this.id,
    required this.folio,
    required this.tipo,
    required this.relacionado,
    required this.detalle,
    this.tipoVenta,
    required this.fecha,
    required this.fechaRelativa,
    required this.realizadoPor,
    required this.rol,
    required this.estado,
    this.items = const [],
  });

  double get monto => items.fold(0, (sum, i) => sum + i.subtotal);
  int get cantidadTotal => items.fold(0, (sum, i) => sum + i.cantidad);
}

/// tipo: "Transferencia" | "Ajuste Positivo" | "Ajuste Negativo"
class Movimiento {
  final int id;
  final String folio;
  final String tipo;
  final String producto;
  final int cantidad;
  final String? origen; // LocationId 1=Bodega,2=Mostrador,3=Reservado
  final String? destino;
  final String? ubicacion; // usado cuando no es transferencia
  final String motivo;
  final String referencia;
  final String fecha;
  final String fechaRelativa;
  final String realizadoPor;
  final String rol;

  const Movimiento({
    required this.id,
    required this.folio,
    required this.tipo,
    required this.producto,
    required this.cantidad,
    this.origen,
    this.destino,
    this.ubicacion,
    required this.motivo,
    required this.referencia,
    required this.fecha,
    required this.fechaRelativa,
    required this.realizadoPor,
    required this.rol,
  });
}

/// tipo: "Creación" | "Edición" | "Desactivación" | "Inicio de sesión"
class LogEvento {
  final int id;
  final String tipo;
  final String modulo;
  final String descripcion;
  final String usuario;
  final String fecha;
  final String? fechaEdicion;
  final String fechaRelativa;

  const LogEvento({
    required this.id,
    required this.tipo,
    required this.modulo,
    required this.descripcion,
    required this.usuario,
    required this.fecha,
    this.fechaEdicion,
    required this.fechaRelativa,
  });

}

// Modelo de catalogos.
class Linea {
  final int id;
  final String nombre;

  const Linea({
    required this.id,
    required this.nombre,
  });
}

class Presentacion {
  final int id;
  final String nombre;

  const Presentacion({
    required this.id,
    required this.nombre,
  });
}

class Sabor {
  final int id;
  final String nombre;

  const Sabor({
    required this.id,
    required this.nombre,
  });
}

