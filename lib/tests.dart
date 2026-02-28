import 'package:flutter/material.dart';

// PANTALLA DE TESTS (StatelessWidget para la vista general)
class PantallaTests extends StatelessWidget {
  const PantallaTests({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Estructura de Datos: Definimos los niveles de evaluación
    final List<Map<String, dynamic>> testsHidrogeno = [
      {
        'titulo': 'Nivel 1: Fundamentos del H₂',
        'descripcion': 'Conceptos básicos y propiedades químicas.',
        'icono': Icons.science,
        'color': Colors.teal,
        'preguntas': 10,
      },
      {
        'titulo': 'Nivel 2: Producción y Electrólisis',
        'descripcion':
            'Métodos de obtención y funcionamiento del electrolizador.',
        'icono': Icons.water_drop,
        'color': Colors.blueAccent,
        'preguntas': 15,
      },
      {
        'titulo': 'Nivel 3: Pilas de Combustible',
        'descripcion': 'Termodinámica y generación eléctrica inversa.',
        'icono': Icons.battery_charging_full,
        'color': Colors.green,
        'preguntas': 15,
      },
      {
        'titulo': 'Nivel 4: Almacenamiento y Seguridad',
        'descripcion': 'Normativa, compresión y riesgos operativos.',
        'icono': Icons.shield,
        'color': Colors.redAccent,
        'preguntas': 10,
      },
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10), // Espaciado para la AppBar
            // Título de la sección
            const Text(
              'Evaluación de Conocimientos',
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
              'Demuestra lo aprendido en los módulos',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 30),

            // 2. Lista Vertical de Tests (ListView.builder)
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                  bottom: 100,
                ), // Evita solapamiento con NavigationBar
                itemCount: testsHidrogeno.length,
                itemBuilder: (context, index) {
                  return _construirModuloTest(context, testsHidrogeno[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. Método para construir cada rectángulo de Test
  Widget _construirModuloTest(BuildContext context, Map<String, dynamic> test) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 15.0,
      ), // Separación vertical entre rectángulos
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Iniciando ${test['titulo']}...'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85), // Efecto translúcido
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            // Usamos Row para alinear elementos horizontalmente
            children: [
              // Icono circular a la izquierda
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: test['color'].withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(test['icono'], size: 32, color: test['color']),
              ),
              const SizedBox(width: 16),

              // Textos centrales (Título y Descripción) expandidos para ocupar el centro
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      test['titulo'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      test['descripcion'],
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Etiqueta del número de preguntas
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${test['preguntas']} preguntas',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Icono de flecha a la derecha indicando acción
              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.black38,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
