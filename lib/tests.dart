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
    titulo: 'Nivel 1: El H\u2082 como elemento.',
    descripcion: 'Conceptos básicos y propiedades químicas.',
    icono: Icons.science,
    color: Colors.teal,
    imagen: 'assets/home_images/fundhidro.jpg',
    preguntas: [
      Pregunta(
        texto: '¿Cuál es el número atómico del hidrógeno?',
        opciones: ['1', '2', '4', '8'],
        indiceCorrecto: 0,
        explicacion:
            'El hidrógeno es el primer elemento de la tabla periódica, por lo tanto, tiene numero atómico 1.',
      ),
      Pregunta(
        texto:
            '¿En qué estado se encuentra el hidrógeno puro a temperatura ambiente?',
        opciones: ['Líquido', 'Sólido', 'Plasma', 'Gas'],
        indiceCorrecto: 3,
        explicacion:
            'A temperatura y presión estándar, el hidrógeno se encuentra como gas, formando la molecula H\u2082',
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
            '¿Cuanta energía "almacena" el H₂ frente a los combustibles fósiles?',
        opciones: [
          'Menor',
          'Igual',
          'Aproximadamente el doble o triple',
          'Diez veces mayor',
        ],
        indiceCorrecto: 2,
        explicacion:
            'El H₂ tiene una densidad energética gravimétrica muy alta, pero muy baja densidad volumétrica.',
      ),
      Pregunta(
        texto: '¿Cuáles son los isótopos naturales del hidrógeno?',
        opciones: [
          'Protio, Deuterio, Tritio',
          'Hidrógeno Alfa, Beta y Gamma',
          'Helio-3, Helio-4',
          'Uranio, Plutonio',
        ],
        indiceCorrecto: 0,
        explicacion: 'El protio es el más abundante.',
      ),
      Pregunta(
        texto: '¿Dónde es el hidrógeno abundante en la tierra?',
        opciones: [
          'En la atmósfera',
          'En el subsuelo',
          'Se encuentra en compuestos',
          'En los océanos',
        ],
        indiceCorrecto: 2,
        explicacion:
            'Hablabamos del hidrógeno como el pegamento de los compuestos.',
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
        explicacion: 'La combustión del H₂ produce una llama azul muy tenue.',
      ),
      Pregunta(
        texto: 'A temperatura ambiente el hidrógeno es un gas.',
        opciones: [
          'Oloroso',
          'De color azul',
          'Inodoro',
          'Si lo tienes cerca, puedes notar un sabor metálico.',
        ],
        indiceCorrecto: 2,
        explicacion: 'El hidrógeno no huele a nada.',
      ),
      Pregunta(
        texto: '¿Cuál es la función del hidrógeno en el sol?',
        opciones: [
          'Fusionarse con el helio para liberar energía.',
          'Refrigerar el núcleo',
          'Sintetizar elementos pesados',
          'Mantener la estructura.',
        ],
        indiceCorrecto: 0,
        explicacion:
            'En el nucleo del sol, se libera energía a traves de fusión nuclear.',
      ),
      Pregunta(
        texto:
            '¿Cual es la abundancia, en porcentaje aproximado, del hidrógeno en el universo?',
        opciones: ['12%', '89%', '35%', '75%'],
        indiceCorrecto: 3,
        explicacion:
            'Es el elemento más abundante, constituye 3/4 partes de la masa en el universo.',
      ),
    ],
  ),
  ModuloTest(
    titulo: 'Nivel 2: El H\u2082 como contexto.',
    descripcion: 'Vocabulario y contexto de la economía del hidrógeno.',
    icono: Icons.water_drop,
    color: Colors.blueAccent,
    imagen: 'assets/home_images/electrolizador_tests.png',
    preguntas: [
      Pregunta(
        texto:
            '¿Qué color de hidrógeno se asocia a la electrólisis con energía renovable?',
        opciones: ['Gris', 'Azul', 'Verde', 'Rosa'],
        indiceCorrecto: 2,
        explicacion:
            'El hidrógeno verde o hidrógeno renovable garantiza una cadena con 0 emisiones de CO\u2082',
      ),
      Pregunta(
        texto: '¿Como se extrae el hidrógeno rosa?',
        opciones: [
          'Gasificación de antracita',
          'Electrólisis con energía nuclear',
          'Yacimientos de hidrógeno puro',
          'Blending con gas natural',
        ],
        indiceCorrecto: 1,
        explicacion:
            'El color rosa identifica que la fuente es la fisión nuclear.',
      ),
      Pregunta(
        texto:
            'Las características del hidrógeno nos permiten deducir que posee una _________ alta.',
        opciones: [
          'Densidad energética gravimétrica',
          'Eficiencia',
          'Densidad energética volumétrica',
          'Temperatura crítica',
        ],
        indiceCorrecto: 0,
        explicacion:
            'La cantidad de energía que puedes guardar en un kilogramo de hidrógeno es alta comparada con los demas comustibles.',
      ),
      Pregunta(
        texto:
            '¿Cuál es la principal diferencia entre el hidrógeno gris y el azul',
        opciones: [
          'Usar biomasa',
          'La electrólisis de alta temperatura',
          'La pureza del hidrógeno resultante',
          'La captura de CO\u2082',
        ],
        indiceCorrecto: 3,
        explicacion:
            'Para el hidrógeno azul se utiliza reformado de vapor con metano (SMR), junto con la captura de C0\u2082 resultante.',
      ),
      Pregunta(
        texto:
            'Selecciona la afirmación verdadera sobre las fuentes primarias:',
        opciones: [
          'Las fuentes primarias clásicas son el sol, el viento, el gas natural y el uranio',
          'El hidrógeno es la fuente primaria más abundante en la corteza terrestre',
          'Pueden ser consumidos directamente por el usuario final',
          'No emiten gases de efecto invernadero a lo largo de su vida',
        ],
        indiceCorrecto: 0,
        explicacion:
            'Las fuentes primarias de energía se encuentran directamente en la naturaleza.',
      ),
      Pregunta(
        texto:
            '¿Es correcta la afirmación que dice que el hidrógeno blanco emite CO\u2082 en su extracción? ',
        opciones: [
          'Si, al utilizar gasificación del carbón negro para su extracción ',
          'Es totalmente falsa, se extrae de bolsas subterraneas',
          'Falso, la termólisis es neutra en carbono',
          'Es correcta ya que el hidrógeno siempre emite CO\u2082',
        ],
        indiceCorrecto: 1,
        explicacion:
            'El hidrógeno blanco se extrae de manera natural, sín uso de energía eléctrica.',
      ),
      Pregunta(
        texto: '¿Qué es un vector energético?',
        opciones: [
          'Una forma de calcular la distancia desde la generación y los puntos de consumo',
          'Un vehículo alimentado por energía eléctrica',
          'Es un recurso natural que se extrae directamente de yacimientos y se usa sin transformación',
          'Una sustancia o fenómeno que permite transportar y almacenar energía',
        ],
        indiceCorrecto: 3,
        explicacion:
            'Un vector energético es el dinero con el que vamos a comprar el pan, ¿recuerdas?.',
      ),
      Pregunta(
        texto: '¿Cuál de los siguientes elementos es un vector energético?',
        opciones: ['Hidrógeno', 'Radiación', 'Viento', 'Hierro'],
        indiceCorrecto: 0,
        explicacion:
            'El hidrógeno es el único elemento del grupo que puede almacenar energía, con el objetivo de ser extraido posteriormente.',
      ),
    ],
  ),
  ModuloTest(
    titulo: 'Nivel 3: Pilas de combustible y electrólisis',
    descripcion: 'Las máquinas del hidrógeno.',
    icono: Icons.battery_charging_full,
    color: Colors.green,
    imagen: 'assets/home_images/fuelcells_tests.png',
    preguntas: [
      Pregunta(
        texto: '¿Qué es principalmente la electrólisis del agua?',
        opciones: [
          'Filtrar impurezas finas del aire urbano',
          'Congelar agua mediante calor químico intenso',
          'Separar agua el agua, usando corriente eléctrica continua',
          'Mezclar gases para producir mucha electricidad',
        ],
        indiceCorrecto: 2,
        explicacion:
            'La electricidad continua aporta la energía necesaría para inducir la descomponsición química del agua.',
      ),

      Pregunta(
        texto: '¿Qué gases se obtienen directamente de la electrólisis?',
        opciones: [
          'Hidrógeno y oxígeno de forma separada',
          'Dióxido de carbono y nitrógeno líquido',
          'Vapor de agua y helio puro',
          'Hidróxido de potasio',
        ],
        indiceCorrecto: 0,
        explicacion:
            'La molécula del agua se divide exactamente en sus dos componentes elementales.',
      ),

      Pregunta(
        texto: '¿Cuál es la función de una pila de combustible?',
        opciones: [
          'Almacena energía como una batería estándar',
          'El proceso inverso a un electrolizador',
          'Limpia el agua estancada de forma automática',
          'Quema gasolina para generar calor interno',
        ],
        indiceCorrecto: 1,
        explicacion:
            'Realiza la reacción totalmente inversa al electrolizador, transformando la energía química del hidrógeno en electricidad',
      ),

      Pregunta(
        texto: 'En la electrólisis, ¿qué genera el electrodo negativo (-)?',
        opciones: [
          'Produce oxígeno por oxidación química',
          'Produce gas hidrógeno por reducción',
          'Absorbe toda la electricidad continua circulante',
          'Genera agua destilada muy pura',
        ],
        indiceCorrecto: 1,
        explicacion:
            'En el polo o electrodo negativo se produce la reducción química del agua, liberando gas hidrógeno',
      ),

      Pregunta(
        texto: '¿Cuál es el principal subproducto de la pila de combustible?',
        opciones: [
          'Electrolito alcalino líquido altamente corrosivo',
          'Emisiones contaminantes de dióxido carbono',
          'Corriente alterna de alta tensión',
          'Agua en forma de vapor',
        ],
        indiceCorrecto: 3,
        explicacion:
            'Al recombinar los gases dentro de la pila para generar energía, el agua resultante vuelve a la atmósfera como vapor.',
      ),

      Pregunta(
        texto:
            '¿Qué utiliza el electrolizador alcalino para conducir electrones?',
        opciones: [
          'Disolución de Hidróxido de Potasio',
          'Membrana polimérica sólida y seca',
          'Agua pura sin ningún aditivo conductor',
          'Filtros metálicos de partículas finas',
        ],
        indiceCorrecto: 0,
        explicacion:
            'Esta tecnología requiere disolver Hidróxido de Potasio (KOH) en el agua para que actúe como electrolito conductor.',
      ),

      Pregunta(
        texto: '¿Qué tipo de agua requiere la tecnología PEM?',
        opciones: [
          'Solución básica de pH muy alto',
          'Agua completamente pura o destilada',
          'Agua salada directa del mar',
          'Vapor atmosférico mezclado con gases',
        ],
        indiceCorrecto: 1,
        explicacion:
            'Los sistemas PEM necesitan agua pura o destilada, ya que la conducción iónica la realiza directamente su membrana polimérica sólida.',
      ),

      Pregunta(
        texto: '¿Dónde es más ventajoso usar pilas de combustible?',
        opciones: [
          'En turismos urbanos muy baratos',
          'En patinetes eléctricos de uso ligero',
          'En el sector del transporte pesado',
          'En redes estáticas de telefonía móvil',
        ],
        indiceCorrecto: 2,
        explicacion:
            'Son ideales en transporte pesado gracias a su excelente autonomía, repostaje rápido y el bajo peso del sistema frente a las baterías.',
      ),

      Pregunta(
        texto: '¿Qué función cumple la membrana en el electrolizador?',
        opciones: [
          'Aumentar artificialmente el coste del sistema',
          'Evitar que los gases se mezclen',
          'Calentar el agua antes de reaccionar',
          'Disolver el potasio de forma líquida',
        ],
        indiceCorrecto: 1,
        explicacion:
            'La membrana actúa como un estricto control de aduanas que mantiene separados el oxígeno y el hidrógeno por seguridad.',
      ),
    ],
  ),

  ModuloTest(
    titulo: 'Nivel 4: Almacenamiento y transporte.',
    descripcion: 'El gran desafío ingenieril.',
    icono: Icons.shield,
    color: Colors.redAccent,
    imagen: 'assets/home_images/almacenamiento_tests.png',
    preguntas: [
      Pregunta(
        texto:
            '¿Cuántos litros ocupa un kilo de hidrógeno a presión atmosférica?',
        opciones: [
          'Solo un litro de volumen',
          'Una piscina olímpica entera',
          'Unos 11.000 litros aproximados',
          'Diez litros a presión ambiente',
        ],
        indiceCorrecto: 2,
        explicacion:
            'Debido a su baja densidad volumétrica, un solo kilogramo de hidrógeno a temperatura de 20°C y presión atmosférica ocupa un volumen masivo de 11.000 litros.',
      ),

      Pregunta(
        texto:
            '¿A qué presión se comprime el hidrógeno en el Toyota Mirai? [cite: 337, 338]',
        opciones: [
          'Apenas unos 10 bares',
          'Alrededor de 700 bares',
          'Sin ninguna presión interna',
          'Exactamente 50 bares fijos',
        ],
        indiceCorrecto: 1,
        explicacion:
            'Para evitar que el tanque del vehículo sea excesivamente grande, el gas se comprime alcanzando los 700 bares de presión.',
      ),

      Pregunta(
        texto: '¿En qué consiste el proceso denominado "blending"? ',
        opciones: [
          'Inyectar hidrógeno en gas natural',
          'Congelar gas a temperaturas extremas',
          'Fabricar amoniaco líquido industrial',
          'Separar agua usando corriente continua',
        ],
        indiceCorrecto: 0,
        explicacion:
            'El blending consiste en la inyección de pequeños porcentajes de hidrógeno directamente dentro de la infraestructura existente de gas natural para su transporte.',
      ),

      Pregunta(
        texto:
            '¿Qué efecto negativo puede causar el hidrógeno en las tuberías de acero?',
        opciones: [
          'Aumenta su resistencia mecánica notablemente',
          'Cambia su color superficial de inmediato',
          'Convierte el acero en quebradizo',
          'Derrite el metal por completo',
        ],
        indiceCorrecto: 2,
        explicacion:
            'El hidrógeno tiene un tamaño tan diminuto que puede filtrarse en las juntas y componentes, con el riesgo adicional de convertir el acero en un metal quebradizo.',
      ),

      Pregunta(
        texto:
            '¿Qué porcentaje máximo de hidrógeno permite inyectar Enagás en su red?',
        opciones: [
          'Permite volcar hasta un 2%',
          'Inyectar exactamente un 50% total',
          'Vaciar por completo la red',
          'Alrededor del 20% del volumen',
        ],
        indiceCorrecto: 0,
        explicacion:
            'Enagás está preparando la descarbonización permitiendo a las empresas suministradoras volcar un límite de hasta el 2% de hidrógeno en la red actual de gas natural. ',
      ),

      Pregunta(
        texto:
            '¿Qué industrias pesadas pueden quemar directamente la mezcla de blending?',
        opciones: [
          'Fábricas de electrónica muy limpia',
          'Centrales nucleares de nueva generación',
          'Empresas de transporte urbano ligero',
          'Industrias del cemento o vidrio',
        ],
        indiceCorrecto: 3,
        explicacion:
            'Las calderas pesadas de las industrias del cemento y del vidrio toleran la combustión de pequeñas medidas de hidrógeno sin requerir costosas modificaciones inmediatas.',
      ),

      Pregunta(
        texto:
            '¿Cuál es un derivado químico del hidrógeno utilizado para facilitar su transporte? ',
        opciones: [
          'Gas natural del subsuelo marino',
          'Amoniaco, metanol o combustibles sintéticos',
          'Agua destilada pura con aditivos',
          'Oxígeno puro obtenido en celdas',
        ],
        indiceCorrecto: 1,
        explicacion:
            'Para optimizar el transporte se puede transformar el hidrógeno puro en derivados con propiedades más favorables, destacando el amoniaco, el metanol o los combustibles sintéticos. ',
      ),
      Pregunta(
        texto:
            '¿Cuál es el objetivo principal de los proyectos de "Valles de Hidrógeno"? ',
        opciones: [
          'Acercar la generación al consumo',
          'Transportar gas a largas distancias',
          'Almacenar agua en piscinas olímpicas',
          'Exportar metanol hacia toda Europa',
        ],
        indiceCorrecto: 0,
        explicacion:
            'Los proyectos de Valles de Hidrógeno buscan resolver la complejidad logística del transporte agrupando y acercando geográficamente los puntos de generación a los centros de consumo. ',
      ),
    ],
  ),

  ModuloTest(
    titulo: 'Nivel 5: Los usos del hidrógeno en nuestra sociedad.',
    descripcion: 'Usos clásicos y actuales.',
    icono: Icons.electric_car,
    color: Colors.orange,
    imagen: ' ',
    preguntas: [
      Pregunta(
        texto: '¿Cuál es actualmente el mayor consumidor de hidrógeno?',
        opciones: [
          'Las fábricas de coches eléctricos',
          'La industria del vidrio templado',
          'Las centrales de energía nuclear',
          'Las refinerías de petróleo',
        ],
        indiceCorrecto: 3,
        explicacion:
            'Las refinerías de petróleo utilizan volúmenes masivos de este gas para procesar y mejorar los combustibles fósiles tradicionales.',
      ),

      Pregunta(
        texto: '¿Qué función cumple el hidrotratamiento en el combustible?',
        opciones: [
          'Limpiar compuestos no deseados',
          'Romper moléculas en cadenas largas',
          'Congelar el petróleo crudo extraído',
          'Generar electricidad para los camiones',
        ],
        indiceCorrecto: 0,
        explicacion:
            'El hidrógeno actúa eliminando impurezas y compuestos no deseados para limpiar el combustible final.',
      ),

      Pregunta(
        texto: '¿Qué busca el mercado al usar hidrocracking?',
        opciones: [
          'Moléculas pesadas de cadena larga',
          'Producir principalmente gasolina y diésel',
          'Almacenar hidrógeno gaseoso a presión',
          'Crear asfalto para las carreteras',
        ],
        indiceCorrecto: 1,
        explicacion:
            'El hidrocracking rompe las cadenas moleculares largas y pesadas del crudo para obtener productos ligeros muy demandados como gasolina y diésel.',
      ),

      Pregunta(
        texto:
            '¿De qué tipo es mayoritariamente el hidrógeno industrial actual?',
        opciones: [
          'Hidrógeno gris no renovable',
          'Hidrógeno rosa',
          'Hidrógeno verde renovable',
          'Hidrógeno líquido muy congelado',
        ],
        indiceCorrecto: 0,
        explicacion:
            'Pese a sus ventajas sostenibles futuras, el hidrógeno que consume la industria actual procede mayoritariamente de fuentes fósiles (gris).',
      ),

      Pregunta(
        texto: '¿Qué compuesto químico derivado se usa en fertilizantes?',
        opciones: [
          'Dióxido de carbono puro',
          'Metanol verde de alta presión',
          'Amoniaco para aportar nitrógeno',
          'Agua salada sin desalinizar',
        ],
        indiceCorrecto: 2,
        explicacion:
            'Dado que las plantas no absorben el nitrógeno del aire directamente, se utiliza amoniaco (NH3) elaborado a partir de hidrógeno.',
      ),

      Pregunta(
        texto: '¿Qué significa la sigla SAF en aviación?',
        opciones: [
          'Sistemas de almacenamiento de fluidos',
          'Combustibles de aviación sostenibles',
          'Saturación de filtros de partículas',
          'Suministro alternativo de fósiles',
        ],
        indiceCorrecto: 1,
        explicacion:
            'Corresponde a Sustainable Aviation Fuel, carburantes limpios que reducen el impacto contaminante del sector aéreo combinando hidrógeno renovable y CO2 capturado.',
      ),

      Pregunta(
        texto: '¿Cómo se crean los llamados e-Fuels de aviación?',
        opciones: [
          'Combinando hidrógeno renovable con CO2 capturado',
          'Refinando petróleo crudo de cadena larga',
          'Mezclando amoníaco con agua de mar',
          'Quemando biomasa forestal a alta temperatura',
        ],
        indiceCorrecto: 0,
        explicacion:
            'Los e-Fuels requeridos para los combustibles SAF se fabrican combinando directamente hidrógeno renovable con dióxido de carbono capturado[cite: 545].',
      ),
      Pregunta(
        texto: '¿Cómo se pueden abaratar costes de hidrogeneras para camiones?',
        opciones: [
          'Abriendo estaciones públicas en cada esquina',
          'Mezclando el hidrógeno con combustible gris',
          'Reduciendo el tamaño de los tanques',
          'Colocándolas estratégicamente en rutas preestablecidas',
        ],
        indiceCorrecto: 1,
        explicacion:
            'Ubicar la infraestructura de repostaje de forma estratégica en rutas logísticas comerciales ya fijadas ayuda a reducir de manera directa los costes iniciales[cite: 517, 518].',
      ),
    ],
  ),

  ModuloTest(
    titulo: 'Nivel 6: Grandes proyectos de H\u2082.',
    descripcion: 'EL rol creciente del hidrógeno renovable en el mundo',
    icono: Icons.people,
    color: Colors.orange,
    imagen: ' ',
    preguntas: [
      Pregunta(
        texto:
            '¿Qué ciudades une el corredor submarino principal del proyecto H2med?',
        opciones: [
          'Madrid y Lisboa',
          'Zamora y Celorico',
          'Barcelona y Marsella',
          'Huelva y San Roque',
        ],
        indiceCorrecto: 2,
        explicacion:
            'El conducto submarino principal de este gran corredor europeo conecta España y Francia mediante estas dos localizaciones portuarias.',
      ),

      Pregunta(
        texto: '¿Cuál es el objetivo principal del proyecto H2med?',
        opciones: [
          'Transportar hidrógeno al centro de Europa',
          'Importar gas natural desde Francia',
          'Almacenar agua de mar desalinizada',
          'Fabricar baterías de litio baratas',
        ],
        indiceCorrecto: 0,
        explicacion:
            'Pretende canalizar el gran potencial de producción renovable de la península ibérica directamente hacia los mercados del centro del continente europeo.',
      ),

      Pregunta(
        texto: '¿Qué tramo une el segundo corredor de H2med?',
        opciones: [
          'Barcelona con el norte de África',
          'Buenos Aires con las costas chilenas',
          'Celorico da Beira con Zamora',
          'Málaga con los valles australianos',
        ],
        indiceCorrecto: 2,
        explicacion:
            'Este brazo de interconexión terrestre une las redes de transporte de gas e hidrógeno entre Portugal y España.',
      ),

      Pregunta(
        texto: '¿Dónde se ubica el macroproyecto Western Green Energy Hub?',
        opciones: [
          'En el sur de Chile',
          'En la Australia Occidental',
          'En el norte de Francia',
          'En la provincia de León',
        ],
        indiceCorrecto: 1,
        explicacion:
            'Es una de las obras de ingeniería energética más colosales del mundo, proyectada sobre terrenos de Australia Occidental.',
      ),

      Pregunta(
        texto: '¿Qué energía renovable aprovecha el proyecto H2 Magallanes?',
        opciones: [
          'Energía solar fotovoltaica flotante',
          'Biomasa forestal de alta calidad',
          'Energía mareomotriz del océano pacífico',
          'Energía eólica terrestre casi constante',
        ],
        indiceCorrecto: 3,
        explicacion:
            'La zona chilena de Magallanes cuenta con vientos terrestres constantes y potentes, permitiendo un coste de generación eléctrica sumamente bajo.',
      ),

      Pregunta(
        texto: '¿Por qué España puede producir hidrógeno competitivo?',
        opciones: [
          'Por su alto potencial renovable',
          'Porque el agua dulce es gratis',
          'Por comprar gas de Francia',
          'Porque no usa compresores industriales',
        ],
        indiceCorrecto: 0,
        explicacion:
            'Su masivo recurso solar y eólico reduce drásticamente el precio de la electricidad durante las horas pico, abaratando el coste final del kilo de hidrógeno.',
      ),

      Pregunta(
        texto: '¿Qué define a un "Valle de hidrógeno"?',
        opciones: [
          'Largas tuberías que cruzan océanos',
          'Generación y consumo en zonas cercanas',
          'Montañas donde se almacena gas',
          'Fábricas que solo limpian tuberías',
        ],
        indiceCorrecto: 1,
        explicacion:
            'Son ecosistemas regionales donde la producción, el almacenamiento y los clientes finales se sitúan juntos para evitar los altos costes de transporte.',
      ),

      Pregunta(
        texto: '¿Dónde se proyecta el Valle Andaluz del Hidrógeno?',
        opciones: [
          'Únicamente en Sevilla capital',
          'En el puerto de Málaga',
          'En las playas de Almería',
          'Entre Huelva y Cádiz',
        ],
        indiceCorrecto: 3,
        explicacion:
            'El plan promovido por Moeve distribuye sus parques de electrólisis entre Palos de la Frontera (Huelva) y San Roque (Cádiz).',
      ),

      Pregunta(
        texto: '¿Qué producto verde principal sintetizará La Robla Green?',
        opciones: [
          'e-Metanol verde a gran escala',
          'Gasolina refinada de alta densidad',
          'Amoniaco líquido para fertilizante',
          'Baterías de litio de última generación',
        ],
        indiceCorrecto: 0,
        explicacion:
            'El proyecto leonés combinará el hidrógeno limpio con CO2 capturado de biomasa forestal para producir unas 100.000 toneladas de e-Metanol al año.',
      ),

      Pregunta(
        texto: '¿Qué fábrica se instalará en Humilladero (Málaga)?',
        opciones: [
          'Una central térmica de carbón',
          'Un astillero para cruceros híbridos',
          'Una fábrica de electrolizadores avanzada',
          'Una refinería de petróleo gris',
        ],
        indiceCorrecto: 2,
        explicacion:
            'La firma multinacional HyGreen ha seleccionado esta ubicación malagueña para levantar una planta avanzada de fabricación de electrolizadores de última generación.',
      ),
    ],
  ),
];

