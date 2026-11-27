import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../modelos/reflexion.dart';

/// Servicio que guarda y lee los datos del método en SQLite (sqflite).
///
/// Tablas:
/// - pasos_cumplidos: qué pasos se cumplieron cada día.
/// - reflexiones: las tres respuestas de la noche, una por día.
///
/// Se usa una sola instancia en toda la app (BaseDatos.instancia)
/// para no abrir la base de datos varias veces.
class BaseDatos {
  BaseDatos._();
  static final BaseDatos instancia = BaseDatos._();

  static const String _nombreArchivo = 'amazona.db';
  static const int _version = 1;

  Database? _db;

  /// Devuelve la base de datos abierta. La primera vez la crea.
  Future<Database> get _baseDatos async {
    _db ??= await _abrir();
    return _db!;
  }

  Future<Database> _abrir() async {
    final carpeta = await getDatabasesPath();
    final ruta = join(carpeta, _nombreArchivo);

    return openDatabase(
      ruta,
      version: _version,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE pasos_cumplidos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fecha TEXT NOT NULL,
            paso_id TEXT NOT NULL,
            UNIQUE(fecha, paso_id)
          )
        ''');
        await db.execute('''
          CREATE TABLE reflexiones (
            fecha TEXT PRIMARY KEY,
            cumpli TEXT NOT NULL,
            costo TEXT NOT NULL,
            agradezco TEXT NOT NULL
          )
        ''');
      },
    );
  }

  /// Fecha de hoy en formato AAAA-MM-DD, por ejemplo 2026-11-27.
  static String fechaDeHoy() {
    final hoy = DateTime.now();
    final mes = hoy.month.toString().padLeft(2, '0');
    final dia = hoy.day.toString().padLeft(2, '0');
    return '${hoy.year}-$mes-$dia';
  }

  // ---------- Pasos cumplidos ----------

  /// Ids de los pasos cumplidos en una fecha.
  Future<Set<String>> pasosCumplidos(String fecha) async {
    final db = await _baseDatos;
    final filas = await db.query(
      'pasos_cumplidos',
      columns: ['paso_id'],
      where: 'fecha = ?',
      whereArgs: [fecha],
    );
    return filas.map((fila) => fila['paso_id'] as String).toSet();
  }

  /// Guarda que un paso se cumplió. Si ya estaba guardado, no lo repite.
  Future<void> marcarPaso(String fecha, String pasoId) async {
    final db = await _baseDatos;
    await db.insert(
      'pasos_cumplidos',
      {'fecha': fecha, 'paso_id': pasoId},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  /// Cuántos días distintos tienen al menos un paso cumplido (constancia).
  Future<int> diasConPasos() async {
    final db = await _baseDatos;
    final resultado = await db
        .rawQuery('SELECT COUNT(DISTINCT fecha) AS total FROM pasos_cumplidos');
    return (resultado.first['total'] as int?) ?? 0;
  }

  // ---------- Reflexiones ----------

  /// Guarda la reflexión del día. Si ya había una ese día, la reemplaza.
  Future<void> guardarReflexion(Reflexion reflexion) async {
    final db = await _baseDatos;
    await db.insert(
      'reflexiones',
      reflexion.aMapa(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Reflexión guardada en una fecha, o null si no hay.
  Future<Reflexion?> reflexionDe(String fecha) async {
    final db = await _baseDatos;
    final filas = await db.query(
      'reflexiones',
      where: 'fecha = ?',
      whereArgs: [fecha],
      limit: 1,
    );
    if (filas.isEmpty) return null;
    return Reflexion.desdeMapa(filas.first);
  }
}
