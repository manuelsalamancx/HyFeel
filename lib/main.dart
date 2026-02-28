import 'package:flutter/material.dart'; // importamos el conjunto de widgets visuales de google
import 'contents.dart';
import 'tests.dart';
import 'home.dart';
import 'connect.dart';

// PUNTO DE ENTRADA PRINCIPAL
void main() {
  runApp(const MiTFGApp());
}

// WIDGET RAÍZ (Configuración General)
class MiTFGApp extends StatelessWidget {
  const MiTFGApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HyFeel', // NOMBRE DE LA APLICACIÓN
      debugShowCheckedModeBanner: false,
      home: const PantallaHome(),
      theme: ThemeData(
        // Tema principal de la app
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

// ESTA ES LA CLASE QUE CONTROLA LA NAVEGACIÓN ---> Padre
class PaginaBase extends StatefulWidget {
  final int indiceInicial;

  const PaginaBase({super.key, this.indiceInicial = 0});

  @override
  State<PaginaBase> createState() => _PaginaBaseState();
}

class _PaginaBaseState extends State<PaginaBase> {
  late int _indiceActual = 0; // Puntero que controla qué pestaña está activa

  @override
  void initState() {
    super.initState();
    _indiceActual = widget.indiceInicial;
  }

  // --- FUNCIÓN PARA CAMBIAR DE PESTAÑA DESDE OTROS WIDGETS ---
  void _cambiarPestana(int indice) {
    setState(() {
      _indiceActual = indice;
    });
  }

  // Convertimos _pantallas en un 'getter' (get) para poder pasarle la función _cambiarPestana a la PantallaPrincipal
  List<Widget> get _pantallas => [
    PantallaPrincipal(
      onVerMasContenidos: () =>
          _cambiarPestana(1), // Manda al índice 1 (Contenidos)
      onVerMasTests: () => _cambiarPestana(2), // Manda al índice 2 (Tests)
    ),
    const PantallaContenidos(),
    const PantallaTests(),
    const PantallaConexion(),
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

      // El cuerpo cambia según el índice seleccionado
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
            image: DecorationImage(
              image: AssetImage(_fondos[_indiceActual]),
              fit: BoxFit.cover,
            ),
          ),
          child: _pantallas[_indiceActual],
        ),
      ),

      // La Barra Inferior
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.white.withValues(alpha: 0.2),
          labelTextStyle: const WidgetStatePropertyAll(
            TextStyle(color: Colors.white, fontSize: 12),
          ),
          iconTheme: const WidgetStatePropertyAll(
            IconThemeData(color: Colors.white70),
          ),
        ),
        child: NavigationBar(
          height: 70,
          backgroundColor: Colors.transparent,
          selectedIndex: _indiceActual,
          onDestinationSelected:
              _cambiarPestana, // Usamos la función refactorizada
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
    );
  }
}

// PANTALLA PRINCIPAL (Dashboard / Vista General)
// Ahora es un StatelessWidget porque no maneja variables de estado internas,
// solo recibe órdenes y dibuja la pantalla.
class PantallaPrincipal extends StatelessWidget {
  final VoidCallback? onVerMasContenidos;
  final VoidCallback? onVerMasTests;

  const PantallaPrincipal({
    super.key,
    this.onVerMasContenidos,
    this.onVerMasTests,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- SECCIÓN: BIENVENIDA ---
          const Text(
            "El futuro esta en tus manos.",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 13, 71, 161),
            ),
          ),
          const SizedBox(height: 20),

          // --- SECCIÓN: CONTENIDOS DIDÁCTICOS ---
          _construirCabeceraSeccion("Módulos Teóricos", onVerMasContenidos),
          Row(
            children: [
              Expanded(
                child: _construirMiniBloque(
                  Icons.science,
                  "Pilas de Combustible",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _construirMiniBloque(
                  Icons.water_drop,
                  "Electrólisis PEM",
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // --- SECCIÓN: TESTS Y EVALUACIÓN ---
          _construirCabeceraSeccion("Evaluación Continua", onVerMasTests),
          Row(
            children: [
              Expanded(
                child: _construirMiniBloque(Icons.quiz, "Test Básico H2"),
              ),
              const SizedBox(width: 10),
              Expanded(child: _construirMiniBloque(Icons.speed, "Eficiencia")),
            ],
          ),
        ],
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

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
            "Ver más >",
            style: TextStyle(color: Color.fromARGB(255, 13, 71, 161)),
          ),
        ),
      ],
    );
  }

  Widget _construirMiniBloque(IconData icono, String titulo) {
    return Card(
      color: Colors.white.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
