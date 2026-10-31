import 'package:flutter/material.dart';
import 'package:herrera_system/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../Screens/configuraciones/conf_screen.dart';
import '../Screens/datos_negocio/datos_negocio_screen.dart';
import '../Screens/mi_perfil/mi_perfil_screen.dart';
import '../Screens/seguridad/seguridad_screen.dart';
import '../Screens/login/login_screen.dart';
import '../Screens/preferencias_sistema/sistema_screen.dart';
import '../Screens/dashboard/dashboard_screen.dart';
import '../Screens/clientes/clientes_screen.dart';
import '../screens/productos/productos_screen.dart';
import '../Screens/precios/precios_screen.dart';
import '../Screens/usuarios/usuarios_screen.dart';
import '../Screens/inventario/inventario_screen.dart';
import '../Screens/movimientos/movimientos_screen.dart';
import '../Screens/movimientos/movimiento_detalle_screen.dart';
import '../Screens/transacciones/transacciones_screen.dart';
import '../Screens/transacciones/transaccion_detalle_screen.dart';
import '../screens/ventas/ventas_screen.dart';
import '../screens/pedidos/pedidos_screen.dart';
import '../screens/reabastecimientos/reabastecimientos_screen.dart';
import '../Screens/info_producto/info_producto_screen.dart';
import '../Screens/logs/logs_screen.dart';
import '../Screens/reportes/reportes_screen.dart';
import '../../session.dart';
import '../widgets/navigation/app_drawer.dart';
import '../widgets/navigation/app_shell.dart';
import '../widgets/navigation/app_tabbar.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String shell = '/'; // Inicio/Clientes/Productos + tabbar

  // Marcelo — Autenticación y Configuración
  static const String configuracion = '/configuracion';
  static const String miPerfil = '/mi-perfil';
  static const String datosNegocio = '/datos-negocio';
  static const String seguridad = '/seguridad';
  static const String preferencias = '/preferencias';

  // Ronald — Catálogo y Clientes
  static const String clienteDetalle = '/cliente-detalle';
  static const String clienteForm = '/cliente-form';
  static const String productoDetalle = '/producto-detalle';
  static const String productoForm = '/producto-form';
  static const String infoProducto = '/info-producto';
  static const String precios = '/precios';

  // Yahir — Dashboard, Transacciones, Inventario, Usuarios y Logs
  static const String transacciones = '/transacciones';
  static const String ventas = '/ventas';
  static const String pedidos = '/pedidos';
  static const String reabastecimientos = '/reabastecimientos';
  static const String transaccionDetalle = '/transaccion-detalle';
  static const String movimientos = '/movimientos';
  static const String movimientoDetalle = '/movimiento-detalle';
  static const String reportes = '/reportes';
  static const String inventario = '/inventario';
  static const String usuarios = '/usuarios';
  static const String usuarioDetalle = '/usuario-detalle';
  static const String usuarioForm = '/usuario-form';
  static const String logs = '/logs';
  static const String logDetalle = '/log-detalle';

  static const Set<String> withArguments = {
    clienteDetalle,
    productoDetalle,
    transaccionDetalle,
    movimientoDetalle,
    usuarioDetalle,
    usuarioForm,
    logDetalle,
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case shell:
        return MaterialPageRoute(builder: (_) => const _AuthenticatedShell());

      case configuracion:
        return MaterialPageRoute(
          builder: (_) => const ConfiguracionesScreen(),
          settings: settings,
        );

      case miPerfil:
        return MaterialPageRoute(
          builder: (_) => const MiPerfilScreen(),
          settings: settings,
        );

      case datosNegocio:
        return MaterialPageRoute(
          builder: (_) => const DatosNegocioScreen(),
          settings: settings,
        );

      case seguridad:
        return MaterialPageRoute(
          builder: (_) => const SeguridadScreen(),
          settings: settings,
        );

      case preferencias:
        return MaterialPageRoute(
          builder: (_) => const PreferenciasSistemaScreen(),
          settings: settings,
        );

      case precios:
        return MaterialPageRoute(
          builder: (_) => const PreciosScreen(),
          settings: settings,
        );

      case usuarios:
        return MaterialPageRoute(
          builder: (_) => const UsuariosScreen(),
          settings: settings,
        );

      case inventario:
        return MaterialPageRoute(
          builder: (_) => const InventarioScreen(),
          settings: settings,
        );

      case movimientos:
        return MaterialPageRoute(
          builder: (_) => const MovimientosScreen(),
          settings: settings,
        );

      case movimientoDetalle:
        final movementId = settings.arguments;
        if (movementId is! int) {
          return MaterialPageRoute(
            builder: (_) =>
                const _UnderConstruction(title: 'Movimiento no disponible'),
            settings: settings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => MovimientoDetalleScreen(movementId: movementId),
          settings: settings,
        );

      case transacciones:
        return MaterialPageRoute(
          builder: (_) => const TransaccionesScreen(),
          settings: settings,
        );

      case ventas:
        return MaterialPageRoute(
          builder: (_) => const VentasScreen(),
          settings: settings,
        );

      case pedidos:
        return MaterialPageRoute(
          builder: (_) => const PedidosScreen(),
          settings: settings,
        );

      case reabastecimientos:
        return MaterialPageRoute(
          builder: (_) => const ReabastecimientosScreen(),
          settings: settings,
        );

      case transaccionDetalle:
        return MaterialPageRoute(
          builder: (_) => const TransaccionDetalleScreen(),
          settings: settings,
        );

      case infoProducto:
        return MaterialPageRoute(
          builder: (_) => const InfoProductoScreen(),
          settings: settings,
        );

      case logs:
        return MaterialPageRoute(
          builder: (_) => const LogsScreen(),
          settings: settings,
        );
      case reportes:
        return MaterialPageRoute(
          builder: (_) => const ReportesScreen(),
          settings: settings,
        );

      default:
        final title = _titleFor(settings.name);
        return MaterialPageRoute(
          builder: (_) => _UnderConstruction(title: title),
          settings: settings,
        );
    }
  }

  static String _titleFor(String? routeName) {
    if (routeName == null) return 'Pantalla';
    return routeName
        .replaceAll('/', '')
        .replaceAll('-', ' ')
        .split(' ')
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }
}

