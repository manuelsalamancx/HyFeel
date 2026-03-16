import 'package:flutter/material.dart';
import 'dart:async';

// ============================================================================
// 1. MODELOS DE DATOS Y BASE DE DATOS GLOBAL
// ============================================================================

class Pregunta {
  final String texto;
  final List<String> opciones;
  final int indiceCorrecto;
  final String explicacion;

  Pregunta({
    required this.texto,
    required this.opciones,
    required this.indiceCorrecto,
    required this.explicacion,
  });
}

class ModuloTest {
  final String titulo;
  final String descripcion;
  final IconData icono;
  final String imagen; // meter cuando haya imagenes para los tests
  final Color color;
  final List<Pregunta> preguntas;

  ModuloTest({
    required this.titulo,
    required this.descripcion,
    required this.icono,
    required this.color,
    required this.imagen,
    required this.preguntas,
  });
}

// Base de datos local (Global)
final List<ModuloTest> testsHidrogeno = [
  // ... (He mantenido intactas todas sus preguntas y módulos)
  ModuloTest(
    titulo: 'Nivel 1: Fundamentos del H₂',
    descripcion: 'Conceptos básicos y propiedades químicas.',
    icono: Icons.science,
    color: Colors.teal,
    imagen: ' ',
    preguntas: [
      Pregunta(
        texto: '¿Cuál es el número atómico del hidrógeno?',
        opciones: ['1', '2', '4', '8'],
        indiceCorrecto: 0,
        explicacion:
            'El hidrógeno es el primer elemento de la tabla periódica...',
      ),
      Pregunta(
        texto:
            '¿En qué estado se encuentra el hidrógeno puro a temperatura ambiente?',
        opciones: ['Líquido', 'Sólido', 'Plasma', 'Gas'],
        indiceCorrecto: 3,
        explicacion:
            'A temperatura y presión estándar, el H₂ es un gas diatómico...',
      ),
      Pregunta(
        texto: 'Comparado con el aire, la densidad del hidrógeno es:',
        opciones: ['Igual', 'Ligeramente mayor', 'Mucho menor', 'Mucho mayor'],
        indiceCorrecto: 2,
        explicacion:
            'El hidrógeno es aproximadamente 14 veces más ligero que el aire...',
      ),
      Pregunta(
        texto:
            '¿Cuál es el poder calorífico másico del H₂ frente a los combustibles fósiles?',
        opciones: [
          'Menor',
          'Igual',
          'Aproximadamente el doble o triple',
          'Diez veces mayor',
        ],
        indiceCorrecto: 2,
        explicacion:
            'El H₂ tiene una densidad energética gravimétrica muy alta...',
      ),
      Pregunta(
        texto: '¿Cuáles son los isótopos naturales del hidrógeno?',
        opciones: [
          'Protio, Deuterio, Tritio',
          'Alfa, Beta, Gamma',
          'Helio-3, Helio-4',
          'Uranio, Plutonio',
        ],
        indiceCorrecto: 0,
        explicacion: 'El protio es el más abundante...',
      ),
      Pregunta(
        texto:
            '¿Es el hidrógeno abundante en forma molecular (H₂) en la Tierra?',
        opciones: [
          'Sí, en la atmósfera',
          'Sí, en el subsuelo',
          'No, se encuentra en compuestos',
          'Sí, en los océanos',
        ],
        indiceCorrecto: 2,
        explicacion: 'El hidrógeno reacciona fácilmente...',
      ),
      Pregunta(
        texto:
            '¿De qué color es la llama del hidrógeno al quemarse en aire limpio?',
        opciones: [
          'Amarillo intenso',
          'Rojo',
          'Verde',
          'Azul pálido (casi invisible)',
        ],
        indiceCorrecto: 3,
        explicacion: 'La combustión del H₂ produce una llama azul muy tenue...',
      ),
      Pregunta(
        texto: '¿Cuál es la solubilidad del hidrógeno en agua?',
        opciones: ['Muy alta', 'Moderada', 'Baja', 'Insoluble'],
        indiceCorrecto: 2,
        explicacion: 'El hidrógeno gas tiene una solubilidad muy baja...',
      ),
    ],
  ),
  ModuloTest(
    titulo: 'Nivel 2: Producción y Electrólisis',
    descripcion: 'Métodos de obtención y funcionamiento del electrolizador.',
    icono: Icons.water_drop,
    color: Colors.blueAccent,
    imagen: ' ',
    preguntas: [
      Pregunta(
        texto:
            '¿Qué color de hidrógeno se asocia a la electrólisis con energía renovable?',
        opciones: ['Gris', 'Azul', 'Verde', 'Rosa'],
        indiceCorrecto: 2,
        explicacion: 'El "hidrógeno verde" garantiza que no hay emisiones...',
      ),
      Pregunta(
        texto: 'En una celda de electrólisis PEM, ¿qué se genera en el cátodo?',
        opciones: ['Oxígeno', 'Hidrógeno', 'Agua', 'Ozono'],
        indiceCorrecto: 1,
        explicacion:
            'Los protones (H⁺) atraviesan la membrana hacia el cátodo...',
      ),
      Pregunta(
        texto: '¿Qué diferencia al hidrógeno azul del gris?',
        opciones: [
          'Usa agua marina',
          'Captura y almacena el CO₂',
          'Usa energía nuclear',
          'Usa biomasa',
        ],
        indiceCorrecto: 1,
        explicacion:
            'Ambos provienen del reformado de gas natural, pero en el azul se aplican tecnologías CCUS...',
      ),
      Pregunta(
        texto:
            '¿Cuál es el electrolito en un electrolizador alcalino convencional?',
        opciones: [
          'Membrana polimérica',
          'Solución acuosa de KOH o NaOH',
          'Óxido cerámico',
          'Ácido sulfúrico',
        ],
        indiceCorrecto: 1,
        explicacion: 'Utilizan hidróxido de potasio (KOH) o sodio (NaOH)...',
      ),
      Pregunta(
        texto:
            '¿Qué ventaja principal tienen los electrolizadores PEM frente a los alcalinos?',
        opciones: [
          'Son más baratos',
          'Respuesta más rápida a variaciones de carga',
          'No usan catalizadores nobles',
          'Mayor vida útil',
        ],
        indiceCorrecto: 1,
        explicacion:
            'La tecnología PEM se acopla mejor a la intermitencia de energías renovables...',
      ),
      Pregunta(
        texto:
            'En la ecuación global de electrólisis del agua, ¿cuál es el subproducto?',
        opciones: ['Dióxido de carbono', 'Metano', 'Oxígeno', 'Nitrógeno'],
        indiceCorrecto: 2,
        explicacion:
            'La separación de H₂O genera H₂ y O₂. El oxígeno es el subproducto...',
      ),
      Pregunta(
        texto:
            '¿Cuál es el método actual mayoritario de producción de H₂ a nivel mundial?',
        opciones: [
          'Electrólisis',
          'Reformado de metano con vapor (SMR)',
          'Gasificación del carbón',
          'Termólisis solar',
        ],
        indiceCorrecto: 1,
        explicacion: 'El SMR es la técnica más madura y económica...',
      ),
      Pregunta(
        texto:
            '¿Qué catalizador se usa comúnmente en el ánodo de un electrolizador PEM?',
        opciones: ['Níquel', 'Cobre', 'Iridio / Rutenio', 'Hierro'],
        indiceCorrecto: 2,
        explicacion:
            'Debido al ambiente ácido y oxidante, se requieren metales nobles...',
      ),
    ],
  ),
  ModuloTest(
    titulo: 'Nivel 3: Pilas de Combustible',
    descripcion: 'Termodinámica y generación eléctrica inversa.',
    icono: Icons.battery_charging_full,
    color: Colors.green,
    imagen: ' ',
    preguntas: [
      Pregunta(
        texto:
            '¿Qué subproducto emite una pila de combustible de hidrógeno puro?',
        opciones: ['CO₂', 'NOx', 'Agua y calor', 'Monóxido de carbono'],
        indiceCorrecto: 2,
        explicacion:
            'La recombinación de H₂ y O₂ en la pila genera electricidad y agua pura...',
      ),
      Pregunta(
        texto:
            '¿Cuál es el voltaje teórico de una celda de combustible individual a 25°C?',
        opciones: ['1.23 V', '3.7 V', '12 V', '0.5 V'],
        indiceCorrecto: 0,
        explicacion: 'El potencial reversible termodinámico es 1.23 V...',
      ),
      Pregunta(
        texto:
            'Para obtener voltajes útiles (ej. 300V), ¿cómo se conectan las celdas?',
        opciones: [
          'En paralelo',
          'En serie (Stack)',
          'En estrella',
          'En triángulo',
        ],
        indiceCorrecto: 1,
        explicacion: 'Las celdas se apilan en serie formando un "Stack"...',
      ),
      Pregunta(
        texto:
            'En una celda PEMFC, ¿qué partícula atraviesa la membrana central?',
        opciones: [
          'Electrones',
          'Moléculas de H₂',
          'Protones (H⁺)',
          'Átomos de O',
        ],
        indiceCorrecto: 2,
        explicacion:
            'La membrana polimérica solo permite el paso de iones positivos...',
      ),
      Pregunta(
        texto:
            '¿Qué tipo de corriente eléctrica genera una pila de combustible?',
        opciones: [
          'Corriente Alterna (CA)',
          'Corriente Continua (CC)',
          'Corriente Pulsante',
          'Corriente Trifásica',
        ],
        indiceCorrecto: 1,
        explicacion: 'Generan un flujo continuo de electrones (CC)...',
      ),
      Pregunta(
        texto:
            '¿Cuál es la función del platino (Pt) en la pila de combustible?',
        opciones: [
          'Aislante térmico',
          'Catalizador de las reacciones',
          'Material estructural',
          'Conductor externo',
        ],
        indiceCorrecto: 1,
        explicacion: 'El platino reduce la energía de activación...',
      ),
      Pregunta(
        texto: '¿Qué ocurre en el ánodo de una pila de combustible PEM?',
        opciones: [
          'Reducción del O₂',
          'Oxidación del H₂',
          'Generación de agua',
          'Absorción de calor',
        ],
        indiceCorrecto: 1,
        explicacion: 'El H₂ se oxida perdiendo electrones: H₂ → 2H⁺ + 2e⁻.',
      ),
      Pregunta(
        texto:
            '¿Cuál es la eficiencia eléctrica típica de una celda PEM comercial?',
        opciones: ['10-20%', '20-30%', '40-60%', '80-100%'],
        indiceCorrecto: 2,
        explicacion: 'La eficiencia eléctrica se sitúa entre el 40% y 60%...',
      ),
    ],
  ),
  ModuloTest(
    titulo: 'Nivel 4: Almacenamiento y Seguridad',
    descripcion: 'Normativa, compresión y riesgos operativos.',
    icono: Icons.shield,
    color: Colors.redAccent,
    imagen: ' ',
    preguntas: [
      Pregunta(
        texto:
            '¿A qué presiones típicas se almacena el H₂ gaseoso en vehículos?',
        opciones: ['10-50 bar', '100-200 bar', '350-700 bar', '1000-2000 bar'],
        indiceCorrecto: 2,
        explicacion: 'Se comprime a 350 bar (pesados) o 700 bar (turismos).',
      ),
      Pregunta(
        texto:
            '¿A qué temperatura debe enfriarse el hidrógeno para licuarlo a 1 atm?',
        opciones: ['-50 °C', '-100 °C', '-196 °C', '-253 °C'],
        indiceCorrecto: 3,
        explicacion:
            'El H₂ tiene un punto de ebullición de 20 Kelvin (-253 ºC).',
      ),
      Pregunta(
        texto: '¿Qué es el almacenamiento en hidruros metálicos?',
        opciones: [
          'Cilindros de acero reforzado',
          'Absorción del H₂ en redes cristalinas de metales',
          'Congelación de agua',
          'Disolución en amoníaco',
        ],
        indiceCorrecto: 1,
        explicacion:
            'Los metales absorben el H₂ en su estructura sólida de forma segura...',
      ),
      Pregunta(
        texto: '¿Qué es la "fragilización por hidrógeno" en materiales?',
        opciones: [
          'Pérdida de ductilidad y fisuración de metales',
          'Aumento de dureza superficial',
          'Oxidación acelerada',
          'Derretimiento del metal',
        ],
        indiceCorrecto: 0,
        explicacion:
            'Los átomos penetran en la red cristalina causando grietas...',
      ),
      Pregunta(
        texto: '¿Cuál es el límite de inflamabilidad del hidrógeno en el aire?',
        opciones: ['1-2%', '4-75%', '50-90%', 'Solo a alta presión'],
        indiceCorrecto: 1,
        explicacion:
            'El H₂ tiene un rango de inflamabilidad muy amplio (4-75%).',
      ),
      Pregunta(
        texto: 'Ante una fuga en espacio abierto, el hidrógeno tiende a:',
        opciones: [
          'Acumularse a ras de suelo',
          'Crear una nube tóxica',
          'Ascender y dispersarse rápidamente',
          'Solidificarse',
        ],
        indiceCorrecto: 2,
        explicacion: 'Por su ligereza, asciende a unos 20 m/s...',
      ),
      Pregunta(
        texto: '¿Qué tipo de sensor NO es adecuado para detectar fugas de H₂?',
        opciones: [
          'Sensores catalíticos',
          'Sensores electroquímicos',
          'Detectores de humo ópticos',
          'Conductividad térmica',
        ],
        indiceCorrecto: 2,
        explicacion:
            'El H₂ no genera humo, los detectores ópticos son inútiles.',
      ),
      Pregunta(
        texto:
            'En una sala de electrolizadores, ¿dónde debe ubicarse la ventilación de emergencia?',
        opciones: [
          'En el suelo',
          'A media altura',
          'En el punto más alto del techo',
          'En las puertas',
        ],
        indiceCorrecto: 2,
        explicacion: 'Al ser más ligero que el aire, se acumula en el techo.',
      ),
    ],
  ),
  ModuloTest(
    titulo: 'Nivel 5: Aplicaciones y Casos de Uso',
    descripcion: 'Uso industrial, movilidad y transición energética.',
    icono: Icons.electric_car,
    color: Colors.orange,
    imagen: ' ',
    preguntas: [
      Pregunta(
        texto:
            '¿En qué sector industrial tiene mayor potencial el hidrógeno verde para descarbonizar procesos pesados?',
        opciones: [
          'Siderurgia (acero) y química',
          'Industria textil',
          'Procesamiento de alimentos',
          'Ensamblaje electrónico',
        ],
        indiceCorrecto: 0,
        explicacion:
            'Se utiliza para la reducción directa del mineral de hierro y producción de amoníaco...',
      ),
      Pregunta(
        texto: '¿Qué significa el concepto "Power-to-Gas" (P2G)?',
        opciones: [
          'Generar electricidad quemando gas natural',
          'Convertir excedentes de electricidad renovable en hidrógeno gaseoso',
          'Comprimir aire para mover turbinas',
          'Utilizar gas para refrigerar paneles',
        ],
        indiceCorrecto: 1,
        explicacion:
            'P2G permite almacenar exceso de energía renovable transformándola en hidrógeno...',
      ),
      Pregunta(
        texto:
            '¿Qué ventaja principal tiene un vehículo de pila de combustible (FCEV) frente a uno eléctrico de batería (BEV)?',
        opciones: [
          'Mayor eficiencia energética global',
          'Menor coste de adquisición',
          'Menor tiempo de repostaje y mayor autonomía en carga pesada',
          'Cero desgaste de neumáticos',
        ],
        indiceCorrecto: 2,
        explicacion: 'Repostar hidrógeno toma entre 3 y 5 minutos...',
      ),
      Pregunta(
        texto: '¿Qué es el "blending" en la infraestructura gasista?',
        opciones: [
          'Filtrar impurezas del hidrógeno',
          'Mezclar e inyectar un porcentaje de hidrógeno en la red de gas natural existente',
          'Licuar gases mixtos',
          'Separación de isótopos',
        ],
        indiceCorrecto: 1,
        explicacion:
            'Permite inyectar hasta un 15-20% de H₂ en gasoductos actuales...',
      ),
      Pregunta(
        texto:
            'En la integración de tu propio electrolizador (monitorizado con ESP32), ¿qué tipo de arquitectura representa este sistema?',
        opciones: [
          'Sistema aislado de lazo abierto',
          'Internet de las Cosas (IoT) y gemelo digital básico',
          'Red neuronal profunda',
          'Computación cuántica',
        ],
        indiceCorrecto: 1,
        explicacion:
            'Implementar telemetría JSON y Bluetooth es arquitectura IoT y base para gemelo digital.',
      ),
    ],
  ),
];

