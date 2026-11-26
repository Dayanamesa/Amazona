import 'package:flutter/material.dart';

import '../modelos/contenido_metodo.dart';
import '../utilidades/tema_amazona.dart';
import '../widgets/tarjeta_paso.dart';
import 'paso_pantalla.dart';

/// Pantalla 2: los pasos del día, agrupados en mañana, tarde y noche.
class MiDiaPantalla extends StatefulWidget {
  final ContenidoMetodo contenido;
  final bool metodoComprado;

  const MiDiaPantalla({
    super.key,
    required this.contenido,
    required this.metodoComprado,
  });

  @override
  State<MiDiaPantalla> createState() => _MiDiaPantallaState();
}

class _MiDiaPantallaState extends State<MiDiaPantalla> {
  // Ids de los pasos cumplidos hoy.
  // Fase 1: solo en memoria. Fase 2: se guardan y se leen de SQLite.
  final Set<String> _pasosHechos = {};

  Future<void> _abrirPaso(Momento momento, Paso paso) async {
    final bloqueado = !momento.gratis && !widget.metodoComprado;
    if (bloqueado) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${momento.nombre} está disponible en el método completo.'),
        ),
      );
      return;
    }

    // El paso viaja a la pantalla de detalle y esta devuelve true si se cumplió.
    final cumplido = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => PasoPantalla(
          paso: paso,
          nombreMomento: momento.nombre,
          yaHecho: _pasosHechos.contains(paso.id),
        ),
      ),
    );

    if (cumplido == true) {
      setState(() {
        _pasosHechos.add(paso.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final total =
        widget.contenido.totalPasos(metodoComprado: widget.metodoComprado);
    final hechos = _pasosHechos.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Mi día')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            '$hechos de $total pasos cumplidos',
            style: const TextStyle(fontSize: 16, color: TemaAmazona.grisTexto),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: total == 0 ? 0 : hechos / total,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
            backgroundColor: TemaAmazona.grisBorde,
          ),
          const SizedBox(height: 24),
          for (final momento in widget.contenido.momentos) ...[
            _EncabezadoMomento(
              momento: momento,
              bloqueado: !momento.gratis && !widget.metodoComprado,
            ),
            const SizedBox(height: 10),
            for (var i = 0; i < momento.pasos.length; i++)
              TarjetaPaso(
                paso: momento.pasos[i],
                numero: i + 1,
                hecho: _pasosHechos.contains(momento.pasos[i].id),
                bloqueado: !momento.gratis && !widget.metodoComprado,
                alTocar: () => _abrirPaso(momento, momento.pasos[i]),
              ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }
}

class _EncabezadoMomento extends StatelessWidget {
  final Momento momento;
  final bool bloqueado;

  const _EncabezadoMomento({required this.momento, required this.bloqueado});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          momento.nombre,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'serif',
          ),
        ),
        const SizedBox(width: 10),
        Text(
          momento.verbo.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            letterSpacing: 2,
            color: TemaAmazona.verde,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        if (bloqueado)
          const Chip(
            avatar: Icon(Icons.lock, size: 16),
            label: Text('Método completo'),
          ),
      ],
    );
  }
}