// ============================================================================
// 2. PANTALLA PRINCIPAL (Lista de Tests) - REFACTORIZADA CON BLOQUEO SECUENCIAL
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
          image: AssetImage('assets/images/bg_3.png'),
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
                  'Demuestra lo aprendido en orden secuencial',
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

                      // LÓGICA DE BLOQUEO SECUENCIAL:
                      // Está bloqueado si NO es el primer test (index > 0)
                      // Y el test inmediatamente anterior NO está completado.
                      final estaBloqueado =
                          index > 0 && !testsCompletados.contains(index - 1);

                      return _construirModuloTest(
                        context,
                        testsHidrogeno[index],
                        index,
                        estaCompletado,
                        estaBloqueado, // Pasamos el nuevo parámetro
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
    bool estaBloqueado,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      // CORRECCIÓN: Envolvemos el InkWell interactivo en el widget Opacity
      child: Opacity(
        opacity: estaBloqueado ? 0.6 : 1.0,
        child: InkWell(
          onTap: estaBloqueado
              ? () {
                  // Feedback si el usuario intenta entrar a un test bloqueado
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
                      builder: (context) =>
                          PantallaCuestionario(modulo: modulo),
                    ),
                  );

                  if (aprobado == true) {
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
                    : (estaBloqueado
                          ? Colors.grey.withValues(alpha: 0.3)
                          : Colors.white.withValues(alpha: 0.9)),
                width: 1.5,
              ),
              boxShadow: estaBloqueado
                  ? []
                  : [
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
                        : (estaBloqueado
                              ? Colors.grey
                              : modulo.color.withValues(alpha: 0.2)),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    // Modificación del icono según el estado
                    estaBloqueado
                        ? Icons.lock
                        : (estaCompletado ? Icons.check : modulo.icono),
                    size: 32,
                    color: (estaCompletado || estaBloqueado)
                        ? Colors.white
                        : modulo.color,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        modulo.titulo,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: estaBloqueado
                              ? Colors.grey[700]
                              : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        estaBloqueado
                            ? 'Completa el nivel anterior primero!'
                            : modulo.descripcion,
                        style: TextStyle(
                          fontSize: 13,
                          color: estaBloqueado
                              ? Colors.redAccent[200]
                              : Colors.black54,
                          fontStyle: estaBloqueado
                              ? FontStyle.italic
                              : FontStyle.normal,
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
