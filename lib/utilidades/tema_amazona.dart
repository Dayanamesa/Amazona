import 'package:flutter/material.dart';

/// Colores del plan de marca: 60% grises claros, 25% negros, 15% verdes.
class TemaAmazona {
  static const Color negro = Color(0xFF1C1C1C);
  static const Color grisFondo = Color(0xFFEDEDEB);
  static const Color grisBorde = Color(0xFFD6D6D3);
  static const Color grisTexto = Color(0xFF6B6B6B);
  static const Color verde = Color(0xFF3F5E3B);
  static const Color verdeClaro = Color(0xFFB9C9B4);
  static const Color blanco = Colors.white;

  static ThemeData tema() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: verde,
        primary: verde,
        secondary: verdeClaro,
        surface: blanco,
      ),
      scaffoldBackgroundColor: grisFondo,
      appBarTheme: const AppBarTheme(
        backgroundColor: grisFondo,
        foregroundColor: negro,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
