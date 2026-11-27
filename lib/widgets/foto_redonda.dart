import 'package:flutter/material.dart';

import '../utilidades/tema_amazona.dart';

/// Foto redonda reutilizable. Viene de la funcion foto() del primer borrador.
class FotoRedonda extends StatelessWidget {
  final String ruta;
  final double radio;

  const FotoRedonda({super.key, required this.ruta, this.radio = 32});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: CircleAvatar(
        radius: radio,
        backgroundColor: TemaAmazona.grisBorde,
        backgroundImage: AssetImage(ruta),
      ),
    );
  }
}