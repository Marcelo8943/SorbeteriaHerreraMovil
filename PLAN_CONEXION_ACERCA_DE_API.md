# Plan de conexión: pantalla Acerca de con la API

## Alcance

Este documento propone cómo evaluar y, si el equipo lo aprueba, conectar la pantalla **Acerca de** desde Flutter usando solamente los endpoints que ya existen.

No se modificará la API. No se crearán endpoints, no se tocarán controladores, servicios, DTOs, base de datos ni configuración del backend.

## Estado actual de la pantalla

La pantalla está compuesta por:

- `AcercaDeScreen`: estructura visual, `SafeArea`, márgenes y navegación de regreso.
- `AboutInformationCard`: tarjeta que muestra información fija.

Actualmente presenta estos datos estáticos:

| Dato | Valor actual |
| --- | --- |
| Nombre de la app | Sorbetería Herrera App |
| Versión | 2.2.0 |
| Descripción | Prototipo móvil de monitoreo y análisis gerencial. |
| Pie | © 2026 Sorbetería Herrera |

## Hallazgo de la API

No existe un endpoint específico como:

```text
GET /api/about
GET /api/app-info
GET /api/version
```

Por eso, la versión, descripción y texto de copyright no pueden consumirse desde la API sin cambiar el backend, lo cual está fuera del alcance.

Sí existe un endpoint relacionado con la identidad del negocio:

```text
GET /api/BusinessProfile
```

La API devuelve directamente un perfil con estos campos:

```json
{
  "name": "...",
  "ruc": "...",
  "phone": "...",
  "address": "...",
  "email": "...",
  "logoUrl": "..."
}
```

Este endpoint no devuelve el formato común `success`, `message`, `data`; devuelve el objeto de negocio directamente. Flutter debe respetar ese formato.

## Decisión recomendada

Para conservar responsabilidades claras, se recomienda dividir la información así:

| Información | Fuente recomendada | Motivo |
| --- | --- | --- |
| Nombre del negocio | API: `GET /api/BusinessProfile` | Es un dato del negocio que puede cambiar. |
| Logo del negocio | API: `GET /api/BusinessProfile` | Es un recurso configurable del negocio. |
| Versión de la app | Flutter estático | Es información de la aplicación, no del negocio. |
| Descripción funcional | Flutter estático | Es texto de presentación de la aplicación. |
| Copyright | Flutter estático | No existe un dato equivalente en la API. |

Con esta opción, la pantalla no obliga a crear ni modificar nada en el backend y mantiene la versión de la app donde corresponde: en el cliente móvil.

## Ruta que se agregaría en Flutter

Si el equipo aprueba consumir el perfil del negocio, se agregaría una constante en:

```text
lib/core/constants/api_constants.dart
```

La constante propuesta sería:

```dart
static const String businessProfile = '/BusinessProfile';
```

La URL final se construye así:

```text
BASE_API_URL + /BusinessProfile
```

Como `BASE_API_URL` debe terminar en `/api`, el resultado será:

```text
http://10.0.2.2:5177/api/BusinessProfile
```

para un emulador Android conectado a la API local.

## Flujo propuesto en Flutter

```text
AcercaDeScreen
  ↓
BusinessProfileProvider
  ↓
BusinessProfileService
  ↓
BusinessProfileRepository
  ↓
ApiClient.get(ApiConstants.businessProfile)
  ↓
GET /api/BusinessProfile
```

### Modelo

Se crearía un modelo Flutter, por ejemplo `BusinessProfileModel`, con:

- `name`
- `ruc`
- `phone`
- `address`
- `email`
- `logoUrl`

El modelo tendría `fromJson` para convertir la respuesta JSON de la API a un objeto de Dart.

### Repositorio

El repositorio llamaría a `ApiClient.get` y devolvería un `BusinessProfileModel`.

### Servicio

El servicio coordinaría la llamada y centralizaría reglas simples, por ejemplo convertir una URL relativa de logo (`/uploads/...`) en una URL completa usando la base de la API.

### Provider

El provider mantendría:

- Perfil cargado.
- Estado de carga.
- Mensaje de error.

Al terminar la solicitud llamaría `notifyListeners()` para redibujar la pantalla.

### Interfaz

`AboutInformationCard` conservaría el diseño actual. Solo cambiaría el texto fijo del nombre por el valor obtenido de la API cuando esté disponible.

Durante la carga se puede mostrar un `CircularProgressIndicator` pequeño. Si ocurre un error, la pantalla puede conservar el nombre estático actual y mostrar una opción de reintento, sin bloquear el acceso a la información de versión.

## Archivos Flutter previstos

| Archivo | Cambio previsto |
| --- | --- |
| `lib/core/constants/api_constants.dart` | Agregar la ruta `businessProfile`. |
| `lib/data/models/business_profile_model.dart` | Crear el modelo que interpreta el JSON de la API. |
| `lib/data/repository/business_profile_repository.dart` | Consumir `GET /api/BusinessProfile`. |
| `lib/services/business_profile_service.dart` | Coordinar reglas de negocio y URL del logo. |
| `lib/presentation/providers/business_profile_provider.dart` | Administrar carga, datos y errores. |
| `lib/core/di/injection.dart` | Registrar Repository, Service y Provider. |
| `lib/presentation/Screens/acerca_de/acerca_de_screen.dart` | Solicitar los datos mediante Provider. |
| `lib/presentation/Screens/acerca_de/widgets/acerca_de_widgets.dart` | Recibir el nombre y logo dinámicos sin cambiar el diseño base. |

## Alternativa más simple

También es válido no conectar esta pantalla a la API.

La pantalla Acerca de puede mantenerse completamente estática porque su objetivo principal es describir la aplicación y mostrar su versión. Esta es la opción más simple y no genera una capa extra solo para un nombre.

## Recomendación para el equipo

Antes de implementar, el equipo debe decidir una de estas opciones:

1. **Mantener Acerca de estático**: recomendado si la pantalla solo describe la app.
2. **Consumir solo nombre y logo del negocio** desde `GET /api/BusinessProfile`: recomendado si desean que la identidad visual cambie según el negocio configurado.

En ambos casos no hace falta modificar la API existente.
