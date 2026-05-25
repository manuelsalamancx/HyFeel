import 'package:flutter/material.dart';
import 'dart:ui'; // Necesario para ImageFilter.blur

import 'package:firebase_core/firebase_core.dart'; //base de datos
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'contents.dart';
import 'tests.dart'; //pantallas
import 'connect.dart';
import 'auth.dart';
import 'terminos.dart';
import 'notificaciones.dart';
import 'onboarding_popup.dart';

// =========================================================================
// GENERACIÓN DE LISTA PLANA PARA LOS CARRUSELES DE LA PANTALLA PRINCIPAL
// =========================================================================
final List<Map<String, dynamic>> modulosHidrogenoGlobal = partesContenidoGlobal
    .expand((parte) => parte['modulos'] as List<Map<String, dynamic>>)
    .toList();

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

class _PaginaBaseState extends State<PaginaBase> with WidgetsBindingObserver {
  late int _indiceActual = 0;

  final Set<int> _modulosCompletados = {};
  final Set<int> _testsCompletados = {};

  bool _cargandoDatos = true;

  @override
  void initState() {
    super.initState();
    _indiceActual = widget.indiceInicial;
    _cargarProgresoDesdeNube();

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      verificarYMostrarOnboarding(context);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // =========================================================================
  // ANALÍTICA BLOQUE 3: CONTROL DE SESIONES Y ABANDONOS
  // =========================================================================
  @override
  // =========================================================================
  // ANALÍTICA BLOQUE 3: CONTROL DE SESIONES Y ABANDONOS
  // =========================================================================
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario == null) return; // Si no está logueado, no medimos

    // Diccionario para saber en qué pantalla estaba
    final nombresPantallas = ['Inicio', 'Teoria', 'Tests', 'Monitor_ESP32'];
    String pantallaActual = nombresPantallas[_indiceActual];

    if (state == AppLifecycleState.resumed) {
      // EL USUARIO VUELVE A ABRIR LA APP (Suma una sesión)
      FirebaseFirestore.instance
          .collection('metricas_analiticas')
          .add({
            'uid': usuario.uid,
            'tipo_evento': 'sesion_iniciada',
            'timestamp': FieldValue.serverTimestamp(),
          })
          .then((_) {
            // Absorbe el Future para que el catchError no dé problemas
          })
          .catchError((e) {
            debugPrint('Error métrica inicio sesión: $e');
          });
    } else if (state == AppLifecycleState.paused) {
      // EL USUARIO MINIMIZA O CIERRA LA APP (Punto de abandono)
      FirebaseFirestore.instance
          .collection('metricas_analiticas')
          .add({
            'uid': usuario.uid,
            'tipo_evento': 'abandono_app',
            'pantalla_salida': pantallaActual, // Oro puro para Looker Studio
            'timestamp': FieldValue.serverTimestamp(),
          })
          .then((_) {
            // Absorbe el Future para que el catchError no dé problemas
          })
          .catchError((e) {
            debugPrint('Error métrica abandono: $e');
          });
    }
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

