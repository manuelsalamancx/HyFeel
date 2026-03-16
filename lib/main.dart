import 'package:flutter/material.dart';
import 'contents.dart'; // Importamos la UI de contenidos y la base de datos 'modulosHidrogenoGlobal'
import 'tests.dart';
import 'connect.dart';

// =========================================================================
// PUNTO DE ENTRADA PRINCIPAL
// =========================================================================
void main() {
  runApp(const MiTFGApp());
}

// =========================================================================
// CONFIGURACIÓN GENERAL PARAMETROS DE LA APP
// =========================================================================
class MiTFGApp extends StatelessWidget {
  const MiTFGApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HyFeel',
      debugShowCheckedModeBanner: false,
      home: const PaginaBase(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(119, 235, 243, 1),
        ),
        useMaterial3: true,
        fontFamily: 'MiFuenteTFG',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

// =========================================================================
// GESTOR DE NAVEGACIÓN Y ESTADO CENTRAL (LIFTING STATE UP)
// =========================================================================
class PaginaBase extends StatefulWidget {
  final int indiceInicial;
  const PaginaBase({super.key, this.indiceInicial = 0});

  @override
  State<PaginaBase> createState() => _PaginaBaseState();
}

class _PaginaBaseState extends State<PaginaBase> {
  late int _indiceActual = 0;

  // ESTADO GLOBAL: La única fuente de la verdad para el progreso del usuario
  final Set<int> _modulosCompletados = {};

  @override
  void initState() {
    super.initState();
    _indiceActual = widget.indiceInicial;
  }

  void _cambiarPestana(int indice) {
    setState(() {
      _indiceActual = indice;
    });
  }

  void _marcarModuloCompletado(int index) {
    setState(() {
      _modulosCompletados.add(index);
    });
  }

  List<Widget> get _pantallas => [
    // Pestaña 0: Home
    PantallaPrincipal(
      modulosCompletados: _modulosCompletados,
      onModuloCompletado: _marcarModuloCompletado,
      onIrAContenidos: () => _cambiarPestana(1), // Inyección de redirección
      onVerMasTests: () => _cambiarPestana(2),
    ),
    // Pestaña 1: Contenidos Completos
    PantallaContenidos(
      modulosCompletados: _modulosCompletados,
      onModuloCompletado: _marcarModuloCompletado,
    ),
    // Pestañas 2 y 3
    const PantallaTests(), // Placeholder
    const PantallaConexion(), // Placeholder
  ];

  final List<String> _fondos = [
    'assets/images/bg_1.png',
    'assets/images/bg_2.png',
    'assets/images/bg_3.png',
    'assets/images/bg_2.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        title: const Text(
          'HyFeel',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: const Color.fromARGB(255, 13, 71, 161),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: Container(
          key: ValueKey<int>(_indiceActual),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            image: DecorationImage(
              image: AssetImage(_fondos[_indiceActual]),
              fit: BoxFit.cover,
            ),
          ),
          child: _pantallas[_indiceActual],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.4),
              Colors.black.withValues(alpha: 0.8),
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: Colors.white.withValues(alpha: 0.2),
            labelTextStyle: const WidgetStatePropertyAll(
              TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            iconTheme: const WidgetStatePropertyAll(
              IconThemeData(color: Colors.white70),
            ),
          ),
          child: NavigationBar(
            height: 80,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedIndex: _indiceActual,
            onDestinationSelected: _cambiarPestana,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.touch_app_outlined),
                selectedIcon: Icon(Icons.touch_app),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.library_books_outlined),
                selectedIcon: Icon(Icons.library_books),
                label: 'Contenidos',
              ),
              NavigationDestination(
                icon: Icon(Icons.quiz_outlined),
                selectedIcon: Icon(Icons.quiz),
                label: 'Tests',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_input_antenna_outlined),
                selectedIcon: Icon(Icons.settings_input_antenna),
                label: 'Monitor',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// PANTALLA PRINCIPAL (HOME)
// =========================================================================
class PantallaPrincipal extends StatefulWidget {
  final Set<int> modulosCompletados;
  final Function(int) onModuloCompletado;
  final VoidCallback onIrAContenidos;
  final VoidCallback? onVerMasTests;

