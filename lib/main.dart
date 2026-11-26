import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

// 1) La app: solo configura MaterialApp y abre la pantalla Inicio
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Inicio(),
    );
  }
}

// 2) La pantalla principal
class Inicio extends StatelessWidget {
  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        toolbarHeight: 120,
        title: Row(
          children: [
            const Text(
              'AMAZONA',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 20),
            foto('assets/images/amazona1.jpg'),
            foto('assets/images/amazona2.jpg'),
            foto('assets/images/amazona3.png'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => quienesSomos(context),
            child: const Text('Quiénes somos'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'WELCOME!',
              style: TextStyle(fontSize: 28, color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // WIDGET NO COMÚN 5: SnackBar (mensaje temporal abajo)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('¡Gracias por visitar AMAZONA!'),
                  ),
                );
              },
              child: const Text('Saludar'),
            ),
          ],
        ),
      ),
    );
  }

  // Foto redonda
  Widget foto(String ruta) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: CircleAvatar(
        radius: 36,
        backgroundImage: AssetImage(ruta),
      ),
    );
  }

  // Recuadro reutilizable
  void ventana(BuildContext context, String titulo, Widget contenido) {
    showDialog(
      context: context,
      // WIDGET NO COMÚN 1: AlertDialog (el recuadro con texto)
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: SizedBox(
          width: 450,
          child: SingleChildScrollView(child: contenido),
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

  void quienesSomos(BuildContext context) {
    ventana(
      context,
      'Quiénes somos',
      const Text(
        'Somos una compañía que trabaja para el desarrollo humano '
        'a través de esta aplicación interactiva, donde aprendes a '
        'tomar buenas decisiones y haces que la disciplina se '
        'convierta en tu día a día sin ser abrumadora.',
      ),
    );
  }
}