import 'package:herrera_system/models/app_models.dart';

/// Datos de ejemplo (hardcodeados), adaptados del prototipo, para que
/// todas las pantallas puedan mostrar contenido real sin esperar a la
/// conexión con la API. NO son datos de producción.

const List<Cliente> mockClientes = [
  Cliente(
    id: 1,
    nombre: 'Roberto Argüello',
    telefono: '8777-6543',
    departamento: 'Masaya',
    municipio: 'Catarina',
    puntoVenta: 'Heladería & Snacks Masaya',
  ),
  Cliente(
    id: 2,
    nombre: 'Luisa Fernanda Campos',
    telefono: '8456-7812',
    departamento: 'Granada',
    municipio: 'Diriomo',
    puntoVenta: 'Minisuper Diriomo',
  ),
  Cliente(
    id: 3,
    nombre: 'Nohelia Cortes',
    telefono: '8943-6822',
    departamento: 'Managua',
    municipio: 'Tipitapa',
    puntoVenta: 'Teresa',
  ),
];
