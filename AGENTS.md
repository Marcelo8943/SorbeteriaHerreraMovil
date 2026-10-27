# AGENTS.md — Sorbetería Herrera (Flutter)

App móvil en Flutter (paquete `herrera_system`) para administradores y gerentes de
Sorbetería Herrera. Complementa un sistema web existente en ASP.NET Core + SQL Server
(no lo reemplaza). UI, dominio y comentarios están en español; los identificadores del
dominio también.

## Toolchain

- Flutter 3.44.8 (stable) / Dart 3.12.2. `pubspec.yaml` exige `sdk: ^3.12.2`.
- SDK en `C:\flutter`; Android SDK en `C:\Users\Yahir\AppData\Local\Android\sdk`
  (`android/local.properties`, no versionado).
- Solo plataforma Android por ahora (`android/`); no hay `ios/`, `web/` ni `windows/`.
- Sin CI, sin hooks de pre-commit, sin `.github/`, sin `.vscode/`.

## Comandos

```bash
flutter pub get
flutter analyze                     # exit 1 HOY (ver Errores conocidos)
flutter test                        # exit 0
flutter test test/widget_test.dart  # único test del repo
flutter run                         # dispositivo/emulador Android
dart format lib test
```

- `flutter analyze` hoy falla con **3 errores de compilación** en
  `lib/core/network/api_client.dart` y 11 `info`. `flutter test` pasa igual porque
  `api_client.dart` no está en el grafo de imports de `main.dart`.
- El repo **no** está formateado de forma uniforme: `dart format` cambiaría 4 archivos
  (`lib/core/errors/app_exception.dart`, `lib/presentation/screens/login/widgets/login_widgets.dart`,
  `lib/presentation/widgets/h_stat_card.dart`, `test/widget_test.dart`). No esperes que
  `dart format --set-exit-if-changed` pase.
- Solo lints de `flutter_lints`; `analysis_options.yaml` excluye `build/**` y carpetas de plataforma.

## Errores conocidos (verificados en el estado actual)

1. **El diff de git es ruido puro de fin de línea.** `git status` marca 110 archivos y
   `git diff` muestra ~18 278 líneas, pero el contenido es idéntico salvo CRLF↔LF. No
   existe `.gitattributes` y `core.ignorecase=true`. **No hagas `git commit -a` ni confíes
   en la lista de "M" de `git status`**: crearías un commit de ~18k líneas de whitespace.
   Usa `git diff --ignore-all-space` para ver los cambios reales.
2. **Casing de rutas mezclado.** `lib/presentation/routes/app_routes.dart` importa
   `../Screens/...` (S mayúscula) pero las carpetas en disco son
   `lib/presentation/screens/...` (minúsculas). Funciona en Windows/macOS y **rompe en
   Linux**. Además el índice de git sigue registrando los paths capitalizados antiguos
   (`lib/presentation/Screens/Clientes/...`), así que el refactor a minúsculas no está
   commiteado y `git add` en Windows no lo registra. Crea carpetas nuevas en minúsculas y
   copia el casing exacto del import; para registrar un rename de verdad, usa `git mv` en
   dos pasos.
3. **`lib/core/network/api_client.dart` no compila.** `_send` declara 2 parámetros
   posicionales, pero `post`/`put`/`delete` le pasan 4 (`_send('POST', path, null, body)`).
   `flutter analyze` reporta `extra_positional_arguments_could_be_named` en las líneas 11, 13 y 15.
4. **`.env` es asset declarado pero no versionado.** `pubspec.yaml` lista `.env` en
   `assets:` y `.gitignore` tiene `*.env`. En un clone limpio `flutter build`/`flutter run`
   falla por asset ausente y `dotenv.load()` revienta. Créalo a mano:
   ```
   BASE_API_URL=http://localhost:5177/API
   ENVIRONMENT=development
   ```
5. **`dotenv.load()` corre después de `runApp()`** (`lib/main.dart:7-10`): la app arranca
   antes de que exista el env. Si tocas `main.dart`, invierte el orden.

## Arquitectura

```
lib/
  core/          constants/, network/, errors/     (+ di/ VACÍA)
  data/          models/app_models.dart, mocks/    (+ repository/ VACÍA)
  presentation/  screens/, widgets/, routes/, theme/  (+ providers/ VACÍA)
  services/      dashboard_metrics.dart
  session.dart   estado global de sesión (static)
```

- **Todo está mockeado.** Cada pantalla lee de `lib/data/mocks/mock_*.dart` (listas `const`
  de modelos). La capa de red no está conectada.
- `lib/core/di/`, `lib/data/repository/` y `lib/presentation/providers/` son
  **directorios vacíos** (git no trackea directorios vacíos). No asumas que hay contenedor
  de DI ni provider.
- `get_it` y `provider` están en `pubspec.yaml` pero **no se usan en ningún archivo de
  `lib/`**. `lib/core/errors/app_exception.dart` está **vacío**.
- `lib/data/models/app_models.dart` concentra todos los modelos (Cliente, Producto,
  Usuario, Transaccion, ...): inmutables, campos `final`, constructores `const`.
