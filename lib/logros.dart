import 'package:flutter/material.dart';

class GestorLogros {
  // Constantes basadas en tu contenido actual
  static const int totalModulos = 10;
  static const int totalTests = 6;

  static List<Map<String, dynamic>> obtenerLogros(int modulos, int tests) {
    return [
      {
        'titulo': 'Primeros pasos',
        'desc': 'Completa tu primer módulo de conocimiento.',
        'completado': modulos >= 1,
        'icono': Icons.directions_walk,
      },
      {
        'titulo': 'Quasi-investigador de H2',
        'desc': 'Completa 4 módulos de conocimiento.',
        'completado': modulos >= 4,
        'icono': Icons.search,
      },
      {
        'titulo': 'Cerebro verde',
        'desc': 'Completa 7 módulos de conocimiento.',
        'completado': modulos >= 7,
        'icono': Icons.psychology,
      },
      {
        'titulo': 'Maestro del hidrógeno',
        'desc': 'Completa el 100% de los módulos de conocimiento.',
        'completado': modulos >= totalModulos,
        'icono': Icons.workspace_premium,
      },
      {
        'titulo': 'Chispa inicial',
        'desc': 'Completa el primer test de evaluación.',
        'completado': tests >= 1,
        'icono': Icons.bolt,
      },
      {
        'titulo': 'Ingeniero Junior',
        'desc': 'Aprueba 3 tests de evaluación.',
        'completado': tests >= 3,
        'icono': Icons.engineering,
      },
      {
        'titulo': 'Mente brillante',
        'desc': 'Aprueba 5 tests de evaluación.',
        'completado': tests >= 5,
        'icono': Icons.lightbulb,
      },
      {
        'titulo': 'Ingeniero HyFeel',
        'desc': 'Aprueba el 100% de los tests de evaluación.',
        'completado': tests >= totalTests,
        'icono': Icons.grading,
      },
    ];
  }

  static int contarLogrosCompletados(int modulos, int tests) {
    return obtenerLogros(
      modulos,
      tests,
    ).where((l) => l['completado'] == true).length;
  }

  static String obtenerInsignia(int logros) {
    if (logros >= 8) return 'Ingeniero HyFeel';
    if (logros >= 6) return 'Técnico de Hidrógeno';
    if (logros >= 3) return 'Estudiante Renovable';
    return 'Novato del H2'; // Insignia por defecto
  }
}

class PantallaLogros extends StatelessWidget {
  final int modulosCompletados;
  final int testsCompletados;

  const PantallaLogros({
    super.key,
    required this.modulosCompletados,
    required this.testsCompletados,
  });

  @override
  Widget build(BuildContext context) {
    final logros = GestorLogros.obtenerLogros(
      modulosCompletados,
      testsCompletados,
    );
    final logrosConseguidos = GestorLogros.contarLogrosCompletados(
      modulosCompletados,
      testsCompletados,
    );
    final insigniaActual = GestorLogros.obtenerInsignia(logrosConseguidos);

    const colorPrimario = Color.fromARGB(255, 13, 71, 161);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Mis Logros',
          style: TextStyle(fontWeight: FontWeight.bold, color: colorPrimario),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: colorPrimario),
      ),
      body: Column(
        children: [
          // CABECERA CON LA INSIGNIA ACTUAL
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [colorPrimario, Color(0xFF4FC3F7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: colorPrimario.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.workspace_premium,
                    color: Colors.amber,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Insignia Actual',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Text(
                        insigniaActual,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '$logrosConseguidos / 8 Logros desbloqueados',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // LISTA DE LOGROS
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              physics: const BouncingScrollPhysics(),
              itemCount: logros.length,
              itemBuilder: (context, index) {
                final logro = logros[index];
                final completado = logro['completado'] as bool;

                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: completado ? Colors.white : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: completado
                          ? Colors.green.shade300
                          : Colors.transparent,
                      width: 1.5,
                    ),
                    boxShadow: completado
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: completado
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        completado ? logro['icono'] : Icons.lock,
                        color: completado ? Colors.green : Colors.grey.shade500,
                      ),
                    ),
                    title: Text(
                      logro['titulo'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: completado
                            ? Colors.black87
                            : Colors.grey.shade600,
                        decoration: completado
                            ? null
                            : TextDecoration.lineThrough,
                      ),
                    ),
                    subtitle: Text(
                      logro['desc'],
                      style: TextStyle(
                        color: completado
                            ? Colors.black54
                            : Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                    trailing: completado
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
