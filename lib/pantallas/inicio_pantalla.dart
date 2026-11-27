import 'package:flutter/material.dart';

import '../modelos/contenido_metodo.dart';
import '../servicios/api_metodo.dart';
import '../servicios/base_datos.dart';
import '../utilidades/tema_amazona.dart';
import '../widgets/foto_redonda.dart';
import '../widgets/vista_error.dart';
import 'compra_pantalla.dart';
import 'mi_dia_pantalla.dart';
import 'recorrido_pantalla.dart';

/// Estados de la carga de la API.
enum EstadoCarga { cargando, exito, error }

/// Pantalla 1: frase del día y accesos a "Mi día" y "Mi recorrido".
class InicioPantalla extends StatefulWidget {
  const InicioPantalla({super.key});

  @override
  State<InicioPantalla> createState() => _InicioPantallaState();
}

class _InicioPantallaState extends State<InicioPantalla> {
  final ApiMetodo _api = ApiMetodo();

  EstadoCarga _estado = EstadoCarga.cargando;
  ContenidoMetodo? _contenido;
  String _mensajeError = '';

  // Se lee de SQLite: true si ya se hizo el pago simulado.
  bool _metodoComprado = false;

  @override
  void initState() {
    super.initState();
    _cargarContenido();
  }

  Future<void> _cargarContenido() async {
    setState(() {
      _estado = EstadoCarga.cargando;
    });
    try {
      final contenido = await _api.obtenerContenido();
      final comprado = await _leerCompra();
      if (!mounted) return;
      setState(() {
        _contenido = contenido;
        _metodoComprado = comprado;
        _estado = EstadoCarga.exito;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _mensajeError = e.mensaje;
        _estado = EstadoCarga.error;
      });
    }
  }

  /// Revisa en SQLite si ya se compró el método. Si falla (por ejemplo en Chrome), se asume que no.
  Future<bool> _leerCompra() async {
    try {
      final compra = await BaseDatos.instancia.obtenerCompra();
      return compra != null;
    } catch (e) {
      return false;
    }
  }

  Future<void> _abrirCompra() async {
    final comprado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => CompraPantalla(info: _contenido!.compra!),
      ),
    );
    if (comprado == true) {
      setState(() => _metodoComprado = true);
    }
  }

  void _abrirMiDia() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MiDiaPantalla(
          contenido: _contenido!,
          metodoComprado: _metodoComprado,
        ),
      ),
    );
  }

  void _abrirRecorrido() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecorridoPantalla(
          etapas: _contenido!.etapas,
          etapaActual: 1,
        ),
      ),
    );
  }

  // Tomado del borrador: el recuadro de "Quiénes somos" con AlertDialog.
  void _mostrarQuienesSomos() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quiénes somos'),
        content: const SingleChildScrollView(
          child: Text(
            'Amazona es un método de bienestar y hábitos creado por '
            'Gloria Idalid Lopera Galeano y desarrollado por Dayana Mesa Pérez. '
            'Te acompaña a organizar tu día en tres momentos, mañana, tarde '
            'y noche, para que la disciplina se vuelva parte de tu vida sin '
            'ser abrumadora.\n\n'
            'Amazona no reemplaza la ayuda psicológica o médica.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AMAZONA',
          style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            tooltip: 'Quiénes somos',
            icon: const Icon(Icons.info_outline),
            onPressed: _mostrarQuienesSomos,
          ),
        ],
      ),
      body: _construirCuerpo(),
    );
  }

  Widget _construirCuerpo() {
    switch (_estado) {
      case EstadoCarga.cargando:
        return const Center(child: CircularProgressIndicator());
      case EstadoCarga.error:
        return VistaError(
          mensaje: _mensajeError,
          alReintentar: _cargarContenido,
        );
      case EstadoCarga.exito:
        return _construirInicio(_contenido!);
    }
  }

  Widget _construirInicio(ContenidoMetodo contenido) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Tomado del borrador: las fotos redondas, ahora en el cuerpo para que quepan en el celular.
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FotoRedonda(ruta: 'assets/images/amazona1.jpg'),
            FotoRedonda(ruta: 'assets/images/amazona2.jpg'),
            FotoRedonda(ruta: 'assets/images/amazona3.png'),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Bienvenida a tu día',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontFamily: 'serif'),
        ),
        const SizedBox(height: 20),
        // Frase del día (viene de la API)
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
                'TU FRASE DE HOY',
                style: TextStyle(
                  color: TemaAmazona.verdeClaro,
                  fontSize: 12,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '“${contenido.fraseDelDia(DateTime.now())}”',
                style: const TextStyle(
                  color: TemaAmazona.blanco,
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'serif',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _BotonInicio(
          icono: Icons.wb_sunny_outlined,
          titulo: 'Mi día',
          descripcion: 'Mañana, tarde y noche',
          colorFondo: TemaAmazona.verde,
          colorTexto: TemaAmazona.blanco,
          alTocar: _abrirMiDia,
        ),
        const SizedBox(height: 12),
        _BotonInicio(
          icono: Icons.hexagon_outlined,
          titulo: 'Mi recorrido',
          descripcion: '17 meses en cinco etapas',
          colorFondo: TemaAmazona.blanco,
          colorTexto: TemaAmazona.negro,
          alTocar: _abrirRecorrido,
        ),
        // Botón del método completo (solo si la API trae los datos de compra).
        if (contenido.compra != null) ...[
          const SizedBox(height: 12),
          if (_metodoComprado)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: TemaAmazona.verdeClaro,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_outlined,
                      color: TemaAmazona.verde, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Método completo activo. Tu compra apoya al '
                      '${contenido.compra!.nombreFundacion}.',
                      style: const TextStyle(color: TemaAmazona.negro),
                    ),
                  ),
                ],
              ),
            )
          else
            _BotonInicio(
              icono: Icons.volunteer_activism_outlined,
              titulo: 'Método completo',
              descripcion:
                  'Desbloquea tarde y noche · ${contenido.compra!.porcentajeDonacion}% para la fundación',
              colorFondo: TemaAmazona.negro,
              colorTexto: TemaAmazona.blanco,
              alTocar: _abrirCompra,
            ),
        ],
      ],
    );
  }
}

/// Botón grande de la pantalla de inicio (privado porque solo se usa aquí).
class _BotonInicio extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String descripcion;
  final Color colorFondo;
  final Color colorTexto;
  final VoidCallback alTocar;

  const _BotonInicio({
    required this.icono,
    required this.titulo,
    required this.descripcion,
    required this.colorFondo,
    required this.colorTexto,
    required this.alTocar,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colorFondo,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: alTocar,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icono, color: colorTexto, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: TextStyle(
                        color: colorTexto,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(descripcion, style: TextStyle(color: colorTexto)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colorTexto),
            ],
          ),
        ),
      ),
    );
  }
}
