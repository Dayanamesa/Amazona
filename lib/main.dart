import 'package:flutter/material.dart';

import 'pantallas/inicio_pantalla.dart';
import 'utilidades/tema_amazona.dart';

void main() {
  runApp(const AmazonaApp());
}

class AmazonaApp extends StatelessWidget {
  const AmazonaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amazona',
      debugShowCheckedModeBanner: false,
      theme: TemaAmazona.tema(),
      home: const InicioPantalla(),
    );
  }
}
