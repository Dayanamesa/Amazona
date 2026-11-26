import 'package:flutter/material.dart';

/// Hexágono del panal, el símbolo de la marca. Se reutiliza en varias pantallas.
class Hexagono extends StatelessWidget {
  final double tamano;
  final Color color;
  final Widget? hijo;

  const Hexagono({
    super.key,
    required this.tamano,
    required this.color,
    this.hijo,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _RecorteHexagono(),
      child: Container(
        width: tamano * 1.15,
        height: tamano,
        color: color,
        alignment: Alignment.center,
        child: hijo,
      ),
    );
  }
}

class _RecorteHexagono extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    return Path()
      ..moveTo(w * 0.25, 0)
      ..lineTo(w * 0.75, 0)
      ..lineTo(w, h / 2)
      ..lineTo(w * 0.75, h)
      ..lineTo(w * 0.25, h)
      ..lineTo(0, h / 2)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