class _AuthenticatedShell extends StatelessWidget {
  const _AuthenticatedShell();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final userName = user?.fullName ?? 'Usuario';
    final userRole = user?.roleName ?? 'Usuario';
    final userInitials = user?.initials.isNotEmpty == true
        ? user!.initials
        : 'U';
    final isAdmin =
        user?.roles.any((role) {
          final normalizedRole = role.trim().toLowerCase();
          return normalizedRole == 'admin' ||
              normalizedRole == 'administrador';
        }) ??
        false;

    return AppShell(
      tabItems: const [
        AppTabBarItem(icon: Icons.home_outlined, label: 'Inicio'),
        AppTabBarItem(icon: Icons.people_outline, label: 'Clientes'),
        AppTabBarItem(icon: Icons.inventory_2_outlined, label: 'Productos'),
      ],
      tabScreens: const [
        DashboardScreen(),
        ClientesScreen(),
        ProductosScreen(),
      ],
      drawerBuilder: (context) => AppDrawer(
        userName: userName,
        userRole: userRole,
        userInitials: userInitials,
        isAdmin: isAdmin,
        onProfileTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(AppRoutes.miPerfil);
        },
        items: _drawerItems(context),
      ),
    );
  }

  List<AppDrawerItem> _drawerItems(BuildContext context) => [
    AppDrawerItem(
      icon: Icons.assessment_outlined,
      label: 'Reportes',
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(AppRoutes.reportes);
      },
    ),
    AppDrawerItem(
      icon: Icons.sell_outlined,
      label: 'Precios',
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(AppRoutes.precios);
      },
    ),
    AppDrawerItem(
      icon: Icons.info_outline,
      label: 'Info del Producto',
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(AppRoutes.infoProducto);
      },
    ),
    AppDrawerItem(
      icon: Icons.inventory_outlined,
      label: 'Inventario',
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(AppRoutes.inventario);
      },
    ),
    AppDrawerItem(
      icon: Icons.receipt_long_outlined,
      label: 'Transacciones',
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(AppRoutes.transacciones);
      },
    ),
    AppDrawerItem(
      icon: Icons.swap_horiz,
      label: 'Movimientos de Inventario',
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(AppRoutes.movimientos);
      },
    ),
    AppDrawerItem(
      icon: Icons.people_alt_outlined,
      label: 'Usuarios',
      adminOnly: true,
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(AppRoutes.usuarios);
      },
    ),
    AppDrawerItem(
      icon: Icons.history_outlined,
      label: 'Logs del Sistema',
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(AppRoutes.logs);
      },
    ),
    AppDrawerItem(
      icon: Icons.account_tree_outlined,
      label: 'Preferencias del Sistema',
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(AppRoutes.preferencias);
      },
    ),
    AppDrawerItem(
      icon: Icons.settings_outlined,
      label: 'Configuración',
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(AppRoutes.configuracion);
      },
    ),
    AppDrawerItem(
      icon: Icons.logout,
      label: 'Cerrar sesión',
      destructive: true,
      onTap: () async => _logout(context),
    ),
  ];

  Future<void> _logout(BuildContext context) async {
    final navigator = Navigator.of(context);
    final auth = context.read<AuthProvider>();
    await auth.logout();
    Session.cerrarSesion();
    navigator.pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
  }
}

/// Placeholder genérico para cualquier ruta ya definida pero sin
/// pantalla implementada todavía. Evita que la app truene al navegar
/// a algo que otro compañero aún no ha construido.
class _UnderConstruction extends StatelessWidget {
  final String title;

  const _UnderConstruction({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title — en construcción')),
    );
  }
}
