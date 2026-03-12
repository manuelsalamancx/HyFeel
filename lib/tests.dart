import 'package:flutter/material.dart';
import 'dart:async';

// ============================================================================
// 1. MODELOS DE DATOS (Estructura de la información)
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
  final Color color;
  final List<Pregunta> preguntas;

  ModuloTest({
    required this.titulo,
    required this.descripcion,
    required this.icono,
    required this.color,
    required this.preguntas,
  });
}

// Base de datos local de preguntas para el TFG
final List<ModuloTest> testsHidrogeno = [
  ModuloTest(
    titulo: 'Nivel 1: Fundamentos del H₂',
    descripcion: 'Conceptos básicos y propiedades químicas.',
    icono: Icons.science,
    color: Colors.teal,
    preguntas: [
      Pregunta(
        texto: '¿Cuál es el número atómico del hidrógeno?',
        opciones: ['1', '2', '4', '8'],
        indiceCorrecto: 0,
        explicacion:
            'El hidrógeno es el primer elemento de la tabla periódica, compuesto por un protón y un electrón.',
      ),
      Pregunta(
        texto:
            '¿En qué estado se encuentra el hidrógeno puro a temperatura ambiente?',
        opciones: ['Líquido', 'Sólido', 'Plasma', 'Gas'],
        indiceCorrecto: 3,
        explicacion:
            'A temperatura y presión estándar, el H₂ es un gas diatómico incoloro e inodoro.',
      ),
      Pregunta(
        texto: 'Comparado con el aire, la densidad del hidrógeno es:',
        opciones: ['Igual', 'Ligeramente mayor', 'Mucho menor', 'Mucho mayor'],
        indiceCorrecto: 2,
        explicacion:
            'El hidrógeno es aproximadamente 14 veces más ligero que el aire, lo que facilita su rápida dispersión.',
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
            'El H₂ tiene una densidad energética gravimétrica muy alta (aprox. 120 MJ/kg), casi el triple que la gasolina.',
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
        explicacion:
            'El protio es el más abundante. El deuterio tiene un neutrón extra y el tritio dos.',
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
        explicacion:
            'El hidrógeno reacciona fácilmente, por lo que en la Tierra se encuentra combinado, principalmente en agua (H₂O) y materia orgánica.',
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
        explicacion:
            'La combustión del H₂ produce una llama azul muy tenue, lo que representa un riesgo de seguridad al ser difícil de detectar.',
      ),
      Pregunta(
        texto: '¿Cuál es la solubilidad del hidrógeno en agua?',
        opciones: ['Muy alta', 'Moderada', 'Baja', 'Insoluble'],
        indiceCorrecto: 2,
        explicacion:
            'El hidrógeno gas tiene una solubilidad muy baja en agua debido a su naturaleza apolar.',
      ),
    ],
  ),
  ModuloTest(
    titulo: 'Nivel 2: Producción y Electrólisis',
    descripcion: 'Métodos de obtención y funcionamiento del electrolizador.',
    icono: Icons.water_drop,
    color: Colors.blueAccent,
    preguntas: [
      Pregunta(
        texto:
            '¿Qué color de hidrógeno se asocia a la electrólisis con energía renovable?',
        opciones: ['Gris', 'Azul', 'Verde', 'Rosa'],
        indiceCorrecto: 2,
        explicacion:
            'El "hidrógeno verde" garantiza que no hay emisiones de CO₂ ni en su producción ni en la fuente eléctrica utilizada.',
      ),
      Pregunta(
        texto: 'En una celda de electrólisis PEM, ¿qué se genera en el cátodo?',
        opciones: ['Oxígeno', 'Hidrógeno', 'Agua', 'Ozono'],
        indiceCorrecto: 1,
        explicacion:
            'Los protones (H⁺) atraviesan la membrana hacia el cátodo, donde ganan electrones para formar H₂ gas.',
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
            'Ambos provienen del reformado de gas natural, pero en el azul se aplican tecnologías CCUS para atrapar el CO₂.',
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
        explicacion:
            'Utilizan hidróxido de potasio (KOH) o sodio (NaOH) para permitir la conductividad iónica.',
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
            'La tecnología PEM se acopla mejor a la intermitencia de energías renovables como solar o eólica.',
      ),
      Pregunta(
        texto:
            'En la ecuación global de electrólisis del agua, ¿cuál es el subproducto?',
        opciones: ['Dióxido de carbono', 'Metano', 'Oxígeno', 'Nitrógeno'],
        indiceCorrecto: 2,
        explicacion:
            'La separación de H₂O genera H₂ y O₂. El oxígeno es el subproducto que a menudo se ventila o comercializa.',
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
        explicacion:
            'El SMR es la técnica más madura y económica, aunque genera altas emisiones de CO₂ (H₂ gris).',
      ),
      Pregunta(
        texto:
            '¿Qué catalizador se usa comúnmente en el ánodo de un electrolizador PEM?',
        opciones: ['Níquel', 'Cobre', 'Iridio / Rutenio', 'Hierro'],
        indiceCorrecto: 2,
        explicacion:
            'Debido al ambiente ácido y oxidante, se requieren metales nobles del grupo del platino, como el óxido de iridio.',
      ),
    ],
  ),
  ModuloTest(
    titulo: 'Nivel 3: Pilas de Combustible',
    descripcion: 'Termodinámica y generación eléctrica inversa.',
    icono: Icons.battery_charging_full,
    color: Colors.green,
    preguntas: [
      Pregunta(
        texto:
            '¿Qué subproducto emite una pila de combustible de hidrógeno puro?',
        opciones: ['CO₂', 'NOx', 'Agua y calor', 'Monóxido de carbono'],
        indiceCorrecto: 2,
        explicacion:
            'La recombinación de H₂ y O₂ en la pila genera electricidad, y como únicos subproductos: agua pura y calor.',
      ),
      Pregunta(
        texto:
            '¿Cuál es el voltaje teórico de una celda de combustible individual a 25°C?',
        opciones: ['1.23 V', '3.7 V', '12 V', '0.5 V'],
        indiceCorrecto: 0,
        explicacion:
            'El potencial reversible termodinámico es 1.23 V. En operación real, el voltaje baja debido a sobretensiones.',
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
        explicacion:
            'Las celdas se apilan en serie formando un "Stack" para sumar sus voltajes individuales.',
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
            'La membrana polimérica solo permite el paso de iones positivos (protones). Los electrones fluyen por el circuito externo.',
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
        explicacion:
            'Las reacciones electroquímicas directas generan un flujo continuo de electrones, resultando en Corriente Continua.',
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
        explicacion:
            'El platino reduce la energía de activación necesaria para separar la molécula de H₂ y facilitar la reacción con el O₂.',
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
        explicacion:
            'La eficiencia eléctrica se sitúa entre el 40% y 60%. Si se aprovecha el calor residual (cogeneración), puede superar el 80%.',
      ),
    ],
  ),
  ModuloTest(
    titulo: 'Nivel 4: Almacenamiento y Seguridad',
    descripcion: 'Normativa, compresión y riesgos operativos.',
    icono: Icons.shield,
    color: Colors.redAccent,
    preguntas: [
      Pregunta(
        texto:
            '¿A qué presiones típicas se almacena el H₂ gaseoso en vehículos?',
        opciones: ['10-50 bar', '100-200 bar', '350-700 bar', '1000-2000 bar'],
        indiceCorrecto: 2,
        explicacion:
            'Para compensar su baja densidad volumétrica, se comprime a 350 bar (vehículos pesados) o 700 bar (turismos).',
      ),
      Pregunta(
        texto:
            '¿A qué temperatura debe enfriarse el hidrógeno para licuarlo a 1 atm?',
        opciones: ['-50 °C', '-100 °C', '-196 °C', '-253 °C'],
        indiceCorrecto: 3,
        explicacion:
            'El H₂ tiene un punto de ebullición extremadamente bajo (20 Kelvin). Licuarlo consume aproximadamente el 30% de su propia energía.',
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
            'Los metales absorben el H₂ en su estructura sólida de forma segura a baja presión, liberándolo al aplicar calor.',
      ),
      Pregunta(
        texto: '¿Qué es la "fragilización por hidrógeno" en materiales?',
        opciones: [
          'Pérdida de ductilidad y fisuración de metales expuestos al H₂',
          'Aumento de dureza superficial',
          'Oxidación acelerada',
          'Derretimiento del metal',
        ],
        indiceCorrecto: 0,
        explicacion:
            'Los átomos de H, al ser muy pequeños, penetran en la red cristalina de metales como el acero, causando grietas y fallos estructurales.',
      ),
      Pregunta(
        texto: '¿Cuál es el límite de inflamabilidad del hidrógeno en el aire?',
        opciones: ['1-2%', '4-75%', '50-90%', 'Solo a alta presión'],
        indiceCorrecto: 1,
        explicacion:
            'El H₂ tiene un rango de inflamabilidad muy amplio, lo que significa que puede arder con casi cualquier proporción de aire.',
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
        explicacion:
            'Por su extrema ligereza, asciende a unos 20 m/s, lo que en exteriores reduce significativamente el riesgo de explosión.',
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
            'El H₂ no genera humo al fugar ni al arder, por lo que los detectores ópticos convencionales son inútiles. Se requieren sensores específicos de gas.',
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
        explicacion:
            'Dado que el hidrógeno es más ligero que el aire, siempre se acumulará en las zonas más altas de un recinto cerrado.',
      ),
    ],
  ),
];

