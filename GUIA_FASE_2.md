# Amazona · Fase 2: persistencia con SQLite

## Qué cambia

| Archivo | Nuevo o cambiado | Para qué |
|---|---|---|
| `lib/modelos/reflexion.dart` | Nuevo | Modelo de la reflexión de la noche |
| `lib/servicios/base_datos.dart` | Nuevo | Crea la base de datos y guarda y lee los datos |
| `lib/pantallas/mi_dia_pantalla.dart` | Cambiado | Lee los pasos cumplidos de hoy y guarda cada paso nuevo |
| `lib/pantallas/paso_pantalla.dart` | Cambiado | Guarda la reflexión y la vuelve a mostrar si ya existe |

No reemplaces `lib/utilidades/config.dart`: ahí está tu dirección de GitHub.

## Cómo instalarlo

1. Copia la carpeta `lib` de este zip dentro de tu proyecto y elige **Reemplazar**.
2. En la terminal: `flutter pub get` y luego `flutter analyze`.
3. Con el emulador encendido: `flutter run -d emulator-5554`.

## Cómo probar que funciona (así se hace en la demo)

1. Entra a **Mi día** y marca dos pasos como hechos.
2. Cierra la app por completo en el emulador: botón de apps recientes (el cuadrado) → desliza Amazona hacia arriba.
3. Vuelve a abrirla desde el ícono.
4. Entra a **Mi día**: los dos pasos siguen tachados.

SQLite no funciona en Chrome. Para esta fase usa siempre el emulador.

## Commits sugeridos

```
git add lib/modelos/reflexion.dart lib/servicios/base_datos.dart
git commit -m "Agrega base de datos SQLite con tablas de pasos y reflexiones"

git add lib/pantallas/mi_dia_pantalla.dart
git commit -m "Guarda y lee los pasos cumplidos del día en SQLite"

git add lib/pantallas/paso_pantalla.dart
git commit -m "Guarda la reflexión de la noche en SQLite"

git push
```

## Qué tienes que poder explicar

| Pregunta | Respuesta | Dónde está |
|---|---|---|
| ¿Dónde se guarda este dato? | En la base de datos `amazona.db`, dentro del celular | `servicios/base_datos.dart`, método `_abrir()` |
| ¿Qué tablas hay? | `pasos_cumplidos` (fecha + id del paso) y `reflexiones` (fecha + 3 respuestas) | `onCreate` en `base_datos.dart` |
| ¿Cuándo se crean las tablas? | La primera vez que se abre la base de datos (`onCreate`) | `base_datos.dart` |
| ¿Por qué `UNIQUE(fecha, paso_id)`? | Para que un paso no se guarde dos veces el mismo día | Tabla `pasos_cumplidos` |
| ¿Qué hace `ConflictAlgorithm.replace`? | Si ya hay una reflexión ese día, la reemplaza por la nueva | `guardarReflexion()` |
| ¿Por qué hay una sola instancia (`BaseDatos.instancia`)? | Para no abrir la base de datos varias veces | Inicio de `base_datos.dart` |
| ¿Por qué SQLite y no un archivo JSON? | Se vio en clase, permite consultas por fecha y evita duplicados con `UNIQUE`. Un JSON obliga a leer y reescribir todo el archivo en cada cambio | Decisión técnica para el README |
| ¿Qué pasa si falla al guardar? | Se captura el error y se muestra un mensaje abajo (SnackBar), sin cerrar la app | `try/catch` en `mi_dia_pantalla.dart` y `paso_pantalla.dart` |