// ============================================================================
// 2. PANTALLA PRINCIPAL (Lista de Tests) - STATELESS WIDGET
// ============================================================================
class PantallaTests extends StatelessWidget {
  // Parámetros recibidos desde main.dart
  final Set<int> testsCompletados;
  final Function(int) onTestCompletado;

  const PantallaTests({
    super.key,
    required this.testsCompletados,
    required this.onTestCompletado,
  });

  @override
  Widget build(BuildContext context) {
    // Calculamos el progreso global
    final double progresoGlobal =
        testsCompletados.length / testsHidrogeno.length;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/bg_3.png',
          ), // Asegúrese de la ruta correcta
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
                  'Evaluación',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF01579B),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Demuestra lo aprendido en los módulos',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 20),

                // BARRITA MINIMALISTA DE PROGRESO GLOBAL
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
                            width: constraints.maxWidth * progresoGlobal,
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
                    '${testsCompletados.length} de ${testsHidrogeno.length} completados',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: testsHidrogeno.length,
                    itemBuilder: (context, index) {
                      final estaCompletado = testsCompletados.contains(index);
                      return _construirModuloTest(
                        context,
                        testsHidrogeno[index],
                        index,
                        estaCompletado,
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

  Widget _construirModuloTest(
    BuildContext context,
    ModuloTest modulo,
    int index,
    bool estaCompletado,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      child: InkWell(
        onTap: () async {
          final bool? aprobado = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PantallaCuestionario(modulo: modulo),
            ),
          );

          if (aprobado == true) {
            // Mandamos llamar a la función de main.dart para actualizar el estado global
            onTestCompletado(index);
          }
        },
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: estaCompletado
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.white.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: estaCompletado
                  ? Colors.green.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.9),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: modulo.color.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: estaCompletado
                      ? Colors.green
                      : modulo.color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  estaCompletado ? Icons.check : modulo.icono,
                  size: 32,
                  color: estaCompletado ? Colors.white : modulo.color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      modulo.titulo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      modulo.descripcion,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 3. PANTALLA DE CUESTIONARIO (Mantenida intacta)
// ============================================================================
class PantallaCuestionario extends StatefulWidget {
  final ModuloTest modulo;
  const PantallaCuestionario({super.key, required this.modulo});

  @override
  State<PantallaCuestionario> createState() => _PantallaCuestionarioState();
}

class _PantallaCuestionarioState extends State<PantallaCuestionario> {
  int _indicePreguntaActual = 0;
  int _tiempoRestante = 15;
  Timer? _timer;
  final List<int> _respuestasUsuario = [];

  @override
  void initState() {
    super.initState();
    _iniciarTemporizador();
  }

  void _iniciarTemporizador() {
    _tiempoRestante = 15;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_tiempoRestante > 0) {
        setState(() {
          _tiempoRestante--;
        });
      } else {
        _registrarRespuesta(-1);
      }
    });
  }

  void _registrarRespuesta(int indiceSeleccionado) async {
    _timer?.cancel();
    _respuestasUsuario.add(indiceSeleccionado);

    if (_indicePreguntaActual < widget.modulo.preguntas.length - 1) {
      setState(() {
        _indicePreguntaActual++;
      });
      _iniciarTemporizador();
    } else {
      final bool? resultadoFinal = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PantallaResultados(
            modulo: widget.modulo,
            respuestasUsuario: _respuestasUsuario,
          ),
        ),
      );
      if (mounted) {
        Navigator.pop(context, resultadoFinal);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final preguntaActual = widget.modulo.preguntas[_indicePreguntaActual];
    final progreso = _tiempoRestante / 15.0;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE1F5FE), Color(0xFF4FC3F7)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Color(0xFF01579B)),
          title: Text(
            widget.modulo.titulo,
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF01579B),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Pregunta ${_indicePreguntaActual + 1} de ${widget.modulo.preguntas.length}',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: progreso,
                        strokeWidth: 8,
                        backgroundColor: Colors.white.withValues(alpha: 0.5),
                        color: _tiempoRestante <= 5
                            ? Colors.redAccent
                            : widget.modulo.color,
                      ),
                    ),
                    Text(
                      '$_tiempoRestante',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: _tiempoRestante <= 5
                            ? Colors.redAccent
                            : const Color(0xFF01579B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Text(
                    preguntaActual.texto,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: preguntaActual.opciones.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black87,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.9,
                            ),
                            elevation: 2,
                            padding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: () => _registrarRespuesta(index),
                          child: Text(
                            preguntaActual.opciones[index],
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
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
}

// ============================================================================
// 4. PANTALLA DE RESULTADOS (Mantenida intacta)
// ============================================================================
class PantallaResultados extends StatelessWidget {
  final ModuloTest modulo;
  final List<int> respuestasUsuario;

  const PantallaResultados({
    super.key,
    required this.modulo,
    required this.respuestasUsuario,
  });

  @override
  Widget build(BuildContext context) {
    int aciertos = 0;
    List<Widget> listaCorrecciones = [];

    for (int i = 0; i < modulo.preguntas.length; i++) {
      bool esCorrecta =
          respuestasUsuario[i] == modulo.preguntas[i].indiceCorrecto;
      if (esCorrecta) {
        aciertos++;
      } else {
        listaCorrecciones.add(
          _construirTarjetaError(modulo.preguntas[i], respuestasUsuario[i]),
        );
      }
    }

    bool aprobado = aciertos >= (modulo.preguntas.length / 2);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE1F5FE), Color(0xFF4FC3F7)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'Resultados del Test',
            style: TextStyle(
              color: aprobado ? Colors.green[800] : Colors.red[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: aprobado ? Colors.green : Colors.redAccent,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (aprobado ? Colors.green : Colors.red)
                            .withValues(alpha: 0.2),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        aprobado ? '¡APROBADO!' : 'SUSPENSO',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: aprobado ? Colors.green[700] : Colors.red[700],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Puntuación: $aciertos / ${modulo.preguntas.length}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (listaCorrecciones.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text(
                        '¡Excelente trabajo!\nNo hay errores técnicos.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                else ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Revisión Técnica de Fallos:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: listaCorrecciones,
                    ),
                  ),
                ],
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0277BD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 3,
                    ),
                    onPressed: () {
                      Navigator.pop(context, aprobado);
                    },
                    child: const Text(
                      'Volver al Menú',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _construirTarjetaError(Pregunta pregunta, int indiceRespuestaUsuario) {
    String textoUsuario = indiceRespuestaUsuario == -1
        ? "No respondida (Tiempo agotado)"
        : pregunta.opciones[indiceRespuestaUsuario];

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pregunta.texto,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '❌ Tu respuesta: $textoUsuario',
            style: TextStyle(
              color: Colors.red[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '✅ Correcta: ${pregunta.opciones[pregunta.indiceCorrecto]}',
            style: TextStyle(
              color: Colors.green[700],
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(color: Colors.black12, height: 20, thickness: 1),
          Text(
            'Por qué: ${pregunta.explicacion}',
            style: const TextStyle(
              color: Colors.black54,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
