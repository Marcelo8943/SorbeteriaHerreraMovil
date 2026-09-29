import '../app_models.dart';

const usuarioActual = Usuario(
  id: 1,
  nombre: 'Marcelo Mena',
  usuario: 'Marcelo',
  cedula: '001-000000-0000A',
  correo: 'marcelomena@gmail.com',
  rol: 'Administrador',
  estado: 'Activo',
);

const List<Usuario> mockUsuarios = [
  Usuario(
    id: 1,
    nombre: 'Yahir Lopez',
    usuario: 'Yahir',
    cedula: '001-120580-0001A',
    correo: 'yahir.lopez@gmail.com',
    rol: 'Administrador',
    estado: 'Activo',
  ),

  Usuario(
    id: 2,
    nombre: 'William Cortez',
    usuario: 'willi',
    cedula: '001-200495-0003C',
    correo: 'william@gmail.com',
    rol: 'Gerente',
    estado: 'Activo',
  ),
  Usuario(
    id: 3,
    nombre: 'María Herrera',
    usuario: 'mherrera',
    cedula: '001-300890-0004D',
    correo: 'mherrera@gmail.com',
    rol: 'Gerente',
    estado: 'Activo',
  ),
];
