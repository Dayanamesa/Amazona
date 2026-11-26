/// Dirección de la API con el contenido del método.
///
/// Es el archivo api/metodo.json de este mismo repositorio, servido por GitHub.
/// Cambia TU_USUARIO por tu usuario de GitHub y amazona por el nombre del repositorio.
/// El repositorio debe ser público para que la app pueda leerlo.
const String urlContenido =
    'https://raw.githubusercontent.com/TU_USUARIO/amazona/main/api/metodo.json';

/// Tiempo máximo de espera de la API antes de mostrar el error.
const Duration tiempoEsperaApi = Duration(seconds: 10);
