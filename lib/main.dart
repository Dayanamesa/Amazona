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
            foto('assets/images/amazona1.jpg', 'Norelia de Fátima',
                'Retrato en grafito'),
            foto('assets/images/amazona2.jpg', 'Gloria Idalid',
                'Retrato en carboncillo'),
            foto('assets/images/amazona3.png', 'Liliana Pérez',
                'Nuestra familia'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => quienesSomos(context),
            child: const Text('Quiénes somos'),
          ),
          TextButton(
            onPressed: () => nuestroTrabajo(context),
            child: const Text('Nuestro trabajo'),
          ),
          TextButton(
            onPressed: () => publicaciones(context),
            child: const Text('Publicaciones'),
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

  // Foto redonda con el nombre debajo
  // y una descripción que aparece al pasar el mouse
  Widget foto(String ruta, String nombre, String descripcion) {
    // WIDGET NO COMÚN 2: Tooltip
    return Tooltip(
      message: descripcion,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 36,
              backgroundImage: AssetImage(ruta),
            ),
            const SizedBox(height: 4),
            Text(
              nombre,
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  // Recuadro reutilizable para las tres secciones
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
        'Somos una compañía que busca el desarrollo tecnológico '
        'a través del liderazgo personal y empresarial.',
      ),
    );
  }

  void nuestroTrabajo(BuildContext context) {
    ventana(
      context,
      'Nuestro trabajo',
      const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ofrecemos un método de liderazgo donde cada compra se '
            'convierte en un aporte económico a diferentes fundaciones.',
          ),
          SizedBox(height: 16),
          // WIDGET NO COMÚN 3: Chip (etiquetas)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(label: Text('Grafito')),
              Chip(label: Text('Carboncillo')),
              Chip(label: Text('Retrato')),
              Chip(label: Text('Fotografía')),
            ],
          ),
        ],
      ),
    );
  }

  void publicaciones(BuildContext context) {
    ventana(
      context,
      'Publicaciones',
      const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // WIDGET NO COMÚN 4: ExpansionTile (se abre y se cierra)
          ExpansionTile(
            title: Text('Próximamente'),
            children: [
              Padding(
                padding: EdgeInsets.all(12),
                child: Text('Nuestras publicaciones las verán con el tiempo.'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}