// ============================================================================
// 2. PANTALLA PRINCIPAL (Lista de Tests) - Estilo Burbuja
// ============================================================================

class PantallaTests extends StatelessWidget {
  const PantallaTests({super.key});

  @override
  Widget build(BuildContext context) {
    // Fondo azulado general para la aplicación
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/bg_3.png',
          ), // Reemplaza con el nombre y ruta de tu archivo
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Permite ver el gradiente
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
                  'Evaluación de Conocimientos',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF01579B), // Azul oscuro para contraste
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Demuestra lo aprendido en los módulos',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: testsHidrogeno.length,
                    itemBuilder: (context, index) {
                      return _construirModuloTest(
                        context,
                        testsHidrogeno[index],
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

  Widget _construirModuloTest(BuildContext context, ModuloTest modulo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PantallaCuestionario(modulo: modulo),
            ),
          );
        },
        borderRadius: BorderRadius.circular(
          30,
        ), // Bordes más redondeados (burbuja)
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.65), // Mayor transparencia
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.9),
              width: 1.5,
            ), // Reflejo de burbuja
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
                  color: modulo.color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(modulo.icono, size: 32, color: modulo.color),
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
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(
                          15,
                        ), // Etiqueta redondeada
                      ),
                      child: Text(
                        '${modulo.preguntas.length} preguntas',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: modulo.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.black38,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 3. PANTALLA DE CUESTIONARIO
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

  void _registrarRespuesta(int indiceSeleccionado) {
    _timer?.cancel();
    _respuestasUsuario.add(indiceSeleccionado);

    if (_indicePreguntaActual < widget.modulo.preguntas.length - 1) {
      setState(() {
        _indicePreguntaActual++;
      });
      _iniciarTemporizador();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PantallaResultados(
            modulo: widget.modulo,
            respuestasUsuario: _respuestasUsuario,
          ),
        ),
      );
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
          backgroundColor: Colors.transparent, // AppBar transparente
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
          // Previene solapamientos
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
                    borderRadius: BorderRadius.circular(30), // Efecto burbuja
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
                              borderRadius: BorderRadius.circular(
                                25,
                              ), // Botones redondeados
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
// 4. PANTALLA DE RESULTADOS (Con corrección de SafeArea)
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
          automaticallyImplyLeading:
              false, // Oculta la flecha de volver por defecto
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
          // <--- ESTO SOLUCIONA EL SOLAPAMIENTO CON LOS BOTONES TÁCTILES
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20.0,
              10.0,
              20.0,
              20.0,
            ), // Padding inferior extra
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

                const SizedBox(height: 15), // Separación antes del botón
                // Botón protegido por SafeArea y con margen inferior
                SizedBox(
                  width: double.infinity,
                  height: 55, // Altura fija para mayor comodidad táctil
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0277BD), // Azul fuerte
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 3,
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Vuelve al menú de tests
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
