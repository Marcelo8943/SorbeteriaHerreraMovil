class ProductoCatalogoModel {
  final int id;
  final String nombre;
  final String? imagenUrl;
  final bool activo;
  final String linea;
  final String sabor;
  final String presentacion;
  final double? precioMayoreo;
  final double? precioDetalle;

  const ProductoCatalogoModel({
    required this.id,
    required this.nombre,
    required this.imagenUrl,
    required this.activo,
    required this.linea,
    required this.sabor,
    required this.presentacion,
    required this.precioMayoreo,
    required this.precioDetalle,
  });

  factory ProductoCatalogoModel.fromJson(Map<String, dynamic> json) =>
      ProductoCatalogoModel(
        id: _intValue(json['id']),
        nombre: json['productName']?.toString() ?? '',
        imagenUrl: json['imageUrl']?.toString(),
        activo: json['isActive'] == true,
        linea: json['lineName']?.toString() ?? '',
        sabor: json['flavorName']?.toString() ?? '',
        presentacion: json['presentationName']?.toString() ?? '',
        precioMayoreo: _doubleValue(json['wholesalePrice']),
        precioDetalle: _doubleValue(json['retailPrice']),
      );

  static int _intValue(dynamic value) =>
      value is int ? value : int.tryParse(value?.toString() ?? '') ?? 0;

  static double? _doubleValue(dynamic value) =>
      value == null ? null : double.tryParse(value.toString());
}

class PaginaProductos {
  final List<ProductoCatalogoModel> productos;
  final int currentPage;
  final int pageSize;
  final int totalRecords;
  final int totalPages;

  const PaginaProductos({
    required this.productos,
    required this.currentPage,
    required this.pageSize,
    required this.totalRecords,
    required this.totalPages,
  });

  factory PaginaProductos.fromJson(Map<String, dynamic> json) =>
      PaginaProductos(
        productos: (json['data'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(ProductoCatalogoModel.fromJson)
            .toList(),
        currentPage: ProductoCatalogoModel._intValue(json['currentPage']),
        pageSize: ProductoCatalogoModel._intValue(json['pageSize']),
        totalRecords: ProductoCatalogoModel._intValue(json['totalRecords']),
        totalPages: ProductoCatalogoModel._intValue(json['totalPages']),
      );
}

class ProductoEstadisticasModel {
  final int total;
  final int activos;
  final int inactivos;

  const ProductoEstadisticasModel({
    required this.total,
    required this.activos,
    required this.inactivos,
  });

  factory ProductoEstadisticasModel.fromJson(Map<String, dynamic> json) =>
      ProductoEstadisticasModel(
        total: ProductoCatalogoModel._intValue(json['totalProducts']),
        activos: ProductoCatalogoModel._intValue(json['activeProducts']),
        inactivos: ProductoCatalogoModel._intValue(json['inactiveProducts']),
      );
}

class OpcionCatalogoProducto {
  final int id;
  final String nombre;

  const OpcionCatalogoProducto({required this.id, required this.nombre});

  factory OpcionCatalogoProducto.fromJson(
    Map<String, dynamic> json, {
    required String nombreKey,
  }) => OpcionCatalogoProducto(
    id: ProductoCatalogoModel._intValue(json['id']),
    nombre: json[nombreKey]?.toString() ?? '',
  );
}
