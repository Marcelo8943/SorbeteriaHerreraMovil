import 'package:flutter/material.dart';

import '../Screens/Configuraciones/conf_screen.dart';
import '../Screens/Configuraciones/AcercaDe/acerca_de_screen.dart';
import '../Screens/Configuraciones/DatosNegocio/datos_negocio_screen.dart';
import '../Screens/Configuraciones/MiPerfil/mi_perfil_screen.dart';
import '../Screens/Configuraciones/Seguridad/seguridad_screen.dart';
import '../Screens/Login/login_screen.dart';
import '../Screens/Dashboard/dashboard_screen.dart';
import '../Screens/Clientes/clientes_screen.dart';
import '../Screens/Productos/productos_screen.dart';
import '../Screens/Precios/precios_screen.dart';
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
  static const String acercaDe = '/acerca-de';
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

      case acercaDe:
        return MaterialPageRoute(
          builder: (_) => const AcercaDeScreen(),
          settings: settings,
        );

      case precios:
        return MaterialPageRoute(
          builder: (_) => const PreciosScreen(),
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
        userName: 'Marcelo Herrera',
        userRole: 'Administrador',
        userInitials: 'MH',
        isAdmin: true,
        onProfileTap: () => _showPending(context, 'Perfil'),
        items: _drawerItems(context),
      ),
    );
  }

  List<AppDrawerItem> _drawerItems(BuildContext context) => [
    AppDrawerItem(
      icon: Icons.assessment_outlined,
      label: 'Reportes',
      onTap: () => _showPending(context, 'Reportes'),
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
      onTap: () => _showPending(context, 'Info del Producto'),
    ),
    AppDrawerItem(
      icon: Icons.inventory_outlined,
      label: 'Inventario',
      onTap: () => _showPending(context, 'Inventario'),
    ),
    AppDrawerItem(
      icon: Icons.receipt_long_outlined,
      label: 'Transacciones',
      onTap: () => _showPending(context, 'Transacciones'),
    ),
    AppDrawerItem(
      icon: Icons.swap_horiz,
      label: 'Movimientos de Inventario',
      onTap: () => _showPending(context, 'Movimientos de Inventario'),
    ),
    AppDrawerItem(
      icon: Icons.people_alt_outlined,
      label: 'Usuarios',
      adminOnly: true,
      onTap: () => _showPending(context, 'Usuarios'),
    ),
    AppDrawerItem(
      icon: Icons.history_outlined,
      label: 'Logs del Sistema',
      onTap: () => _showPending(context, 'Logs del Sistema'),
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
      onTap: () => _showPending(context, 'Cerrar sesión'),
    ),
  ];

  void _showPending(BuildContext context, String destination) {
    Navigator.of(context).pop(); // cierra el drawer
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$destination — en construcción')));
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
