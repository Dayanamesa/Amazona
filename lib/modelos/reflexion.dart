// Modelo de la reflexión de la noche, tal como se guarda en SQLite.

class Reflexion {
  /// Fecha en formato AAAA-MM-DD. Hay una reflexión por día.
  final String fecha;
  final String cumpli;
  final String costo;
  final String agradezco;

  const Reflexion({
    required this.fecha,
    required this.cumpli,
    required this.costo,
    required this.agradezco,
  });

  /// Convierte la reflexión en un mapa para guardarla en la tabla.
  Map<String, Object?> aMapa() {
    return {
      'fecha': fecha,
      'cumpli': cumpli,
      'costo': costo,
      'agradezco': agradezco,
    };
  }

  /// Crea una reflexión a partir de una fila leída de la tabla.
  factory Reflexion.desdeMapa(Map<String, Object?> mapa) {
    return Reflexion(
      fecha: mapa['fecha'] as String,
      cumpli: mapa['cumpli'] as String,
      costo: mapa['costo'] as String,
      agradezco: mapa['agradezco'] as String,
    );
  }
}