  const PantallaPrincipal({
    super.key,
    required this.modulosCompletados,
    required this.onModuloCompletado,
    required this.onIrAContenidos,
    this.onVerMasTests,
  });

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  // Estado local exclusivo para los tests (hasta que los centralice también en un futuro)
  final Set<int> _testsCompletados = {};

  final List<Map<String, dynamic>> _modulosTests = [
    {'titulo': 'Test Básico H₂', 'icono': Icons.quiz, 'color': Colors.orange},
    {'titulo': 'Eficiencia', 'icono': Icons.speed, 'color': Colors.purple},
  ];

  @override
  Widget build(BuildContext context) {
    // CÁLCULO GEOMÉTRICO: Ancho de pantalla menos los márgenes laterales (32px).
    // Dividimos entre 4.2 para mostrar 4 burbujas enteras y un 20% de la quinta para invitar al scroll.
    final double anchoTotalDisponible = MediaQuery.of(context).size.width - 32;
    final double anchoBurbuja = anchoTotalDisponible / 4.2;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 90),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "El futuro está en tus manos.",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 13, 71, 161),
            ),
          ),
          const SizedBox(height: 25),
          _construirCabeceraSeccion("Módulos Teóricos", widget.onIrAContenidos),
          const SizedBox(height: 10),

          // CARRUSEL TEORÍA (Conectado a la BD Global de contents.dart)
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: modulosHidrogenoGlobal
                  .length, // Usamos la lista de contents.dart
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0, bottom: 15.0),
                  child: SizedBox(
                    width: anchoBurbuja,
                    child: _construirBurbujaTeoria(
                      modulosHidrogenoGlobal[index],
                      index,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 35),
          _construirCabeceraSeccion(
            "Evaluación Continua",
            widget.onVerMasTests,
          ),
          const SizedBox(height: 10),

          // CARRUSEL TESTS
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _modulosTests.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0, bottom: 15.0),
                  child: SizedBox(
                    width: anchoBurbuja,
                    child: _construirBurbujaTest(_modulosTests[index], index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirCabeceraSeccion(String titulo, VoidCallback? accion) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        TextButton(
          onPressed: accion,
          child: const Text(
            "Ver todo >",
            style: TextStyle(
              color: Color.fromARGB(255, 13, 71, 161),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _construirBurbujaTeoria(Map<String, dynamic> modulo, int index) {
    final bool estaCompletado = widget.modulosCompletados.contains(index);

    return _plantillaBurbujaUI(
      modulo: modulo,
      estaCompletado: estaCompletado,
      onTap: () async {
        final resultado = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PantallaHistoriaTeoria(datosModulo: modulo),
          ),
        );
        if (resultado == true) {
          widget.onModuloCompletado(index); // Actualiza estado global
          widget.onIrAContenidos(); // Fuerzo transición a pestaña de contenidos
        }
      },
    );
  }

  Widget _construirBurbujaTest(Map<String, dynamic> modulo, int index) {
    final bool estaCompletado = _testsCompletados.contains(index);

    return _plantillaBurbujaUI(
      modulo: modulo,
      estaCompletado: estaCompletado,
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Abriendo evaluación: ${modulo['titulo']}")),
        );
        setState(() {
          _testsCompletados.add(index);
        });
      },
    );
  }

  // Refactorización de la UI de la burbuja para evitar duplicar código entre Test y Teoría
  Widget _plantillaBurbujaUI({
    required Map<String, dynamic> modulo,
    required bool estaCompletado,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: estaCompletado
              ? Colors.white.withValues(alpha: 0.85)
              : Colors.white.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(
            20,
          ), // Reducido ligeramente para acomodar 4 elementos
          border: Border.all(
            color: estaCompletado
                ? Colors.green.withValues(alpha: 0.8)
                : Colors.white.withValues(alpha: 0.9),
            width: estaCompletado ? 2.5 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: modulo['color'].withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (estaCompletado)
              const Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 16,
                  ),
                ),
              ),
            Container(
              padding: const EdgeInsets.all(
                10,
              ), // Padding reducido para optimizar espacio
              decoration: BoxDecoration(
                color: modulo['color'].withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                modulo['icono'],
                size: 28,
                color: modulo['color'],
              ), // Icono más compacto
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                modulo['titulo'],
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12, // Fuente reducida para que encaje bien
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
