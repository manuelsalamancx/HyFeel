import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// =========================================================================
// 1. BASE DE DATOS GLOBAL DE CONTENIDOS (AGRUPADA EN 3 PARTES)
// =========================================================================
final List<Map<String, dynamic>> partesContenidoGlobal = [
  {
    'titulo_parte': 'Bloque básico: Rookie del hidrógeno',
    'modulos': [
      {
        'id': 0,
        'titulo': 'Introducción',
        'icono': Icons.water_drop,
        'color': Colors.blueAccent,
        'imagen': 'assets/home_images/electrolisis_home.png',
        'es_imagen': true,
        'diapositivas': [
          'https://raw.githubusercontent.com/manuelsalamancx/hyfeel/main/1.IntroduccionWebp/1_resultado.webp',
          'https://raw.githubusercontent.com/manuelsalamancx/hyfeel/main/1.IntroduccionWebp/2_resultado.webp',
          'https://raw.githubusercontent.com/manuelsalamancx/hyfeel/main/1.IntroduccionWebp/3_resultado.webp',
          'https://raw.githubusercontent.com/manuelsalamancx/hyfeel/main/1.IntroduccionWebp/4_resultado.webp',
          'https://raw.githubusercontent.com/manuelsalamancx/hyfeel/main/1.IntroduccionWebp/5_resultado.webp',
          'https://raw.githubusercontent.com/manuelsalamancx/hyfeel/main/1.IntroduccionWebp/6_resultado.webp',
        ],
      },
      {
        'id': 1,
        'titulo': 'Fundamentos del hidrógeno',
        'icono': Icons.science,
        'color': Colors.teal,
        'imagen': 'assets/home_images/electrolisis_home.png',
        'es_imagen': false,
        'diapositivas': [
          'Propiedades Físicas:\nGas incoloro, inodoro, insípido y altamente inflamable. Su densidad energética por masa es excelente (120 MJ/kg), casi el triple que la gasolina.',
        ],
      },
      {
        'id': 2,
        'titulo': 'El arcoirís del hidrógeno',
        'icono': Icons.looks,
        'color': Colors.teal,
        'imagen': 'assets/home_images/electrolisis_home.png',
        'es_imagen': false,
        'diapositivas': [
          'Propiedades Físicas:\nGas incoloro, inodoro, insípido y altamente inflamable. Su densidad energética por masa es excelente (120 MJ/kg), casi el triple que la gasolina.',
        ],
      },
      {
        'id': 3,
        'titulo': 'Conceptos clave de la economía del hidrógeno',
        'icono': Icons.category,
        'color': Colors.teal,
        'imagen': 'assets/home_images/electrolisis_home.png',
        'es_imagen': false,
        'diapositivas': [
          'Propiedades Físicas:\nGas incoloro, inodoro, insípido y altamente inflamable. Su densidad energética por masa es excelente (120 MJ/kg), casi el triple que la gasolina.',
        ],
      },
    ],
  },
  {
    'titulo_parte': 'Bloque industrial: Aprendiz de H₂',
    'modulos': [
      {
        'id': 4,
        'titulo': 'Electrólisis',
        'icono': Icons.dashboard,
        'color': Colors.green,
        'imagen': 'assets/home_images/toyotamirai.png',
        'es_imagen': false,
        'diapositivas': [
          'Una pila de combustible es un dispositivo electroquímico que realiza el proceso inverso a la electrólisis: convierte la energía química del hidrógeno directamente en energía eléctrica limpia.',
          'A diferencia de una batería convencional, no se agota ni necesita recarga. Funciona de manera continua mientras se le suministre combustible (H₂) en el ánodo y un oxidante (O₂ del aire) en el cátodo.',
          'El único subproducto de esta reacción es agua pura (H₂O) y calor térmico, lo que la convierte en una tecnología de cero emisiones directas de CO₂.',
        ],
      },
      {
        'id': 5,
        'titulo': 'Pilas de combustible',
        'icono': Icons.battery_5_bar,
        'color': Colors.orange,
        'imagen': 'assets/home_images/almacenamiento-de-hidrogeno.png',
        'es_imagen': false,
        'diapositivas': [
          'El hidrógeno es el elemento más ligero y menos denso del universo. Almacenarlo de forma compacta es uno de los mayores retos de la ingeniería actual.',
          'Método 1: Compresión Gaseosa.\nSe almacena a altas presiones, típicamente a 350 o 700 bares, utilizando tanques reforzados con fibra de carbono (Tipo IV).',
          'Método 2: Licuefacción Criogénica.\nSe enfría el gas a -253 °C para pasarlo a estado líquido, aumentando drásticamente su densidad volumétrica, pero con un alto coste energético.',
          'Método 3: Estado Sólido.\nUso de hidruros metálicos donde el hidrógeno se absorbe en la red cristalina de ciertos metales, ofreciendo gran seguridad a baja presión.',
        ],
      },
      {
        'id': 6,
        'titulo': 'Distribución y almacenamiento',
        'icono': Icons.local_shipping,
        'color': Colors.indigo,
        'es_imagen': false,
        'diapositivas': [
          'Hidroductos:\nAdaptación de la red actual de gas natural o construcción de nuevas tuberías dedicadas exclusivamente al transporte de hidrógeno.',
          'Portadores Químicos (LOHC):\nTransporte del hidrógeno enlazado a otras moléculas como el amoníaco (NH₃) o líquidos orgánicos para facilitar su logística en barcos.',
        ],
      },
    ],
  },
  {
    'titulo_parte': 'Bloque del mundo real',
    'modulos': [
      {
        'id': 7,
        'titulo': 'Puntos de consumo',
        'icono': Icons.data_usage,
        'color': Colors.purple,
        'imagen': 'assets/home_images/airbus_hydro.png',
        'es_imagen': false,
        'diapositivas': [
          'Movilidad Pesada:\nEl hidrógeno es ideal para camiones, trenes y barcos, donde las baterías de litio son demasiado pesadas o tardan mucho en recargarse.',
          'Industria Intensiva:\nSustitución del gas natural en procesos que requieren altas temperaturas (acero, cemento) o como materia prima química (fertilizantes).',
        ],
      },
      {
        'id': 8,
        'titulo': 'Proyectos',
        'icono': Icons.work,
        'color': Colors.redAccent,
        'imagen': 'assets/home_images/electrolisis_home.png',
        'es_imagen': false,
        'diapositivas': [
          'Al ser tan ligero, en caso de fuga el hidrógeno se disipa rápidamente hacia la atmósfera, reduciendo el riesgo de explosión a nivel del suelo comparado con el GLP o la gasolina.',
          'Requiere sensores específicos (como los que implementarás en tu ESP32) ya que las llamas de hidrógeno son casi invisibles a la luz del día.',
        ],
      },
      {
        'id': 9,
        'titulo': 'El hidrógeno y España',
        'icono': Icons.language,
        'color': Colors.lightGreen,
        'imagen': 'assets/home_images/electrolisis_home.png',
        'es_imagen': false,
        'diapositivas': [
          'La "Gama de Colores" del hidrógeno clasifica su origen según las emisiones de su producción.',
          'Gris: A partir de gas natural (con emisiones de CO₂).\nAzul: Gas natural con captura de CO₂.\nVerde: Electrólisis con energías renovables (Cero emisiones).',
        ],
      },
      {
        'id': 10,
        'titulo': 'Mitos sobre el hidrógeno',
        'icono': Icons.emoji_people,
        'color': Colors.lightGreen,
        'imagen': 'assets/home_images/electrolisis_home.png',
        'es_imagen': false,
        'diapositivas': [
          'La "Gama de Colores" del hidrógeno clasifica su origen según las emisiones de su producción.',
          'Gris: A partir de gas natural (con emisiones de CO₂).\nAzul: Gas natural con captura de CO₂.\nVerde: Electrólisis con energías renovables (Cero emisiones).',
        ],
      },
    ],
  },
];

