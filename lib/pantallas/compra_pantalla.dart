import 'package:flutter/material.dart';

import '../modelos/compra.dart';
import '../modelos/contenido_metodo.dart';
import '../servicios/base_datos.dart';
import '../utilidades/tema_amazona.dart';
import '../widgets/hexagono.dart';

/// Pantalla 5: método completo con pago SIMULADO y aporte a la fundación.
/// No se cobra dinero real ni se piden datos de tarjeta.
/// Al terminar, regresa a Inicio con Navigator.pop(context, true).
class CompraPantalla extends StatefulWidget {
  final InfoCompra info;

  const CompraPantalla({super.key, required this.info});

  @override
  State<CompraPantalla> createState() => _CompraPantallaState();
}

class _CompraPantallaState extends State<CompraPantalla> {
  final _formulario = GlobalKey<FormState>();
  final _nombreControlador = TextEditingController();
  final _correoControlador = TextEditingController();
  bool _aceptaSimulacion = false;
  bool _procesando = false;

  @override
  void dispose() {
    _nombreControlador.dispose();
    _correoControlador.dispose();
    super.dispose();
  }

  String _dinero(double valor) => 'US\$${valor.toStringAsFixed(2)}';

  String? _validarNombre(String? valor) {
    if (valor == null || valor.trim().isEmpty) return 'Escribe tu nombre.';
    if (valor.trim().length < 3) return 'Escribe al menos 3 letras.';
    return null;
  }

  String? _validarCorreo(String? valor) {
    if (valor == null || valor.trim().isEmpty) return 'Escribe tu correo.';
    final formato = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!formato.hasMatch(valor.trim())) {
      return 'Escribe un correo válido, por ejemplo nombre@correo.com';
    }
    return null;
  }

  Future<void> _pagar() async {
    final valido = _formulario.currentState!.validate();
    if (!valido) return;
    if (!_aceptaSimulacion) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Marca la casilla para continuar.')),
      );
      return;
    }

    setState(() => _procesando = true);

    // Simula el tiempo que tarda un pago real.
    await Future.delayed(const Duration(seconds: 2));

    final info = widget.info;
    try {
      await BaseDatos.instancia.guardarCompra(
        Compra(
          fecha: BaseDatos.fechaDeHoy(),
          nombre: _nombreControlador.text.trim(),
          correo: _correoControlador.text.trim(),
          montoUsd: info.precioUsd,
          donacionUsd: info.donacionUsd,
          fundacion: info.nombreFundacion,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _procesando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo completar la compra. Intenta de nuevo.')),
      );
      return;
    }

    if (!mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('¡Gracias por ser parte de Amazona!'),
        content: Text(
          'Ya tienes el método completo: la tarde y la noche están desbloqueadas.\n\n'
          'Tu compra aporta ${_dinero(info.donacionUsd)} al ${info.nombreFundacion}.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Empezar'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final info = widget.info;

    return Scaffold(
      appBar: AppBar(title: const Text('Método completo')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Precio
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: TemaAmazona.negro,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PAGO ÚNICO',
                  style: TextStyle(
                    color: TemaAmazona.verdeClaro,
                    fontSize: 12,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _dinero(info.precioUsd),
                  style: const TextStyle(
                    color: TemaAmazona.blanco,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                for (final item in info.incluye)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check,
                            color: TemaAmazona.verdeClaro, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(item,
                              style: const TextStyle(color: TemaAmazona.blanco)),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Fundación
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: TemaAmazona.verde,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Hexagono(
                  tamano: 56,
                  color: TemaAmazona.blanco,
                  hijo: Text(
                    '${info.porcentajeDonacion}%',
                    style: const TextStyle(
                      color: TemaAmazona.verde,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_dinero(info.donacionUsd)} para el ${info.nombreFundacion}',
                        style: const TextStyle(
                          color: TemaAmazona.blanco,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        info.descripcionFundacion,
                        style: const TextStyle(color: TemaAmazona.blanco),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Formulario
          Form(
            key: _formulario,
            child: Column(
              children: [
                TextFormField(
                  controller: _nombreControlador,
                  decoration: const InputDecoration(
                    labelText: 'Tu nombre',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: TemaAmazona.blanco,
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: _validarNombre,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _correoControlador,
                  decoration: const InputDecoration(
                    labelText: 'Tu correo',
                    hintText: 'nombre@correo.com',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: TemaAmazona.blanco,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validarCorreo,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          CheckboxListTile(
            value: _aceptaSimulacion,
            onChanged: (valor) =>
                setState(() => _aceptaSimulacion = valor ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Entiendo que este pago es una simulación: no se cobra dinero real.',
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _procesando ? null : _pagar,
            icon: _procesando
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: TemaAmazona.blanco),
                  )
                : const Icon(Icons.lock_open),
            label: Text(_procesando
                ? 'Procesando pago…'
                : 'Pagar ${_dinero(info.precioUsd)} (simulado)'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}
