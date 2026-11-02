class ProductoVistaModel {
  final int id;
  final String nombre;
  final String linea;
  final String sabor;
  final String presentacion;
  final double precioDetalle;
  final double precioMayoreo;
  final String estado;
  final String imgUrl;
  final int stockMinimo;
  final int stockActual;
  final int? linePresentationId;
  final int? flavorId;

  const ProductoVistaModel({
    required this.id,
    required this.nombre,
    required this.linea,
    required this.sabor,
    required this.presentacion,
    required this.precioDetalle,
    required this.precioMayoreo,
    required this.estado,
    required this.imgUrl,
    required this.stockMinimo,
    required this.stockActual,
    this.linePresentationId,
    this.flavorId,
  });
}
