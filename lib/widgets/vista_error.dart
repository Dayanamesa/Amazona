import 'package:flutter/material.dart';

import '../utilidades/tema_amazona.dart';

/// Pantalla de error con botón de reintento. Se reutiliza donde se consuma la API.
class VistaError extends StatelessWidget {
  final String mensaje;
  final VoidCallback alReintentar;

  const VistaError({
    super.key,
    required this.mensaje,
    required this.alReintentar,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 56, color: TemaAmazona.grisTexto),
            const SizedBox(height: 16),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: TemaAmazona.negro),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: alReintentar,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