// =========================================================================
// 2. PANTALLA DE CONTENIDOS PRINCIPAL
// =========================================================================
// =========================================================================
// 2. PANTALLA DE CONTENIDOS PRINCIPAL
// =========================================================================
class PantallaContenidos extends StatelessWidget {
  final Set<int> modulosCompletados;
  final Function(int) onModuloCompletado;

  const PantallaContenidos({
    super.key,
    required this.modulosCompletados,
    required this.onModuloCompletado,
  });

  int get _totalModulos {
    return partesContenidoGlobal.fold(
      0,
      (suma, parte) => suma + (parte['modulos'] as List).length,
    );
  }

  bool _esParteDesbloqueada(int parteIndex) {
    if (parteIndex == 0) return true;

    final parteAnterior = partesContenidoGlobal[parteIndex - 1];
    final List<Map<String, dynamic>> modulosAnteriores =
        parteAnterior['modulos'];

    return modulosAnteriores.every(
      (modulo) => modulosCompletados.contains(modulo['id']),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double progreso = _totalModulos > 0
        ? modulosCompletados.length / _totalModulos
        : 0.0;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/tu_imagen.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Módulos de Conocimiento',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF01579B),
                    shadows: [
                      Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 4.0,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // BARRA DE PROGRESO GLOBAL
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.9),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.lightBlue.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        children: [
                          Container(
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeOutCubic,
                            height: 10,
                            width: constraints.maxWidth * progreso,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF29B6F6), Color(0xFF0288D1)],
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withValues(alpha: 0.4),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 10.0),
                  child: Text(
                    '${modulosCompletados.length} de $_totalModulos completados',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // LISTADO DE PARTES EN SCROLL
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: partesContenidoGlobal.length,
                    itemBuilder: (context, parteIndex) {
                      final parte = partesContenidoGlobal[parteIndex];
                      final List<Map<String, dynamic>> modulosDeLaParte =
                          parte['modulos'];
                      bool parteDesbloqueada = _esParteDesbloqueada(parteIndex);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Cabecera Moderna del Bloque
                          _construirCabeceraBloque(
                            parte['titulo_parte'],
                            parteDesbloqueada,
                            parteIndex,
                          ),

                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                  childAspectRatio: 0.9,
                                ),
                            itemCount: modulosDeLaParte.length,
                            itemBuilder: (context, moduloIndex) {
                              return _construirCarpetaModulo(
                                context,
                                modulosDeLaParte[moduloIndex],
                                parteDesbloqueada,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // WIDGET CABECERA DE BLOQUES MODERNA
  Widget _construirCabeceraBloque(
    String titulo,
    bool parteDesbloqueada,
    int index,
  ) {
    final Color colorAcento = parteDesbloqueada
        ? const Color(0xFF01579B)
        : Colors.grey.shade600;

    return Container(
      margin: const EdgeInsets.only(top: 25.0, bottom: 15.0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: parteDesbloqueada
            ? Colors.white.withValues(alpha: 0.8)
            : Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: parteDesbloqueada
              ? const Color(0xFF0288D1).withValues(alpha: 0.25)
              : Colors.white.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: parteDesbloqueada
            ? [
                BoxShadow(
                  color: const Color(0xFF01579B).withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Row(
        children: [
          // Barra de acento vertical izquierda
          Container(
            width: 4.5,
            height: 36,
            decoration: BoxDecoration(
              color: colorAcento,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 14),

          // Textos jerarquizados
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BLOQUE 0${index + 1}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: parteDesbloqueada
                        ? const Color(0xFF0288D1)
                        : Colors.grey.shade700,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: parteDesbloqueada
                        ? const Color(0xFF01579B)
                        : Colors.black45,
                  ),
                ),
              ],
            ),
          ),

          // Icono Dinámico derecho
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: parteDesbloqueada
                  ? const Color(0xFFE1F5FE)
                  : Colors.black.withValues(alpha: 0.04),
              shape: BoxShape.circle,
            ),
            child: Icon(
              parteDesbloqueada ? Icons.bolt_rounded : Icons.lock_rounded,
              color: parteDesbloqueada
                  ? const Color(0xFF0288D1)
                  : Colors.grey.shade600,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirCarpetaModulo(
    BuildContext context,
    Map<String, dynamic> modulo,
    bool parteDesbloqueada,
  ) {
    int idModulo = modulo['id'];
    bool estaCompletado = modulosCompletados.contains(idModulo);

    return InkWell(
      onTap: !parteDesbloqueada
          ? null
          : () async {
              final resultado = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PantallaHistoriaTeoria(datosModulo: modulo),
                ),
              );

              if (resultado == true) {
                onModuloCompletado(idModulo);
              }
            },
      borderRadius: BorderRadius.circular(30),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: parteDesbloqueada ? 1.0 : 0.5,
        child: Container(
          decoration: BoxDecoration(
            color: estaCompletado
                ? Colors.white.withValues(alpha: 0.85)
                : Colors.white.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(30),
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
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Icon(
                    estaCompletado
                        ? Icons.check_circle
                        : (!parteDesbloqueada ? Icons.lock_outline : null),
                    color: estaCompletado ? Colors.green : Colors.grey,
                    size: 20,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: modulo['color'].withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(modulo['icono'], size: 40, color: modulo['color']),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  modulo['titulo'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
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
// 3. PANTALLA TIPO HISTORIA (MICROLEARNING UI)
// =========================================================================
class PantallaHistoriaTeoria extends StatefulWidget {
  final Map<String, dynamic> datosModulo;

  const PantallaHistoriaTeoria({super.key, required this.datosModulo});

  @override
  State<PantallaHistoriaTeoria> createState() => _PantallaHistoriaTeoriaState();
}

class _PantallaHistoriaTeoriaState extends State<PantallaHistoriaTeoria> {
  int _indiceActual = 0;
  late List<String> _diapositivas;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _diapositivas = List<String>.from(
      widget.datosModulo['diapositivas'] ?? ['Contenido no disponible'],
    );
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _siguienteDiapositiva() {
    if (_indiceActual < _diapositivas.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      Navigator.pop(context, true);
    }
  }

  void _anteriorDiapositiva() {
    if (_indiceActual > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color colorPrincipal = widget.datosModulo['color'];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
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
            PageView.builder(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _indiceActual = index;
                });
              },
              itemCount: _diapositivas.length,
              itemBuilder: (context, index) {
                final bool esMultimedia =
                    widget.datosModulo['es_imagen'] == true;

                if (esMultimedia) {
                  return CachedNetworkImage(
                    imageUrl: _diapositivas[index],
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 300),
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(color: colorPrincipal),
                    ),
                    errorWidget: (context, url, error) => const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_off, color: Colors.white54, size: 50),
                        SizedBox(height: 10),
                        Text(
                          'Conexión requerida para descargar el módulo',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white54),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 80.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          widget.datosModulo['icono'],
                          size: 80,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          widget.datosModulo['titulo'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 50),
                        Text(
                          _diapositivas[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            Positioned.fill(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: _anteriorDiapositiva,
                      behavior: HitTestBehavior.translucent,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: _siguienteDiapositiva,
                      behavior: HitTestBehavior.translucent,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 15,
              left: 15,
              right: 15,
              child: Column(
                children: [
                  Row(
                    children: _diapositivas.asMap().entries.map((entry) {
                      return Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 3.0),
                          height: 5.0,
                          decoration: BoxDecoration(
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 32,
                        shadows: [
                          Shadow(color: Colors.black45, blurRadius: 10),
                        ],
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
