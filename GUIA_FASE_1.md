# Amazona · Fase 1: estructura, navegación y API

## Cómo montarlo en tu computador

1. Crea el proyecto: `flutter create amazona`
2. Copia en esa carpeta, reemplazando lo que exista: `lib/`, `api/`, `test/modelos_test.dart` y `pubspec.yaml`.
3. Borra `test/widget_test.dart`: busca una clase `MyApp` que ya no existe y haría fallar `flutter analyze`.
4. Ejecuta `flutter pub get`.
5. Crea en GitHub el repositorio público `amazona` y sube el proyecto.
6. En `lib/utilidades/config.dart`, cambia `TU_USUARIO` por tu usuario de GitHub.
7. Abre en el navegador la dirección de `config.dart`. Si ves el JSON, la API funciona.
8. Ejecuta en el emulador Android con `flutter run` y revisa con `flutter analyze`.

## Commits sugeridos (uno por paso, para que el historial cuente la evolución)

1. `Crea proyecto Flutter y tema con los colores de la marca`
2. `Agrega contenido del método en api/metodo.json`
3. `Crea modelos de Dart para el contenido del método`
4. `Agrega servicio de API con tiempo de espera y manejo de errores`
5. `Crea pantalla de inicio con estados de carga, éxito y error`
6. `Agrega pantallas Mi día y detalle del paso con navegación`
7. `Agrega formulario de reflexión con validación`
8. `Agrega pantalla Mi recorrido y widget hexágono reutilizable`

## Qué tienes que poder explicar (te lo pueden preguntar)

| Pregunta | Dónde está |
|---|---|
| ¿Dónde se llama a la API? | `servicios/api_metodo.dart`, método `obtenerContenido()` |
| ¿Qué pasa si no hay internet? | Se lanza `ApiException` y `inicio_pantalla.dart` muestra `VistaError` con "Reintentar" |
| ¿Dónde se convierte el JSON en modelos? | `modelos/contenido_metodo.dart`, constructores `fromJson` |
| ¿Qué dato viaja entre pantallas? | El `ContenidoMetodo` va de Inicio a Mi día, y el `Paso` va de Mi día al detalle. El detalle devuelve `true` con `Navigator.pop` |
| ¿Por qué el tiempo de espera es de 10 s? | `utilidades/config.dart`: si pasa ese tiempo, se muestra el error en vez de quedarse cargando |
| ¿Por qué la API es un JSON en GitHub? | El contenido del método se puede cambiar sin publicar una nueva versión de la app |
| ¿Cómo agregarías una quinta pantalla? | Se crea en `pantallas/` y se abre con `Navigator.push` + `MaterialPageRoute` desde donde se necesite |

## Pendiente para las siguientes fases

- **Fase 2:** guardar en SQLite (sqflite) los pasos cumplidos y las reflexiones, para que sigan ahí al cerrar la app.
- **Fase 3:** pantalla del método completo con pago simulado, fundación y desbloqueo de la tarde y la noche.
- **Fase 4:** README completo con capturas, flujo, modelo de datos, API, fuentes y limitaciones.
