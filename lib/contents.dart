import 'package:flutter/material.dart';

// PANTALLA DE CONTENIDOS
class PantallaContenidos extends StatelessWidget {
  const PantallaContenidos({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Estructura de Datos Ampliada: 8 módulos didácticos
    final List<Map<String, dynamic>> modulosHidrogeno = [
      {
        'titulo': 'Electrólisis',
        'icono': Icons.water_drop,
        'color': Colors.blueAccent,
      },
      {
        'titulo': 'Pila de Combustible',
        'icono': Icons.battery_charging_full,
        'color': Colors.green,
      },
      {
        'titulo': 'Almacenamiento',
        'icono': Icons.storage,
        'color': Colors.orange,
      },
      {
        'titulo': 'Aplicaciones',
        'icono': Icons.rocket_launch,
        'color': Colors.purple,
      },

      {
        'titulo': 'Propiedades del H₂',
        'icono': Icons.science,
        'color': Colors.teal,
      },
      {
        'titulo': 'Transporte y Logística',
        'icono': Icons.local_shipping,
        'color': Colors.indigo,
      },
      {
        'titulo': 'Seguridad y Normativa',
        'icono': Icons.security,
        'color': Colors.redAccent,
      },
      {
        'titulo': 'Impacto Ambiental',
        'icono': Icons.eco,
        'color': Colors.lightGreen,
      },
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            const Text(
              'Módulos de Conocimiento',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: Offset(0, 2),
                    blurRadius: 4.0,
                    color: Colors.black45,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Selecciona un tema para aprender',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 30),

            // 2. Cuadrícula dinámica con Scroll automático
            Expanded(
              child: GridView.builder(
                // physics: BouncingScrollPhysics() asegura un scroll fluido con rebote estilo iOS
                physics: const BouncingScrollPhysics(),
                // Padding inferior para que el último elemento no quede tapado por la NavigationBar
                padding: const EdgeInsets.only(bottom: 100),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.9,
                ),
                itemCount: modulosHidrogeno.length,
                itemBuilder: (context, index) {
                  return _construirCarpetaModulo(
                    context,
                    modulosHidrogeno[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. Método para construir la UI de cada módulo
  Widget _construirCarpetaModulo(
    BuildContext context,
    Map<String, dynamic> modulo,
  ) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Abriendo módulo: ${modulo['titulo']}...'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      borderRadius: BorderRadius.circular(25),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: modulo['color'].withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(modulo['icono'], size: 40, color: modulo['color']),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                modulo['titulo'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
