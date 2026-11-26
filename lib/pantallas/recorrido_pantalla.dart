import 'package:flutter/material.dart';

import '../modelos/contenido_metodo.dart';
import '../utilidades/tema_amazona.dart';
import '../widgets/hexagono.dart';

/// Pantalla 4: las cinco etapas del recorrido de 17 meses.
class RecorridoPantalla extends StatelessWidget {
  final List<Etapa> etapas;
  final int etapaActual;

  const RecorridoPantalla({
    super.key,
    required this.etapas,
    required this.etapaActual,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi recorrido')),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: etapas.length,
        itemBuilder: (context, indice) {
          final etapa = etapas[indice];
          final esActual = etapa.numero == etapaActual;
          final completada = etapa.numero < etapaActual;

          return Card(
            elevation: 0,
            color: esActual ? TemaAmazona.verde : TemaAmazona.blanco,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: TemaAmazona.grisBorde),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Hexagono(
                    tamano: 52,
                    color: esActual
                        ? TemaAmazona.blanco
                        : (completada
                            ? TemaAmazona.verdeClaro
                            : TemaAmazona.negro),
                    hijo: Text(
                      '${etapa.numero}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: esActual
                            ? TemaAmazona.verde
                            : (completada
                                ? TemaAmazona.verde
                                : TemaAmazona.blanco),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          etapa.meses.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                            color: esActual
                                ? TemaAmazona.verdeClaro
                                : TemaAmazona.verde,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          esActual ? '${etapa.nombre} · estás aquí' : etapa.nombre,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'serif',
                            color: esActual
                                ? TemaAmazona.blanco
                                : TemaAmazona.negro,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          etapa.descripcion,
                          style: TextStyle(
                            color: esActual
                                ? TemaAmazona.blanco
                                : TemaAmazona.grisTexto,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
