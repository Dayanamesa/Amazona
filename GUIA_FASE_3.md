# Amazona · Fase 3: método completo con pago simulado

## Qué cambia

| Archivo | Nuevo o cambiado | Para qué |
|---|---|---|
| `api/metodo.json` | Cambiado | Agrega la sección `compra`: precio US$29, 15% de donación, fundación y qué incluye |
| `lib/modelos/contenido_metodo.dart` | Cambiado | Nuevo modelo `InfoCompra`, que lee la sección `compra` del JSON |
| `lib/modelos/compra.dart` | Nuevo | Modelo de la compra guardada en SQLite |
| `lib/servicios/base_datos.dart` | Cambiado | Versión 2 de la base de datos con la tabla `compras` |
| `lib/pantallas/compra_pantalla.dart` | Nuevo | Pantalla 5: precio, fundación, formulario y pago simulado |
| `lib/pantallas/inicio_pantalla.dart` | Cambiado | Botón "Método completo" y lectura de la compra al abrir la app |

No reemplaces `lib/utilidades/config.dart`.

## Valores provisionales

- Precio: **US$29**, pago único.
- Donación: **15%**, o sea **US$4,35** por compra.
- Fundación: **Hogar Madre de Dios**.

Se cambian en `api/metodo.json`. Como la app los descarga de la API, al subir el cambio a GitHub la app los muestra sin tocar el código.

## Cómo probarlo en el emulador

1. Abre la app. En Inicio aparece el botón negro **Método completo**.
2. Tócalo. Intenta pagar sin llenar nada: aparecen los errores de validación.
3. Escribe un correo sin @: aparece "Escribe un correo válido".
4. Llena bien nombre y correo, marca la casilla y toca **Pagar US$29,00 (simulado)**.
5. Espera 2 segundos: sale el mensaje de agradecimiento con la donación.
6. Al volver a Inicio, el botón cambia a **Método completo activo**.
7. Entra a **Mi día**: la tarde y la noche ya no tienen candado.
8. Abre **Reflexionar** en la noche, responde las 3 preguntas y márcala como hecha.
9. Cierra la app y vuelve a abrirla: el método sigue comprado, los pasos siguen tachados y la reflexión sigue escrita.

### Para repetir la demo desde cero

En el emulador: mantén presionado el ícono de la app → **Información de la app** → **Almacenamiento** → **Borrar datos**. Se borra la base de datos y la app vuelve a estar sin comprar.

## Commits sugeridos

```
git add api/metodo.json lib/modelos/contenido_metodo.dart
git commit -m "Agrega precio, donación y fundación a la API del método"

git add lib/modelos/compra.dart lib/servicios/base_datos.dart
git commit -m "Agrega tabla de compras a SQLite con migración a la versión 2"

git add lib/pantallas/compra_pantalla.dart lib/pantallas/inicio_pantalla.dart
git commit -m "Agrega pantalla del método completo con pago simulado"

git push
```

## Qué tienes que poder explicar

| Pregunta | Respuesta | Dónde está |
|---|---|---|
| ¿Por qué el pago es simulado? | Cobrar de verdad necesita una pasarela de pagos y temas legales fuera del alcance de la clase. No se piden datos de tarjeta | `compra_pantalla.dart` |
| ¿Qué validaciones tiene el formulario? | Nombre de al menos 3 letras, correo con formato válido y casilla de aceptación | `_validarNombre`, `_validarCorreo`, `_pagar` |
| ¿Qué es `onUpgrade`? | Si el celular ya tenía la base de datos de la versión 1, crea solo la tabla `compras` y conserva los pasos y reflexiones | `base_datos.dart` |
| ¿Cómo se calcula la donación? | `precioUsd * porcentajeDonacion / 100`, o sea 29 × 15 / 100 = 4,35 | `InfoCompra.donacionUsd` en `contenido_metodo.dart` |
| ¿Por qué el precio viene de la API? | Para cambiar precio, porcentaje o fundación sin publicar otra versión de la app | `api/metodo.json` |
| ¿Qué dato viaja entre pantallas aquí? | `InfoCompra` va de Inicio a Compra, y Compra devuelve `true` con `Navigator.pop` | `_abrirCompra` en `inicio_pantalla.dart` |
| ¿Cómo sabe la app que ya compraste? | Al abrir, busca una fila en la tabla `compras` | `_leerCompra` en `inicio_pantalla.dart` |
