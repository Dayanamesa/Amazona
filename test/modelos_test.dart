import 'dart:convert';

import 'package:amazona/modelos/contenido_metodo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('El JSON de la API se convierte en modelos de Dart', () {
    const json = '''
    {
      "version": 1,
      "frases": ["Frase uno", "Frase dos"],
      "etapas": [
        {"numero": 1, "nombre": "Despertar", "meses": "Mes 1", "descripcion": "Solo la mañana."}
      ],
      "momentos": [
        {
          "id": "manana", "nombre": "Mañana", "verbo": "Ordenar", "gratis": true,
          "pasos": [
            {"id": "m1", "titulo": "Tender la cama", "duracion": "7 min",
             "descripcion": "Un logro pequeño.", "instruccion": null, "tipo": "normal"}
          ]
        },
        {
          "id": "noche", "nombre": "Noche", "verbo": "Cerrar en paz", "gratis": false,
          "pasos": [
            {"id": "n1", "titulo": "Reflexionar", "duracion": "10 min",
             "descripcion": "Tres preguntas.", "instruccion": null, "tipo": "reflexion"}
          ]
        }
      ]
    }
    ''';

    final contenido =
        ContenidoMetodo.fromJson(jsonDecode(json) as Map<String, dynamic>);

    expect(contenido.etapas.first.nombre, 'Despertar');
    expect(contenido.momentos.length, 2);
    expect(contenido.momentos.last.pasos.first.esReflexion, isTrue);
    expect(contenido.totalPasos(metodoComprado: false), 1);
    expect(contenido.totalPasos(metodoComprado: true), 2);
  });
}
