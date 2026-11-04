class InfoProductoItem {
  final int id;
  final String nombre;
  final bool activo;

  const InfoProductoItem({
    required this.id,
    required this.nombre,
    required this.activo,
  });

  String get estado => activo ? 'Activo' : 'Inactivo';

  factory InfoProductoItem.fromJson(
    Map<String, dynamic> json, {
    required String nombreKey,
  }) => InfoProductoItem(
    id: _intValue(json['id']),
    nombre: json[nombreKey]?.toString() ?? '',
    activo: json['isActive'] != false,
  );

  static int _intValue(dynamic value) =>
      value is int ? value : int.tryParse(value?.toString() ?? '') ?? 0;
}
