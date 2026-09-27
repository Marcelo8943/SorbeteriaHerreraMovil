class InfoProductoMockItem {
  final String nombre;
  final String estado;

  const InfoProductoMockItem({required this.nombre, this.estado = 'Activo'});
}

const List<InfoProductoMockItem> mockInfoLineas = [
  InfoProductoMockItem(nombre: 'Tradicionales'),
  InfoProductoMockItem(nombre: 'Lights'),
  InfoProductoMockItem(nombre: 'Nieves'),
  InfoProductoMockItem(nombre: 'Paletas'),
  InfoProductoMockItem(nombre: 'Fantasía'),
];

const List<InfoProductoMockItem> mockInfoPresentaciones = [
  InfoProductoMockItem(nombre: '4 Onzas'),
  InfoProductoMockItem(nombre: '8 Onzas'),
  InfoProductoMockItem(nombre: '1/4 Galón'),
  InfoProductoMockItem(nombre: '1/2 Galón'),
  InfoProductoMockItem(nombre: '1 libra'),
];
