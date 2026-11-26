import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../modelos/contenido_metodo.dart';
import '../utilidades/config.dart';

/// Error con un mensaje que se puede mostrar directamente a la persona.
class ApiException implements Exception {
  final String mensaje;
  const ApiException(this.mensaje);

  @override
  String toString() => mensaje;
}

/// Servicio que descarga el contenido del método desde la API.
class ApiMetodo {
  final http.Client _cliente;

  ApiMetodo({http.Client? cliente}) : _cliente = cliente ?? http.Client();

  Future<ContenidoMetodo> obtenerContenido() async {
    try {
      final respuesta =
          await _cliente.get(Uri.parse(urlContenido)).timeout(tiempoEsperaApi);

      if (respuesta.statusCode != 200) {
        throw ApiException(
            'El servidor respondió con el código ${respuesta.statusCode}. Intenta de nuevo.');
      }

      // utf8.decode para que las tildes y la ñ lleguen bien.
      final datos =
          jsonDecode(utf8.decode(respuesta.bodyBytes)) as Map<String, dynamic>;
      return ContenidoMetodo.fromJson(datos);
    } on TimeoutException {
      throw const ApiException(
          'La conexión tardó demasiado. Revisa tu internet e intenta de nuevo.');
    } on SocketException {
      throw const ApiException(
          'No hay conexión a internet. Conéctate e intenta de nuevo.');
    } on http.ClientException {
      throw const ApiException(
          'No se pudo conectar con el servidor. Intenta de nuevo.');
    } on FormatException {
      throw const ApiException(
          'El contenido llegó con un formato inesperado.');
    } on TypeError {
      // Un campo del JSON no tiene el tipo que esperan los modelos.
      throw const ApiException(
          'El contenido llegó incompleto o con datos inesperados.');
    }
  }
}
