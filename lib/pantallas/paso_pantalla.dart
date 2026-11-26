import 'package:flutter/material.dart';

import '../modelos/contenido_metodo.dart';
import '../utilidades/tema_amazona.dart';

/// Pantalla 3: detalle de un paso. Si es la reflexión de la noche, muestra el formulario.
/// Al terminar, regresa a "Mi día" con Navigator.pop(context, true).
class PasoPantalla extends StatefulWidget {
  final Paso paso;
  final String nombreMomento;
  final bool yaHecho;

  const PasoPantalla({
    super.key,
    required this.paso,
    required this.nombreMomento,
    required this.yaHecho,
  });

  @override
  State<PasoPantalla> createState() => _PasoPantallaState();
}

class _PasoPantallaState extends State<PasoPantalla> {
  final _formulario = GlobalKey<FormState>();
  final _cumpliControlador = TextEditingController();
  final _costoControlador = TextEditingController();
  final _agradezcoControlador = TextEditingController();

  @override
  void dispose() {
    _cumpliControlador.dispose();
    _costoControlador.dispose();
    _agradezcoControlador.dispose();
    super.dispose();
  }

  String? _validarRespuesta(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Escribe tu respuesta, aunque sea corta.';
    }
    if (valor.trim().length < 3) {
      return 'Escribe al menos 3 letras.';
    }
    return null;
  }

  void _marcarComoHecho() {
    if (widget.paso.esReflexion) {
      final valido = _formulario.currentState!.validate();
      if (!valido) return;
      // Fase 2: aquí se guardan las tres respuestas en SQLite.
    }
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final paso = widget.paso;

    return Scaffold(
      appBar: AppBar(title: Text(widget.nombreMomento)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            paso.titulo,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              fontFamily: 'serif',
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Chip(
              avatar: const Icon(Icons.schedule, size: 16),
              label: Text(paso.duracion),
              backgroundColor: TemaAmazona.verdeClaro,
              side: BorderSide.none,
            ),
          ),
          const SizedBox(height: 16),
          Text(paso.descripcion, style: const TextStyle(fontSize: 17)),
          if (paso.instruccion != null) ...[
            const SizedBox(height: 24),
            _TarjetaInstruccion(instruccion: paso.instruccion!),
          ],
          if (paso.esReflexion) ...[
            const SizedBox(height: 24),
            _construirFormulario(),
          ],
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: _marcarComoHecho,
            icon: const Icon(Icons.check),
            label: Text(widget.yaHecho ? 'Ya lo cumplí hoy' : 'Marcar como hecho'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirFormulario() {
    return Form(
      key: _formulario,
      child: Column(
        children: [
          TextFormField(
            controller: _cumpliControlador,
            decoration: const InputDecoration(
              labelText: '¿Qué cumplí hoy?',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: TemaAmazona.blanco,
            ),
            maxLines: 2,
            validator: _validarRespuesta,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _costoControlador,
            decoration: const InputDecoration(
              labelText: '¿Qué me costó?',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: TemaAmazona.blanco,
            ),
            maxLines: 2,
            validator: _validarRespuesta,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _agradezcoControlador,
            decoration: const InputDecoration(
              labelText: '¿Qué agradezco?',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: TemaAmazona.blanco,
            ),
            maxLines: 2,
            validator: _validarRespuesta,
          ),
        ],
      ),
    );
  }
}

class _TarjetaInstruccion extends StatelessWidget {
  final String instruccion;

  const _TarjetaInstruccion({required this.instruccion});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: TemaAmazona.verde,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'INSTRUCCIÓN CONSCIENTE',
            style: TextStyle(
              color: TemaAmazona.verdeClaro,
              fontSize: 12,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Repítela mientras haces el paso: hablada, cantada o en verso.',
            style: TextStyle(color: TemaAmazona.blanco),
          ),
          const SizedBox(height: 12),
          Text(
            '“$instruccion”',
            style: const TextStyle(
              color: TemaAmazona.blanco,
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontFamily: 'serif',
            ),
          ),
        ],
      ),
    );
  }
}