  // =========================================================================
  // WIDGETS DEL MENÚ LATERAL (DRAWER) - REDISEÑO MODERNO
  // =========================================================================
  Widget _construirInsigniaProgreso(String valor, IconData icono) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            valor,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirElementoMenu({
    required IconData icono,
    required String texto,
    required int indice,
  }) {
    final bool seleccionado = _indiceActual == indice;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: seleccionado
            ? Colors.white
            : Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        boxShadow: seleccionado
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        leading: Icon(
          icono,
          color: seleccionado
              ? const Color.fromARGB(255, 13, 71, 161)
              : Colors.black87,
        ),
        title: Text(
          texto,
          style: TextStyle(
            color: seleccionado
                ? const Color.fromARGB(255, 13, 71, 161)
                : Colors.black87,
            fontWeight: seleccionado ? FontWeight.w900 : FontWeight.w600,
          ),
        ),
        onTap: () {
          _cambiarPestana(indice);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_cargandoDatos) {
      return const Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    final usuarioActual = FirebaseAuth.instance.currentUser;
    // Calculamos el espacio inferior seguro del dispositivo
    final paddingInferior = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      drawerScrimColor: Colors.black.withValues(alpha: 0.3),
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
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 13, 71, 161)),
      ),

      drawer: Drawer(
        backgroundColor: Colors.transparent,
        elevation: 0,
        width: MediaQuery.of(context).size.width * 0.85,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                border: Border(
                  right: BorderSide(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1.0,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('usuarios')
                        .doc(usuarioActual?.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      String nombreCompleto = 'Cargando...';
                      String email = usuarioActual?.email ?? 'Sin correo';

                      if (snapshot.hasData && snapshot.data!.exists) {
                        final datos =
                            snapshot.data!.data() as Map<String, dynamic>;
                        nombreCompleto =
                            '${datos['nombre'] ?? ''} ${datos['apellidos'] ?? ''}'
                                .trim();
                        if (nombreCompleto.isEmpty) {
                          nombreCompleto = 'Estudiante H2';
                        }
                      }

                      return Container(
                        padding: const EdgeInsets.only(
                          top: 60,
                          left: 24,
                          right: 24,
                          bottom: 24,
                        ),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 13, 71, 161),
                              Color(0xFF4FC3F7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40),
                            bottomRight: Radius.circular(40),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xFFE1F5FE),
                                child: Icon(
                                  Icons.person,
                                  size: 35,
                                  color: Color.fromARGB(255, 13, 71, 161),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              nombreCompleto,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              email,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                _construirInsigniaProgreso(
                                  _modulosCompletados.length.toString(),
                                  Icons.menu_book_rounded,
                                ),
                                const SizedBox(width: 10),
                                _construirInsigniaProgreso(
                                  _testsCompletados.length.toString(),
                                  Icons.fact_check_outlined,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  Expanded(
                    child: ListView(
                      // El padding dinámico evita que el último botón choque con los controles de navegación
                      padding: EdgeInsets.only(bottom: 20 + paddingInferior),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _construirElementoMenu(
                          icono: Icons.touch_app_outlined,
                          texto: 'Inicio',
                          indice: 0,
                        ),
                        _construirElementoMenu(
                          icono: Icons.library_books_outlined,
                          texto: 'Módulos Didácticos',
                          indice: 1,
                        ),
                        _construirElementoMenu(
                          icono: Icons.quiz_outlined,
                          texto: 'Tests de Evaluación',
                          indice: 2,
                        ),
                        _construirElementoMenu(
                          icono: Icons.settings_input_antenna_outlined,
                          texto: 'Monitorización ESP32',
                          indice: 3,
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 10,
                          ),
                          child: Divider(
                            color: Colors.black.withValues(alpha: 0.1),
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            leading: const Icon(
                              Icons.person_outline,
                              color: Colors.black87,
                            ),
                            title: const Text(
                              'Mi Perfil',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PantallaPerfil(),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            leading: const Icon(
                              Icons.settings_outlined,
                              color: Colors.black87,
                            ),
                            title: const Text(
                              'Ajustes',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PantallaAjustes(),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 10),

                        // BOTÓN CERRAR SESIÓN (AHORA DENTRO DEL LISTVIEW)
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.redAccent.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            leading: const Icon(
                              Icons.logout,
                              color: Colors.redAccent,
                            ),
                            title: const Text(
                              'Cerrar Sesión',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                              await FirebaseAuth.instance.signOut();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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

          const Text(
            "Módulos Teóricos",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),

          // CARRUSEL TEORÍA
          SizedBox(
            height: altoCarrusel,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: modulosHidrogenoGlobal.length > 4
                  ? 5
                  : modulosHidrogenoGlobal.length + 1,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 18.0, bottom: 15.0),
                  child: SizedBox(
                    width: anchoBurbuja,
                    child: index < 4 && index < modulosHidrogenoGlobal.length
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

          const Text(
            "Evaluación Continua",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),

          // CARRUSEL TESTS
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
    final int idModulo = modulo['id'] ?? index;
    final bool estaCompletado = modulosCompletados.contains(idModulo);
    final String urlImagen = modulo['imagen'] ?? '';

    return _plantillaBurbujaUI(
      titulo: modulo['titulo'] ?? 'Sin título',
      icono: modulo['icono'] ?? Icons.help_outline,
      color: modulo['color'] ?? Colors.blue,
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
          onModuloCompletado(idModulo);
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
    final bool estaBloqueado =
        index > 0 && !testsCompletados.contains(index - 1);
    final String urlImagen = modulo.imagen;

    return Opacity(
      opacity: estaBloqueado ? 0.6 : 1.0,
      child: _plantillaBurbujaUI(
        titulo: modulo.titulo,
        icono: estaBloqueado ? Icons.lock : modulo.icono,
        color: modulo.color,
        estaCompletado: estaCompletado,
        urlImagen: urlImagen,
        onTap: estaBloqueado
            ? () {
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
          image: urlImagen.isNotEmpty
              ? DecorationImage(
                  image: urlImagen.startsWith('http')
                      ? NetworkImage(urlImagen) as ImageProvider
                      : AssetImage(urlImagen),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.3),
                    BlendMode.darken,
                  ),
                )
              : null,
        ),
        child: Stack(
          children: [
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

// =========================================================================
// PANTALLAS SECUNDARIAS (PLACEHOLDERS)
// =========================================================================
// =========================================================================
// PANTALLA DE PERFIL DE USUARIO
// =========================================================================
class PantallaPerfil extends StatefulWidget {
  const PantallaPerfil({super.key});

  @override
  State<PantallaPerfil> createState() => _PantallaPerfilState();
}

class _PantallaPerfilState extends State<PantallaPerfil> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();

  bool _cargando = true;
  bool _guardando = false;
  String _emailUsuario = '';

  @override
  void initState() {
    super.initState();
    _cargarDatosPerfil();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidosController.dispose();
    super.dispose();
  }

  // Cargar datos desde Firestore
  Future<void> _cargarDatosPerfil() async {
    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario != null) {
      _emailUsuario = usuario.email ?? 'Sin correo';
      try {
        final doc = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(usuario.uid)
            .get();

        if (doc.exists) {
          final datos = doc.data()!;
          _nombreController.text = datos['nombre'] ?? '';
          _apellidosController.text = datos['apellidos'] ?? '';
        }
      } catch (e) {
        debugPrint("Error al cargar perfil: $e");
      }
    }
    if (mounted) {
      setState(() {
        _cargando = false;
      });
    }
  }

  // Guardar datos en Firestore
  Future<void> _guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _guardando = true;
      });

      final usuario = FirebaseAuth.instance.currentUser;
      if (usuario != null) {
        try {
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(usuario.uid)
              .set(
                {
                  'nombre': _nombreController.text.trim(),
                  'apellidos': _apellidosController.text.trim(),
                },
                SetOptions(merge: true),
              ); // Merge para no sobreescribir modulos/tests

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Perfil actualizado correctamente'),
                backgroundColor: Colors.green.shade600,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            );
            Navigator.pop(context); // Volver a la pantalla anterior
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error al guardar los cambios'),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      }

      if (mounted) {
        setState(() {
          _guardando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const colorPrimario = Color.fromARGB(255, 13, 71, 161);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Fondo claro
      appBar: AppBar(
        title: const Text(
          'Mi Perfil',
          style: TextStyle(fontWeight: FontWeight.bold, color: colorPrimario),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: colorPrimario),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator(color: colorPrimario))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Avatar e info básica
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundColor: Color(0xFFE1F5FE),
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: colorPrimario,
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: colorPrimario,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        _emailUsuario,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Campos del formulario
                    const Text(
                      'Datos Personales',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Campo Nombre
                    TextFormField(
                      controller: _nombreController,
                      decoration: InputDecoration(
                        labelText: 'Nombre',
                        prefixIcon: const Icon(
                          Icons.badge_outlined,
                          color: colorPrimario,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: colorPrimario,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor, introduce tu nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Campo Apellidos
                    TextFormField(
                      controller: _apellidosController,
                      decoration: InputDecoration(
                        labelText: 'Apellidos',
                        prefixIcon: const Icon(
                          Icons.people_alt_outlined,
                          color: colorPrimario,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: colorPrimario,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor, introduce tus apellidos';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),

                    // Botón Guardar
                    ElevatedButton(
                      onPressed: _guardando ? null : _guardarCambios,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorPrimario,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                      ),
                      child: _guardando
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'Guardar Cambios',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// =========================================================================
// PANTALLA DE AJUSTES
// =========================================================================
class PantallaAjustes extends StatefulWidget {
  const PantallaAjustes({super.key});

  @override
  State<PantallaAjustes> createState() => _PantallaAjustesState();
}

class _PantallaAjustesState extends State<PantallaAjustes> {
  bool _notificacionesActivas = true;
  bool _cargandoAjustes = true;

  final Color _colorPrimario = const Color.fromARGB(255, 13, 71, 161);

  @override
  void initState() {
    super.initState();
    _cargarPreferenciaNotificaciones();
  }

  // Carga el estado guardado en el teléfono
  Future<void> _cargarPreferenciaNotificaciones() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificacionesActivas = prefs.getBool('notificaciones_activas') ?? true;
      _cargandoAjustes = false;
    });
  }

  // Guarda el estado en la memoria y avisa al sistema de notificaciones
  Future<void> _cambiarPreferenciaNotificaciones(bool valor) async {
    setState(() {
      _notificacionesActivas = valor;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificaciones_activas', valor);
    // Avisamos a nuestro servicio para que gestione los topics de Firebase
    await ServicioNotificaciones.establecerEstadoNotificaciones(valor);
  }

  // =========================================================================
  // MÉTODOS DE ACCIÓN Y DIÁLOGOS DE CONFIRMACIÓN
  // =========================================================================

  Future<bool?> _mostrarDialogoConfirmacion(
    String titulo,
    String mensaje,
    Color colorPeligro,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: colorPeligro),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.black54),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPeligro,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Sí, estoy seguro'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _cambiarContrasena() async {
    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario != null && usuario.email != null) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: usuario.email!,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Se ha enviado un correo a ${usuario.email} para cambiar tu contraseña. Revisa la carpeta de spam. ',
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al enviar el correo de recuperación.'),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  Future<void> _borrarProgreso() async {
    final confirmar = await _mostrarDialogoConfirmacion(
      'Borrar Progreso',
      '¿Estás totalmente seguro de que quieres reiniciar tu progreso? Se perderán todos los módulos y tests completados. Esta acción NO se puede deshacer.',
      Colors.orange,
    );

    if (confirmar == true) {
      final usuario = FirebaseAuth.instance.currentUser;
      if (usuario != null) {
        try {
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(usuario.uid)
              .update({'modulosCompletados': [], 'testsCompletados': []});
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tu progreso ha sido reiniciado con éxito.'),
                backgroundColor: Colors.orange,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        } catch (e) {
          debugPrint("Error borrando progreso: $e");
        }
      }
    }
  }

  Future<void> _eliminarCuenta() async {
    final confirmar = await _mostrarDialogoConfirmacion(
      'Eliminar Cuenta',
      '¿Estás seguro de que deseas eliminar tu cuenta permanentemente? Se borrarán todos tus datos de HyFeel y tu acceso. Esta acción NO se puede deshacer.',
      Colors.redAccent,
    );

    if (confirmar == true) {
      final usuario = FirebaseAuth.instance.currentUser;
      if (usuario != null) {
        try {
          // 1. Guardamos el UID antes de que la cuenta desaparezca
          String uidUsuario = usuario.uid;

          // 2. Borramos su progreso de Firestore
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(uidUsuario)
              .delete();

          // 3. Eliminamos la cuenta de Auth
          await usuario.delete();
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('seenOnboarding');

          // 4. Lo mandamos al login limpiamente
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const PuertaAutenticacion(),
              ),
              (Route<dynamic> route) => false,
            );
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'requires-recent-login') {
            // AQUÍ ESTÁ LA MAGIA: En lugar de echarlo, le pedimos la contraseña
            if (mounted) {
              await _pedirContrasenaParaReautenticar(usuario);
            }
          } else {
            debugPrint("Error de Firebase Auth: ${e.message}");
          }
        } catch (e) {
          debugPrint("Error general eliminando cuenta: $e");
        }
      }
    }
  }

  // --- NUEVA FUNCIÓN AUXILIAR PARA PEDIR CONTRASEÑA ---
  Future<void> _pedirContrasenaParaReautenticar(User usuario) async {
    String contrasenaIntroducida = '';

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Autenticación necesaria',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Por motivos de seguridad, introduce tu contraseña para confirmar la eliminación de la cuenta.',
              ),
              const SizedBox(height: 15),
              TextField(
                obscureText: true, // Oculta los caracteres
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                onChanged: (valor) => contrasenaIntroducida = valor,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(), // Cancela la operación
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.black54),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                if (contrasenaIntroducida.isEmpty) return;

                try {
                  // 1. Creamos la credencial temporal con su correo y la contraseña que acaba de escribir
                  AuthCredential credencial = EmailAuthProvider.credential(
                    email: usuario.email!,
                    password: contrasenaIntroducida,
                  );

                  // 2. Refrescamos la sesión en Firebase (Reautenticar)
                  await usuario.reauthenticateWithCredential(credencial);

                  // 3. Ahora sí, Firebase nos da luz verde para destruirlo todo
                  await FirebaseFirestore.instance
                      .collection('usuarios')
                      .doc(usuario.uid)
                      .delete();
                  await usuario.delete();
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('seenOnboarding');

                  // 4. Cerramos el pop-up y lo mandamos al inicio
                  if (context.mounted) {
                    Navigator.of(context).pop(); // Cierra el diálogo
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const PuertaAutenticacion(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.of(context).pop(); // Cierra el diálogo
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Contraseña incorrecta. No se ha podido eliminar la cuenta.',
                        ),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                }
              },
              child: const Text('Eliminar cuenta'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarAcercaDe() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.info_outline, color: _colorPrimario),
              const SizedBox(width: 10),
              const Text(
                'Acerca de HyFeel',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aplicación educativa sobre tecnologías del hidrógeno',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 15),
              Text(
                'Trabajo Fin de Grado',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                'Grado en Ingeniería Electrónica, Robótica y Mecatrónica.\nUniversidad de Málaga.',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
              SizedBox(height: 15),
              Text(
                'Desarrollado por:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                'Manuel José Salamanca Tejada.',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cerrar', style: TextStyle(color: _colorPrimario)),
            ),
          ],
        );
      },
    );
  }

  Widget _construirSeccion(String titulo, List<Widget> hijos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8, top: 16),
          child: Text(
            titulo,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _colorPrimario.withValues(alpha: 0.8),
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: hijos),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          'Ajustes',
          style: TextStyle(fontWeight: FontWeight.bold, color: _colorPrimario),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: _colorPrimario),
      ),
      body: _cargandoAjustes
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              physics: const BouncingScrollPhysics(),
              children: [
                // SECCIÓN: PREFERENCIAS
                _construirSeccion('PREFERENCIAS', [
                  SwitchListTile(
                    title: const Text(
                      'Notificaciones',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: const Text(
                      'Avisos de nuevos tests y logros',
                      style: TextStyle(fontSize: 12),
                    ),
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_active_outlined,
                        color: Colors.orange,
                      ),
                    ),
                    activeThumbColor: _colorPrimario,
                    value: _notificacionesActivas,
                    onChanged: (bool valor) {
                      _cambiarPreferenciaNotificaciones(valor);
                    },
                  ),
                ]),

                const SizedBox(height: 10),

                // SECCIÓN: CUENTA Y PROGRESO
                _construirSeccion('CUENTA', [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_reset_outlined,
                        color: Colors.blue,
                      ),
                    ),
                    title: const Text(
                      'Cambiar contraseña',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: _cambiarContrasena,
                  ),
                  const Divider(height: 1, indent: 60, endIndent: 20),

                  // Nuevo botón: Borrar Progreso
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.restart_alt_outlined,
                        color: Colors.orange,
                      ),
                    ),
                    title: const Text(
                      'Borrar Progreso',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: _borrarProgreso,
                  ),
                  const Divider(height: 1, indent: 60, endIndent: 20),

                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.delete_forever_outlined,
                        color: Colors.red,
                      ),
                    ),
                    title: const Text(
                      'Eliminar cuenta',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                    onTap: _eliminarCuenta,
                  ),
                ]),

                const SizedBox(height: 10),

                // SECCIÓN: INFORMACIÓN
                _construirSeccion('INFORMACIÓN', [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.teal.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.description_outlined,
                        color: Colors.teal,
                      ),
                    ),
                    title: const Text(
                      'Términos y Privacidad',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PantallaTerminos(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 60, endIndent: 20),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.info_outline,
                        color: Colors.indigo,
                      ),
                    ),
                    title: const Text(
                      'Acerca de la app',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: _mostrarAcercaDe,
                  ),
                ]),

                const SizedBox(height: 40),
                Center(
                  child: Text(
                    'HyFeel v1.0.0',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
    );
  }
}
