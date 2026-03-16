import 'package:flutter/material.dart';
import 'contents.dart';
import 'tests.dart';
import 'connect.dart';

// =========================================================================
// PUNTO DE ENTRADA PRINCIPAL
// =========================================================================
void main() {
  runApp(const MiTFGApp());
}

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
// GESTOR DE NAVEGACIÓN Y ESTADO CENTRAL
// =========================================================================
class PaginaBase extends StatefulWidget {
  final int indiceInicial;
  const PaginaBase({super.key, this.indiceInicial = 0});

  @override
  State<PaginaBase> createState() => _PaginaBaseState();
}

class _PaginaBaseState extends State<PaginaBase> {
  late int _indiceActual = 0;

  final Set<int> _modulosCompletados = {};
  final Set<int> _testsCompletados = {};

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

  void _marcarTestCompletado(int index) {
    setState(() {
      _testsCompletados.add(index);
    });
  }

  List<Widget> get _pantallas => [
    PantallaPrincipal(
      modulosCompletados: _modulosCompletados,
      onModuloCompletado: _marcarModuloCompletado,
      onIrAContenidos: () => _cambiarPestana(1),
      testsCompletados: _testsCompletados,
      onTestCompletado: _marcarTestCompletado,
      onIrATests: () => _cambiarPestana(2),
    ),
    PantallaContenidos(
      modulosCompletados: _modulosCompletados,
      onModuloCompletado: _marcarModuloCompletado,
    ),
    PantallaTests(
      testsCompletados: _testsCompletados,
      onTestCompletado: _marcarTestCompletado,
    ),
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
              // Si no tiene estas imágenes, se quedará de color sólido blueGrey
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
class PantallaPrincipal extends StatelessWidget {
  final Set<int> modulosCompletados;
  final Function(int) onModuloCompletado;
  final VoidCallback onIrAContenidos;

  final Set<int> testsCompletados;
  final Function(int) onTestCompletado;
  final VoidCallback onIrATests;

  const PantallaPrincipal({
    super.key,
    required this.modulosCompletados,
    required this.onModuloCompletado,
    required this.onIrAContenidos,
    required this.testsCompletados,
    required this.onTestCompletado,
    required this.onIrATests,
  });

  @override
  Widget build(BuildContext context) {
    const double altoCarrusel = 280.0;
    final double anchoTotalDisponible = MediaQuery.of(context).size.width - 32;
    final double anchoBurbuja = anchoTotalDisponible / 1.5;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 90),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "El futuro está en tus manos.",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Color.fromARGB(255, 13, 71, 161),
            ),
          ),
          const SizedBox(height: 30),

          // CABECERA TEORÍA
          const Text(
            "Módulos Teóricos",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),

          // CARRUSEL TEORÍA (Lee directamente de modulosHidrogenoGlobal)
          SizedBox(
            height: altoCarrusel,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 18.0, bottom: 15.0),
                  child: SizedBox(
                    width: anchoBurbuja,
                    child: index < 4
                        ? _construirBurbujaTeoria(
                            context,
                            modulosHidrogenoGlobal[index],
                            index,
                          )
                        : _construirBurbujaVerMas(onIrAContenidos, Colors.blue),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 35),

          // CABECERA TESTS
          const Text(
            "Evaluación Continua",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),

          // CARRUSEL TESTS (Lee directamente de testsHidrogeno)
          SizedBox(
            height: altoCarrusel,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: testsHidrogeno.length > 4
                  ? 5
                  : testsHidrogeno.length + 1,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 18.0, bottom: 15.0),
                  child: SizedBox(
                    width: anchoBurbuja,
                    child: index < 4 && index < testsHidrogeno.length
                        ? _construirBurbujaTest(
                            context,
                            testsHidrogeno[index],
                            index,
                          )
                        : _construirBurbujaVerMas(
                            onIrATests,
                            Colors.deepOrange,
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirBurbujaTeoria(
    BuildContext context,
    Map<String, dynamic> modulo,
    int index,
  ) {
    final bool estaCompletado = modulosCompletados.contains(index);

    // Extrae la imagen del diccionario (si no existe, usa string vacío)
    final String urlImagen = modulo['imagen'] ?? '';

    return _plantillaBurbujaUI(
      titulo: modulo['titulo'],
      icono: modulo['icono'],
      color: modulo['color'],
      estaCompletado: estaCompletado,
      urlImagen: urlImagen,
      onTap: () async {
        final resultado = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PantallaHistoriaTeoria(datosModulo: modulo),
          ),
        );
        if (resultado == true) {
          onModuloCompletado(index);
          onIrAContenidos();
        }
      },
    );
  }

  Widget _construirBurbujaTest(
    BuildContext context,
    ModuloTest modulo,
    int index,
  ) {
    final bool estaCompletado = testsCompletados.contains(index);

    // Extrae la imagen de la clase (asegúrese de haber añadido la variable en tests.dart)
    final String urlImagen = modulo.imagen;

    return _plantillaBurbujaUI(
      titulo: modulo.titulo,
      icono: modulo.icono,
      color: modulo.color,
      estaCompletado: estaCompletado,
      urlImagen: urlImagen,
      onTap: () async {
        final bool? aprobado = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PantallaCuestionario(modulo: modulo),
          ),
        );
        if (aprobado == true) {
          onTestCompletado(index);
          onIrATests();
        }
      },
    );
  }

  Widget _construirBurbujaVerMas(VoidCallback onTap, Color colorBase) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorBase.withValues(alpha: 0.7),
              colorBase.withValues(alpha: 0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: colorBase.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Ver todos\nlos módulos",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // PLANTILLA MAESTRA: MANEJO DINÁMICO DE IMÁGENES Y COLORES
  // =========================================================================
  Widget _plantillaBurbujaUI({
    required String titulo,
    required IconData icono,
    required Color color,
    required bool estaCompletado,
    required String urlImagen,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        decoration: BoxDecoration(
          // FALLBACK: Si no hay imagen, usa el color del módulo
          color: urlImagen.isEmpty ? color.withValues(alpha: 0.8) : null,
          borderRadius: BorderRadius.circular(30),
          border: estaCompletado
              ? Border.all(color: Colors.greenAccent, width: 3)
              : null,
          boxShadow: [
            BoxShadow(
              color: estaCompletado
                  ? Colors.green.withValues(alpha: 0.5)
                  : Colors.black.withValues(alpha: 0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
          // CARGA DE IMAGEN: Si el string tiene texto, carga la imagen
          image: urlImagen.isNotEmpty
              ? DecorationImage(
                  // Permite URLs web o Assets locales según empiece el texto
                  image: urlImagen.startsWith('http')
                      ? NetworkImage(urlImagen) as ImageProvider
                      : AssetImage(urlImagen),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.3), // Oscurece la imagen
                    BlendMode.darken,
                  ),
                )
              : null,
        ),
        child: Stack(
          children: [
            // DEGRADADO OSCURO INFERIOR PARA TEXTO
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 100,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.9),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // ICONO SUPERIOR
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(icono, size: 24, color: Colors.white),
                  ),
                  if (estaCompletado)
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 30,
                      ),
                    ),
                ],
              ),
            ),

            // TEXTO INFERIOR
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  titulo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.1,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 4.0,
                        color: Colors.black87,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
