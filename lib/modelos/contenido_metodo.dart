// Modelos de Dart que representan el JSON que llega de la API (api/metodo.json).

class Paso {
  final String id;
  final String titulo;
  final String duracion;
  final String descripcion;

  /// Instrucción consciente para repetir durante el paso. Algunos pasos no tienen.
  final String? instruccion;

  /// 'normal' o 'reflexion' (el paso de la noche que tiene formulario).
  final String tipo;

  const Paso({
    required this.id,
    required this.titulo,
    required this.duracion,
    required this.descripcion,
    required this.instruccion,
    required this.tipo,
  });

  bool get esReflexion => tipo == 'reflexion';

  factory Paso.fromJson(Map<String, dynamic> json) {
    return Paso(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      duracion: json['duracion'] as String,
      descripcion: json['descripcion'] as String,
      instruccion: json['instruccion'] as String?,
      tipo: (json['tipo'] as String?) ?? 'normal',
    );
  }
}

class Momento {
  final String id;
  final String nombre;
  final String verbo;

  /// true si el momento está disponible sin comprar el método completo.
  final bool gratis;
  final List<Paso> pasos;

  const Momento({
    required this.id,
    required this.nombre,
    required this.verbo,
    required this.gratis,
    required this.pasos,
  });

  factory Momento.fromJson(Map<String, dynamic> json) {
    final listaPasos = json['pasos'] as List<dynamic>;
    return Momento(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      verbo: json['verbo'] as String,
      gratis: json['gratis'] as bool,
      pasos: listaPasos
          .map((p) => Paso.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Etapa {
  final int numero;
  final String nombre;
  final String meses;
  final String descripcion;

  const Etapa({
    required this.numero,
    required this.nombre,
    required this.meses,
    required this.descripcion,
  });

  factory Etapa.fromJson(Map<String, dynamic> json) {
    return Etapa(
      numero: json['numero'] as int,
      nombre: json['nombre'] as String,
      meses: json['meses'] as String,
      descripcion: json['descripcion'] as String,
    );
  }
}

class ContenidoMetodo {
  final int version;
  final List<String> frases;
  final List<Etapa> etapas;
  final List<Momento> momentos;

  const ContenidoMetodo({
    required this.version,
    required this.frases,
    required this.etapas,
    required this.momentos,
  });

  factory ContenidoMetodo.fromJson(Map<String, dynamic> json) {
    return ContenidoMetodo(
      version: json['version'] as int,
      frases: (json['frases'] as List<dynamic>).cast<String>(),
      etapas: (json['etapas'] as List<dynamic>)
          .map((e) => Etapa.fromJson(e as Map<String, dynamic>))
          .toList(),
      momentos: (json['momentos'] as List<dynamic>)
          .map((m) => Momento.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Elige una frase distinta cada día del año.
  String fraseDelDia(DateTime fecha) {
    if (frases.isEmpty) return 'Hoy empiezo sin reproche.';
    final inicioDelAnio = DateTime(fecha.year, 1, 1);
    final diaDelAnio = fecha.difference(inicioDelAnio).inDays;
    return frases[diaDelAnio % frases.length];
  }

  /// Total de pasos de los momentos a los que la persona tiene acceso.
  int totalPasos({required bool metodoComprado}) {
    return momentos
        .where((m) => m.gratis || metodoComprado)
        .fold(0, (suma, m) => suma + m.pasos.length);
  }
}
