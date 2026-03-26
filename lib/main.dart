import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart'; //base de datos
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'contents.dart';
import 'tests.dart'; //pantallas
import 'connect.dart';
import 'auth.dart';

// =========================================================================
// PUNTO DE ENTRADA PRINCIPAL
// =========================================================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MiTFGApp());
}

class MiTFGApp extends StatelessWidget {
  const MiTFGApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HyFeel',
      debugShowCheckedModeBanner: false,
      home: const PuertaAutenticacion(),
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

  // Nueva variable para controlar la pantalla de carga inicial
  bool _cargandoDatos = true;

  @override
  void initState() {
    super.initState();
    _indiceActual = widget.indiceInicial;
    _cargarProgresoDesdeNube(); // 1. LECTURA: Descargamos datos al iniciar
  }

  // =========================================================================
  // LÓGICA DE BASE DE DATOS (FIRESTORE)
  // =========================================================================
  Future<void> _cargarProgresoDesdeNube() async {
    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(usuario.uid)
            .get();

        if (doc.exists) {
          final datos = doc.data()!;
          setState(() {
            // Transformamos las listas JSON de la nube a nuestros Sets locales
            _modulosCompletados.addAll(
              List<int>.from(datos['modulosCompletados'] ?? []),
            );
            _testsCompletados.addAll(
              List<int>.from(datos['testsCompletados'] ?? []),
            );
          });
        }
      } catch (e) {
        debugPrint("Error al cargar datos: $e");
      }
    }
    // Quitamos la pantalla de carga sin importar si hubo error o no
    if (mounted) {
      setState(() {
        _cargandoDatos = false;
      });
    }
  }

  void _cambiarPestana(int indice) {
    setState(() {
      _indiceActual = indice;
    });
  }

  // 2. ESCRITURA: Actualizamos la nube al completar un módulo
  void _marcarModuloCompletado(int index) async {
    setState(() {
      _modulosCompletados.add(index);
    });

    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario != null) {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(usuario.uid)
          .update({'modulosCompletados': _modulosCompletados.toList()});
    }
  }

  // 3. ESCRITURA: Actualizamos la nube al completar un test
  void _marcarTestCompletado(int index) async {
    setState(() {
      _testsCompletados.add(index);
    });

    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario != null) {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(usuario.uid)
          .update({'testsCompletados': _testsCompletados.toList()});
    }
  }

  // (Mantenemos tus getters _pantallas y _fondos exactamente igual)
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
    // Si aún está descargando datos, mostramos una pantalla de carga para evitar desincronización
    if (_cargandoDatos) {
      return const Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

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
        actions: [
          // Botón opcional para cerrar sesión y probar con otros usuarios
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      // ... EL RESTO DE TU MÉTODO BUILD SE MANTIENE INTACTO (body, bottomNavigationBar, etc.)
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
      // ... (bottomNavigationBar sigue igual)
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

    // Lógica secuencial: bloqueado si no es el primero y el anterior no está aprobado
    final bool estaBloqueado =
        index > 0 && !testsCompletados.contains(index - 1);

    // Extrae la imagen original de la clase para no perder la estética
    final String urlImagen = modulo.imagen;

    // Envolvemos la plantilla en Opacity para aplicar el "filtro" visual de bloqueo
    return Opacity(
      opacity: estaBloqueado ? 0.6 : 1.0,
      child: _plantillaBurbujaUI(
        titulo: modulo.titulo,
        // Si está bloqueado, mostramos el candado; si no, el icono de la temática
        icono: estaBloqueado ? Icons.lock : modulo.icono,
        color: modulo.color, // Mantenemos su color base original
        estaCompletado: estaCompletado,
        urlImagen: urlImagen, // Mantenemos su imagen de fondo original
        onTap: estaBloqueado
            ? () {
                // Interceptamos el toque si está bloqueado para mostrar el aviso
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      '🔒 Debes aprobar el nivel anterior para desbloquear este test.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.blueGrey[800],
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                );
              }
            : () async {
                // Flujo normal de ejecución si está desbloqueado
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
      ),
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
