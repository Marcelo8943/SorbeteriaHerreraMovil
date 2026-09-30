import 'models/app_models.dart';

enum Rol { admin, gerente }

class Session {
  Session._();

  static Rol? rolActual;
  static Usuario? usuarioActual;

  static bool get esAdmin => rolActual == Rol.admin;
  static bool get esGerente => rolActual == Rol.gerente;

  static String get nombre => usuarioActual?.nombre ?? 'Usuario';
  static String get nombreCorto => nombre.split(' ').first;
  static String get rolNombre => esGerente ? 'Gerente' : 'Administrador';
  static String get iniciales => nombre
      .split(' ')
      .where((parte) => parte.isNotEmpty)
      .take(2)
      .map((parte) => parte[0])
      .join();

  static void iniciarSesion(Usuario usuario) {
    usuarioActual = usuario;
    rolActual = usuario.esAdministrador ? Rol.admin : Rol.gerente;
  }

  static void cerrarSesion() {
    usuarioActual = null;
    rolActual = null;
  }
}