- Roles y tipos son **strings en español**, no enums: `Usuario.rol == 'Administrador'`
  (usar `Usuario.esAdministrador`), `Transaccion.tipo == 'Venta' | 'Pedido'`,
  `Producto.linea == 'Tradicionales' | 'Lights' | 'Nieves'`. Estados: `'Activo' | 'Inactivo'`, `'Pendiente'`.
- Dinero en córdoba: `C\$${monto.toStringAsFixed(0)}`.

### Autenticación (mock)

`lib/presentation/screens/login/login_screen.dart:52-56` — la contraseña es literalmente
`123` y el usuario se compara sin distinguir mayúsculas contra `mockUsuarios`
(`Marcelo`, `Yahir`, `willi`, `mherrera`). No hay backend de auth.

### Estado de sesión

`lib/session.dart` es un singleton estático: `Session.usuarioActual`, `Session.rolActual`,
`Session.esAdmin`, `Session.esGerente`, `Session.nombre`, `Session.nombreCorto`,
`Session.iniciales`, `Session.rolNombre`; `Session.iniciarSesion(usuario)` /
`Session.cerrarSesion()`. Gating por rol: `Session.esAdmin` en las pantallas y
`AppDrawerItem.adminOnly` en el drawer.

### Navegación

- Todo pasa por `AppRoutes.onGenerateRoute` (`lib/presentation/routes/app_routes.dart`).
  `initialRoute` = `AppRoutes.login` (`/login`); la app autenticada vive en
  `AppRoutes.shell` (`/`), que monta `AppShell` con 3 tabs (Inicio/Clientes/Productos) + drawer.
- **Las rutas declaradas pero no implementadas caen en `_UnderConstruction`** (placeholder)
  en vez de romper. Al agregar una pantalla: nueva constante en `AppRoutes` + `case` en el
  switch, y luego engancharla en `_drawerItems` (drawer) o en los tabs del shell.
- `AppRoutes.withArguments` enumera las rutas que reciben argumentos.
- `AppShell` usa `IndexedStack`: las 3 tabs se mantienen vivas y conservan su estado al
  cambiar de tab.

## Convenciones de código

- Estructura por feature: `lib/presentation/screens/<feature>/` con `<feature>_screen.dart`
  y una carpeta `widgets/` con uno o varios `<feature>_widgets.dart`. Widgets compartidos
  en `lib/presentation/widgets/` (incluye `navigation/` y `charts/`).
- **Usa los tokens de diseño** de `lib/presentation/theme/app_theme.dart`: `AppColors.*`,
  `AppSpacing.*` (xs/sm/md/lg/xl, `cardRadius`, `pillRadius`, `cardShadow`),
  `AppToneColors.soft` / `.intense` + enum `AppTone`, `AppTheme.light`. No hardcodees
  colores ni espaciados.
- Imports mayormente relativos dentro de `lib/`; algunos archivos usan
  `package:herrera_system/...`.
- Gráficas con `fl_chart` 1.2.0, envueltas en `lib/presentation/widgets/charts/`.
- `lib/services/dashboard_metrics.dart` es la única capa de servicio: funciones puras
  (`ventasPorPeriodo`, `ticketPromedio`, `topProductos`, `rotacionInventario`) que filtran
  `tipo == 'Venta'`. Pon ahí la lógica de negocio, no dentro de los widgets.

## Android

- `applicationId` y `namespace` siguen con el valor por defecto del template:
  `com.example.herrera_system` (cámbialo antes de publicar).
- El permiso `INTERNET` está **solo** en `android/app/src/debug/AndroidManifest.xml` → los
  builds release no pueden hacer HTTP. Además Android 9+ bloquea tráfico cleartext, así que
  `http://localhost:5177` no funciona en release.
- El build `release` usa `signingConfig = signingConfigs.getByName("debug")` (sin keystore propio).

## Ramas y reparto de módulos

- `master` es la rama por defecto en origin; existe `develop`. Ramas por feature:
  `Feature/<Nombre>` (ej. `Feature/Reportes`, `Feature/Transacciones`).
- Reparto (según los comentarios en `app_routes.dart`):
  - **Marcelo** — autenticación y configuración (`configuracion`, `mi-perfil`,
    `datos-negocio`, `seguridad`, `acerca-de`, `preferencias`).
  - **Ronald** — catálogo y clientes (`clientes`, `productos`, `info-producto`, `precios`).
  - **Yahir** — dashboard, transacciones, inventario, usuarios y logs.
- Rama de trabajo actual: `refactor/arquitecture` (refactor de carpetas a
  `core/`/`data/`/`presentation/`).

## Antes de commitear

1. `flutter analyze` y luego `flutter test` (en ese orden). Nota: `analyze` ya está en rojo
   por `api_client.dart`; si no tocaste ese archivo, no es culpa tuya — pero dilo.
2. `git diff --ignore-all-space` para ver el diff real y no el ruido CRLF.
3. `git status` no dice qué cambió de verdad: revisa archivo por archivo.
