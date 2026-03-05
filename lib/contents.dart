import 'package:flutter/material.dart';

// =========================================================================
// PANTALLA DE CONTENIDOS PRINCIPAL (GRID DE MÓDULOS)
// =========================================================================
class PantallaContenidos extends StatelessWidget {
  // clase principal, sin estado, su interfaz no cambia dinamicamente
  //Backend interno, es un dicciónario de todo lo que vamos a usar
  const PantallaContenidos({super.key}); //constructor

  @override
  Widget build(BuildContext context) {
    //diccionario -
    // 1. Estructura de Datos Ampliada (Microlearning / Diapositivas)
    final List<Map<String, dynamic>> modulosHidrogeno = [
      //declaración de todos los modulos
      {
        'titulo': 'Electrólisis',
        'icono': Icons.water_drop,
        'color': Colors.blueAccent,
        'diapositivas': [
          'La electrólisis es el proceso electroquímico mediante el cual se utiliza energía eléctrica para dividir la molécula de agua (H₂O) en sus gases constituyentes: Hidrógeno (H₂) y Oxígeno (O₂).',
          'El proceso global se rige por la siguiente ecuación termodinámica:\n\n2H₂O(l) + Energía Eléctrica → 2H₂(g) + O₂(g)',
          'En un electrolizador PEM (Membrana de Intercambio Protónico), el agua reacciona en el ánodo para formar oxígeno, electrones y protones con carga positiva (H+).',
          'Los protones fluyen a través de la membrana polimérica hacia el cátodo, donde se combinan con los electrones del circuito externo para formar gas hidrógeno (H₂) de alta pureza.',
        ],
      },
      {
        'titulo': 'Pila de Combustible',
        'icono': Icons.battery_charging_full,
        'color': Colors.green,
        'diapositivas': [
          'Una pila de combustible es un dispositivo electroquímico que realiza el proceso inverso a la electrólisis: convierte la energía química del hidrógeno directamente en energía eléctrica limpia.',
          'A diferencia de una batería convencional, no se agota ni necesita recarga. Funciona de manera continua mientras se le suministre combustible (H₂) en el ánodo y un oxidante (O₂ del aire) en el cátodo.',
          'El único subproducto de esta reacción es agua pura (H₂O) y calor térmico, lo que la convierte en una tecnología de cero emisiones directas de CO₂.',
        ],
      },
      {
        'titulo': 'Almacenamiento',
        'icono': Icons.storage,
        'color': Colors.orange,
        'diapositivas': [
          'El hidrógeno es el elemento más ligero y menos denso del universo. Almacenarlo de forma compacta es uno de los mayores retos de la ingeniería actual.',
          'Método 1: Compresión Gaseosa.\nSe almacena a altas presiones, típicamente a 350 o 700 bares, utilizando tanques reforzados con fibra de carbono (Tipo IV).',
          'Método 2: Licuefacción Criogénica.\nSe enfría el gas a -253 °C para pasarlo a estado líquido, aumentando drásticamente su densidad volumétrica, pero con un alto coste energético.',
          'Método 3: Estado Sólido.\nUso de hidruros metálicos donde el hidrógeno se absorbe en la red cristalina de ciertos metales, ofreciendo gran seguridad a baja presión.',
        ],
      },
      {
        'titulo': 'Aplicaciones',
        'icono': Icons.rocket_launch,
        'color': Colors.purple,
        'diapositivas': [
          'Movilidad Pesada:\nEl hidrógeno es ideal para camiones, trenes y barcos, donde las baterías de litio son demasiado pesadas o tardan mucho en recargarse.',
          'Industria Intensiva:\nSustitución del gas natural en procesos que requieren altas temperaturas (acero, cemento) o como materia prima química (fertilizantes).',
        ],
      },
      {
        'titulo': 'Propiedades del H₂',
        'icono': Icons.science,
        'color': Colors.teal,
        'diapositivas': [
          'Propiedades Físicas:\nGas incoloro, inodoro, insípido y altamente inflamable. Su densidad energética por masa es excelente (120 MJ/kg), casi el triple que la gasolina.',
        ],
      },
      {
        'titulo': 'Transporte',
        'icono': Icons.local_shipping,
        'color': Colors.indigo,
        'diapositivas': [
          'Hidroductos:\nAdaptación de la red actual de gas natural o construcción de nuevas tuberías dedicadas exclusivamente al transporte de hidrógeno.',
          'Portadores Químicos (LOHC):\nTransporte del hidrógeno enlazado a otras moléculas como el amoníaco (NH₃) o líquidos orgánicos para facilitar su logística en barcos.',
        ],
      },
      {
        'titulo': 'Seguridad',
        'icono': Icons.security,
        'color': Colors.redAccent,
        'diapositivas': [
          'Al ser tan ligero, en caso de fuga el hidrógeno se disipa rápidamente hacia la atmósfera, reduciendo el riesgo de explosión a nivel del suelo comparado con el GLP o la gasolina.',
          'Requiere sensores específicos (como los que implementarás en tu ESP32) ya que las llamas de hidrógeno son casi invisibles a la luz del día.',
        ],
      },
      {
        'titulo': 'Impacto',
        'icono': Icons.eco,
        'color': Colors.lightGreen,
        'diapositivas': [
          'La "Gama de Colores" del hidrógeno clasifica su origen según las emisiones de su producción.',
          'Gris: A partir de gas natural (con emisiones de CO₂).\nAzul: Gas natural con captura de CO₂.\nVerde: Electrólisis con energías renovables (Cero emisiones).',
        ],
      },
    ];

    return SafeArea(
      ///envuelven la interfaz, para que los elementos del movil, no tapen la interfaz
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ), //margen simetrico horizontal y vertical para dar respiro al diseño
        child: Column(
          //elementos en columna
          crossAxisAlignment: CrossAxisAlignment
              .start, //alinea los elementos hacia la izquierda
          children: [
            const SizedBox(
              height: 10,
            ), // Margen superior para el AppBar transparente
            const Text(
              'Módulos de Conocimiento', //titulo
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white, //estilo
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
              'Selecciona un tema para aprender', //subtitulo
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 30),

            // 2. Cuadrícula dinámica
            Expanded(
              //ordena al hijo que ocupe toda la pantalla
              child: GridView.builder(
                physics:
                    const BouncingScrollPhysics(), //rebote del final del desplazamiento
                padding: const EdgeInsets.only(bottom: 100),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //configura la geometría de la cuadricula
                  crossAxisCount: 2, //dos columnas
                  crossAxisSpacing: 20, // con 20 pixeles de separación
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.9, //relacion cuadraditos
                ),
                itemCount: modulosHidrogeno
                    .length, //debido a la cantidad de modulos, crea mas o menos tarjetas
                itemBuilder: (context, index) {
                  //bucle que crea cada elemento
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

  // 3. Método para construir la tarjeta de cada módulo
  Widget _construirCarpetaModulo(
    //funcion que se llama para construir cada tarjeta
    BuildContext context,
    Map<String, dynamic> modulo,
  ) {
    return InkWell(
      onTap: () {
        // Navegamos a la pantalla estilo historia pasando los datos
        Navigator.push(
          //al pulsar añade una nueva ruta, nueva pantalla de datos
          context,
          MaterialPageRoute(
            builder: (context) => PantallaHistoriaTeoria(datosModulo: modulo),
          ),
        );
      },
      borderRadius: BorderRadius.circular(25),
      child: Container(
        //creacion del contenedor que trae la pantalla
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
          //contenidos dentro de la tarjeta
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15), //color
              decoration: BoxDecoration(
                color: modulo['color'].withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(modulo['icono'], size: 40, color: modulo['color']),
            ),
            const SizedBox(height: 15),
            Padding(
              //titulo
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

// =========================================================================
// PANTALLA TIPO HISTORIA (MICROLEARNING UI)
// =========================================================================
class PantallaHistoriaTeoria extends StatefulWidget {
  //genera el texto de dentro de las tarjetas, hereda de statefulwidget
  final Map<String, dynamic>
  datosModulo; //recibe los datos desde la pantalla anterior

  const PantallaHistoriaTeoria({super.key, required this.datosModulo});

  @override
  State<PantallaHistoriaTeoria> createState() => _PantallaHistoriaTeoriaState();
}

class _PantallaHistoriaTeoriaState extends State<PantallaHistoriaTeoria> {
  int _indiceActual = 0; //rastrea que texto mostrar
  late List<String> _diapositivas;

  @override
  void initState() {
    super.initState(); //se ejecuta al cargar la vista
    _diapositivas =
        widget.datosModulo['diapositivas'] ?? ['Contenido no disponible'];
  }

  // --- LÓGICA DE NAVEGACIÓN TÁCTIL ---
  void _siguienteDiapositiva() {
    setState(() {
      //avisa para que redibuje la pantalla
      if (_indiceActual < _diapositivas.length - 1) {
        _indiceActual++; //aumenta en uno cada vez que pulsamos a la derecha hasta que llegamos a -1
      } else {
        // Al terminar las diapositivas, cerramos la vista
        Navigator.pop(context);
      }
    });
  }

  void _anteriorDiapositiva() {
    setState(() {
      if (_indiceActual > 0) {
        _indiceActual--; //se resta en una si pulsamos a la izquierda
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //renderizado visual
    final Color colorPrincipal = widget
        .datosModulo['color']; //extrae el color asignado para meterlo en la nueva interfaz

    return Scaffold(
      backgroundColor: Colors.black, // Fondo base negro
      body: SafeArea(
        child: Stack(
          //superponer capas
          children: [
            // CAPA 1: FONDO CON DEGRADADO PARA MEJORAR LA LECTURA
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  //capa del degradado con el coloPrincipal
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorPrincipal.withValues(alpha: 0.8),
                    colorPrincipal.withValues(alpha: 0.4),
                    Colors.black87,
                  ],
                ),
              ),
            ),

            // CAPA 2: CONTENIDO VISUAL Y TEXTO
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 80.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.datosModulo['icono'], //icono
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.datosModulo['titulo'], //texto
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 50),

                  // Transición suave entre textos
                  AnimatedSwitcher(
                    //cada vez que el contenido cambia se genera una transición
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                    child: Text(
                      _diapositivas[_indiceActual], //declara el texto marcado por el indice actual, el seleccionado del array
                      key: ValueKey<int>(
                        _indiceActual,
                      ), //el key avisa de que el texto ees nuevo forzando la animación
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // CAPA 3: ZONAS TÁCTILES INVISIBLES (IZQUIERDA Y DERECHA)
            Positioned.fill(
              child: Row(
                children: [
                  // 30% izquierdo para retroceder
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      //IZQUIERDA
                      onTap: _anteriorDiapositiva,
                      behavior: HitTestBehavior.translucent,
                    ),
                  ),
                  // 70% derecho para avanzar (más cómodo para uso con una mano)
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: _siguienteDiapositiva, //DERECHA
                      behavior: HitTestBehavior.translucent,
                    ),
                  ),
                ],
              ),
            ),

            // CAPA 4: BARRA DE PROGRESO Y BOTÓN CERRAR
            Positioned(
              top: 15,
              left: 15,
              right: 15,
              child: Column(
                children: [
                  // Segmentos indicadores de progreso
                  Row(
                    children: _diapositivas.asMap().entries.map((entry) {
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 3.0,
                          ), //BARRA DE ARRIBA
                          height: 5.0,
                          decoration: BoxDecoration(
                            // Segmento blanco si está activo/pasado, gris semitransparente si falta por leer
                            color: entry.key <= _indiceActual
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 15),

                  // Botón "X" para forzar el cierre
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 32,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
