import 'package:flutter/material.dart';

import '../modelos/contenido_metodo.dart';
import '../utilidades/tema_amazona.dart';
import 'hexagono.dart';

/// Fila de un paso dentro de "Mi día". Muestra si está hecho o bloqueado.
class TarjetaPaso extends StatelessWidget {
  final Paso paso;
  final int numero;
  final bool hecho;
  final bool bloqueado;
  final VoidCallback alTocar;

  const TarjetaPaso({
    super.key,
    required this.paso,
    required this.numero,
    required this.hecho,
    required this.bloqueado,
    required this.alTocar,
  });

  @override
  Widget build(BuildContext context) {
    final Color colorHex = bloqueado
        ? TemaAmazona.grisBorde
        : (hecho ? TemaAmazona.verdeClaro : TemaAmazona.verde);

    return Card(
      color: TemaAmazona.blanco,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: TemaAmazona.grisBorde),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        onTap: alTocar,
        leading: Hexagono(
          tamano: 38,
          color: colorHex,
          hijo: bloqueado
              ? const Icon(Icons.lock, size: 18, color: TemaAmazona.grisTexto)
              : (hecho
                  ? const Icon(Icons.check, size: 20, color: TemaAmazona.verde)
                  : Text(
                      '$numero',
                      style: const TextStyle(
                          color: TemaAmazona.blanco,
                          fontWeight: FontWeight.bold),
                    )),
        ),
        title: Text(
          paso.titulo,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: bloqueado ? TemaAmazona.grisTexto : TemaAmazona.negro,
            decoration: hecho ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(paso.duracion),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
