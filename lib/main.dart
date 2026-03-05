import 'package:flutter/material.dart'; // importamos el conjunto de widgets visuales de google
import 'contents.dart';
import 'tests.dart';
import 'home.dart';
import 'connect.dart';

// PUNTO DE ENTRADA PRINCIPAL
void main() {
  runApp(const MiTFGApp());
}

// CONFIGURACION GENERAL PARAMETROS DE LA APP
class MiTFGApp extends StatelessWidget {
  //statelesswidget define la clase y no mutara por si misma
  const MiTFGApp({
    super.key,
  }); //constructor de la clase -> usara keys para la identificación del widget en el arbol

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HyFeel', // NOMBRE DE LA APLICACIÓN
      debugShowCheckedModeBanner: false,
      home: const PantallaHome(), // deberia de ser home: const PaginaBase()
      theme: ThemeData(
        // Tema principal de la app -> COLOR DEL TEMA
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(119, 235, 243, 1),
        ),
        useMaterial3: true, //estilo UI
        fontFamily: 'MiFuenteTFG', //FUENTE
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

// ESTA ES LA CLASE QUE CONTROLA LA NAVEGACIÓN ---> Padre -> EL INDICE NOS DICE A QUE PESTAÑA IRNOS, EN ESTE CASO LA CERO QUE ES LA PRINCIPAL
class PaginaBase extends StatefulWidget {
  //statefulwidget - puede cambiar
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
    //notifica al framework que el estado ha cambiado y se guarda en indice.
    setState(() {
      _indiceActual = indice; //para luego ser pasado a indice
    });
  }

  // Convertimos _pantallas en un 'getter' (get) para poder pasarle la función _cambiarPestana a la PantallaPrincipal
  List<Widget> get _pantallas => [
    //el getter nos permite cambiar las pestagnas dentro de la pantalla
    PantallaPrincipal(
      //botones de ver mas y redirigir a otras pestañas
      onVerMasContenidos: () =>
          _cambiarPestana(1), // Manda al índice 1 (Contenidos)
      onVerMasTests: () => _cambiarPestana(2), // Manda al índice 2 (Tests)
    ),
    const PantallaContenidos(),
    const PantallaTests(),
    const PantallaConexion(),
  ];

  final List<String> _fondos = [
    //diccionario fondos
    //fondos
    'assets/images/bg_1.png',
    'assets/images/bg_2.png',
    'assets/images/bg_3.png',
    'assets/images/bg_2.png',
  ];

  @override
  Widget build(BuildContext context) {
    //RENDERIZADO DEL GESTOR // BUILD DE PAGINA BASE
    return Scaffold(
      //retorna la estructura básica de diseño de la pagína
      extendBodyBehindAppBar:
          true, //permite que el fondo ocupe toda la pantalla (behindappbar) incluso por debajo de la appbar
      extendBody: true, //por toda la pantalla

      appBar: AppBar(
        //define la barra superior transparente
        title: const Text(
          'HyFeel',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true, //estilo
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: const Color.fromARGB(255, 13, 71, 161),
      ),

      // El cuerpo cambia según el índice seleccionado
      body: AnimatedSwitcher(
        //cuerpo que genera una transición suave cuando el contenido cambia de pestaña
        duration: const Duration(milliseconds: 200), //duración de la transición
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          ); //fadetransition -> suavidad
        },
        child: Container(
          //contenedor principal
          key: ValueKey<int>(_indiceActual),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                _fondos[_indiceActual],
              ), //pilla la foto elegida segun el indice actual
              fit: BoxFit.cover,
            ),
          ),
          child:
              _pantallas[_indiceActual], //renderiza la pantalla escogida por el usuario
        ),
      ),

      // La Barra Inferior
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          //info general sobre los datos del texto e icono
          indicatorColor: Colors.white.withValues(alpha: 0.2),
          labelTextStyle: const WidgetStatePropertyAll(
            TextStyle(color: Colors.white, fontSize: 12),
          ),
          iconTheme: const WidgetStatePropertyAll(
            IconThemeData(color: Colors.white70),
          ),
        ),
        child: NavigationBar(
          //define los iconos y los textos
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

// no maneja variables de estado internas, por eso es statlesswidget, es un mandao
class PantallaPrincipal extends StatelessWidget {
  // PANEL DE CONTROl - recibe ordenes y dibuja la pantalla
  final VoidCallback?
  onVerMasContenidos; //declaración de punteros, si se les llama ejecuta el codigo del padre (PaginaBase)
  final VoidCallback? onVerMasTests;

  const PantallaPrincipal({
    //config llamadas
    super.key,
    this.onVerMasContenidos,
    this.onVerMasTests,
  });

  @override
  Widget build(BuildContext context) {
    //construcción general
    return SingleChildScrollView(
      //si se excede el tamagno de pantalla scroll
      padding: const EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 90),
      child: Column(
        //hijos en una transición vertical
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- SECCIÓN: BIENVENIDA ---
          const Text(
            //texto de inicio
            "El futuro esta en tus manos.",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 13, 71, 161),
            ),
          ),
          const SizedBox(height: 20),

          // --- SECCIÓN: CONTENIDOS DIDÁCTICOS --- llama a funciones de abajo
          _construirCabeceraSeccion("Módulos Teóricos", onVerMasContenidos),
          Row(
            //fila horizontal
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
    //cabecera
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
            "Más contenido...",
            style: TextStyle(color: Color.fromARGB(255, 13, 71, 161)),
          ),
        ),
      ],
    );
  }

  Widget _construirMiniBloque(IconData icono, String titulo) {
    //minibloques de selecciónado
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
