import 'package:flutter/material.dart'; //importamos el conjunto de widgets visuales de google
import 'contents.dart';
import 'tests.dart';
import 'home.dart';

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
      title: 'HyFeel', //NOMBRE DE LA APLICACIÓN
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

// ESTA ES LA NUEVA CLASE QUE CONTROLA LA NAVEGACIÓN--->Padre
class PaginaBase extends StatefulWidget {
  //define el nombre del nuevo componente y declara que la pantalla tenga estados (stateful)
  final int indiceInicial;

  const PaginaBase({super.key, this.indiceInicial = 0});

  @override
  State<PaginaBase> createState() => _PaginaBaseState(); //para ello crea un estado donde ocurra la lógica
}

//_el guión bajo indica que es privada, que solo puedo usarla en este archivo
class _PaginaBaseState extends State<PaginaBase> {
  late int _indiceActual =
      0; // es el puntero, Controla qué pestaña está activa (0 o 1)

  @override
  void initState() {
    super.initState();
    // 4. Al iniciar, le decimos que use el índice que le mandamos
    _indiceActual = widget.indiceInicial;
  }

  // Lista de las pantallas que vamos a mostrar(array), mas pantallas añadir aqui primero
  final List<Widget> _pantallas = [
    const PantallaPrincipal(), // Tu pantalla del botón (Índice 0)
    const PantallaContenidos(), // La nueva pantalla de texto (Índice 1)
    const PantallaTests(),
  ];
  final List<String> _fondos = [
    'assets/images/bg_1.png',
    'assets/images/bg_2.png',
    'assets/images/bg_3.png',
  ];

  @override //interfaz grafica, se crea con build
  Widget build(BuildContext context) {
    return Scaffold(
      //
      // La AppBar ahora está aquí arriba para que sea común
      extendBodyBehindAppBar: true,
      extendBody: true,

      appBar: AppBar(
        //se mantiene fijo aunque cambiemos de pestaña
        title: const Text(
          'HyFeel',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,

        elevation: 0,
        scrolledUnderElevation: 0, // Anula la elevación al hacer scroll
        surfaceTintColor: Colors.transparent, // Anula el tinte de Material 3
        foregroundColor: Colors.blue[900],
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),

      // El cuerpo cambia según el índice seleccionado
      // El cuerpo cambia con una transición suave
      body: AnimatedSwitcher(
        // 1. Definimos la duración de la transición (ej. 500 milisegundos)
        duration: const Duration(milliseconds: 200),

        // 2. Opcional: Especificar el tipo de animación (FadeTransition es ideal aquí)
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },

        // 3. El contenedor con el fondo y la pantalla actual
        child: Container(
          // CRÍTICO: ValueKey le indica a Flutter que este Container es diferente al anterior,
          // forzando así que se dispare la animación cuando el índice cambia.
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

          labelTextStyle: WidgetStatePropertyAll(
            const TextStyle(color: Colors.white, fontSize: 12),
          ),
          iconTheme: WidgetStatePropertyAll(
            const IconThemeData(color: Colors.white70),
          ),
        ),
        child: NavigationBar(
          height: 70,
          backgroundColor: Colors.transparent,
          selectedIndex: _indiceActual,
          onDestinationSelected: (index) {
            setState(() {
              _indiceActual = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.touch_app_outlined),
              selectedIcon: Icon(Icons.touch_app),
              label: 'Monitorización',
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
          ],
        ),
      ),
    );
  }
}

// PANTALLA PRINCIPAL (Widget con ESTADO: lo que cambia)      //LE DICE A FLUTTER, LA INTERFAZ PUEDE CAMBIAR CON EL TIEMPO
class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

// LÓGICA DEL ESTADO Y DISEÑO DE LA PANTALLA                (LOOP)//LO CUBRE todo
class _PantallaPrincipalState extends State<PantallaPrincipal> {
  // --- VARIABLES DE ESTADO (Cambian al pulsar) ---
  String estadoTexto = "Sistema Desconectado"; //linea de abajo
  bool monitorizando = false; //flag de encendido y apagado
  Color colorEstado = const Color.fromARGB(163, 7, 53, 221); //color simbolo?

  // --- FUNCIÓN DEL BOTÓN ---  LOGICA
  void cambiarEstado() {
    // setState es VITAL: actualiza el diseño tras cambiar variables.
    setState(() {
      //vuelve a ejecutar todo cuando se cambia el boton, porque esta dentro del void
      monitorizando = !monitorizando;

      if (monitorizando) {
        estadoTexto =
            "Conectado. Recibiendo datos..."; //CAMBIO DE LINEA DE ARRIBA
        colorEstado = Colors.green;
      } else {
        estadoTexto = "Desconectado. Monitorización Detenida";
        colorEstado = Colors.red;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Icono dinámico: Cambia de un sensor apagado a encendido.
          monitorizando
              ? Image.asset(
                  'assets/images/h2buttonicon.png',
                  height: 100,
                  color: colorEstado,
                )
              : Image.asset(
                  'assets/images/h2buttonicon.png',
                  height: 100,
                  color: colorEstado,
                ),

          const SizedBox(height: 30),

          const Text(
            'Estado del Enlace:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              estadoTexto,
              style: TextStyle(fontSize: 16, color: colorEstado),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 50),

          // Botón de Acción
          ElevatedButton.icon(
            onPressed: cambiarEstado, // Llama a la función
            icon: const Icon(Icons.bolt),
            label: Text(monitorizando ? "DETENER LECTURA" : "INICIAR CONEXIÓN"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            ),
          ),
        ],
      ),
    );
  }
}
