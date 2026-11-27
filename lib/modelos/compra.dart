// Modelo de la compra simulada del método completo, tal como se guarda en SQLite.

class Compra {
  final String fecha;
  final String nombre;
  final String correo;
  final double montoUsd;
  final double donacionUsd;
  final String fundacion;

  const Compra({
    required this.fecha,
    required this.nombre,
    required this.correo,
    required this.montoUsd,
    required this.donacionUsd,
    required this.fundacion,
  });

  Map<String, Object?> aMapa() {
    return {
      'fecha': fecha,
      'nombre': nombre,
      'correo': correo,
      'monto_usd': montoUsd,
      'donacion_usd': donacionUsd,
      'fundacion': fundacion,
    };
  }

  factory Compra.desdeMapa(Map<String, Object?> mapa) {
    return Compra(
      fecha: mapa['fecha'] as String,
      nombre: mapa['nombre'] as String,
      correo: mapa['correo'] as String,
      montoUsd: (mapa['monto_usd'] as num).toDouble(),
      donacionUsd: (mapa['donacion_usd'] as num).toDouble(),
      fundacion: mapa['fundacion'] as String,
    );
  }
}
