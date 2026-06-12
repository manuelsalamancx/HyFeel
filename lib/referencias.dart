import 'package:flutter/material.dart';

// =========================================================================
// PANTALLA DE REFERENCIAS
// =========================================================================
class PantallaReferencias extends StatelessWidget {
  const PantallaReferencias({super.key});

  final Color _colorPrimario = const Color.fromARGB(255, 13, 71, 161);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          'Referencias',
          style: TextStyle(fontWeight: FontWeight.bold, color: _colorPrimario),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: _colorPrimario),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        physics: const BouncingScrollPhysics(),
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Bibliografía y fuentes utilizadas para el desarrollo de los contenidos teóricos de HyFeel.',
              style: TextStyle(fontSize: 15, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ),
          _construirBloque('Bloque básico: Rookie del hidrógeno', Icons.eco_outlined, [
            _construirModulo('1. Introducción', [
              '[1] International Energy Agency (IEA), «Logo oficial de la IEA», IEA. Accedido: 5 de mayo de 2026. [En línea]. Disponible en: https://www.iea.org/',
            ]),
            _construirModulo('2. Fundamentos del hidrógeno', [
              '(Sin referencias asignadas)',
            ]),
            _construirModulo('3. El arcoíris del hidrógeno', [
              '(Sin referencias asignadas)',
            ]),
            _construirModulo('4. Conceptos clave de la economía del hidrógeno', [
              '[2] International Renewable Energy Agency (IRENA), Green Hydrogen Cost Reduction: Scaling up Electrolysers to Meet the 1.5°C Climate Goal, Abu Dhabi, United Arab Emirates, 2020.',
              '[3] OMIE, «Página principal», OMIE. Accedido: 7 de mayo de 2026. [En línea]. Disponible en: https://www.omie.es/',
              '[4] Toshiba, «Imagen de sistema H2One», Toshiba Energy Systems & Solutions, oct. 2019. Accedido: 7 de mayo de 2026. [En línea]. Disponible en: https://www.global.toshiba/ww/news/energy/2019/10/news-20191030-01.html',
              '[5] Airbus, «Imagen avión impulsado por hidrógeno ZEROe», Airbus. Accedido: 7 de mayo de 2026. [En línea]. Disponible en: https://www.airbus.com/en/innovation/energy-transition/hydrogen/zeroe-our-hydrogen-powered-aircraft',
              '[6] Foro Coches Eléctricos, «Imagen del primer barco para transportar hidrógeno (Suiso Frontier)», Foro Coches Eléctricos, ene. 2022. Accedido: 7 de mayo de 2026. [En línea]. Disponible en: https://forococheselectricos.com/2022/01/primer-barco-transportar-hidrogeno.html',
            ]),
          ]),
          const SizedBox(height: 12),
          _construirBloque('Bloque industrial: Aprendiz de H2', Icons.factory_outlined, [
            _construirModulo('5. Electrólisis', [
              '[7] Accelera Zero, «Aplicaciones en gasoductos», Accelera Zero. Accedido: 7 de mayo de 2026. [En línea]. Disponible en: https://www.accelerazero.com/es/electrolyzers/applications/gas-pipeline',
              '[8] Sagaz Perenne, «Como Hacer un Generador de Hidrógeno HHO, Experimentos Caseros», YouTube, mar. 2018. Accedido: 7 de mayo de 2026. [En línea]. Disponible en: https://www.youtube.com/watch?v=GF6XUet5VGE&t=3s',
              '[9] ABC, «Imagen de recreación de la planta de hidrógeno verde en la Bahía de Algeciras», ABC de Sevilla, jun. 2021. Accedido: 8 de mayo de 2026. [En línea]. Disponible en: https://www.abc.es/sevilla/economia/sevi-tres-energeticas-proyectan-planta-hidrogeno-verde-bahia-algeciras-202106211811_noticia.html',
              '[10] El Periódico de la Energía, «Imagen de electrolizador alcalino», El Periódico de la Energía. Accedido: 8 de mayo de 2026. [En línea]. Disponible en: https://elperiodicodelaenergia.com/noruega-albergara-el-electrolizador-mas-grande-del-mundo/',
              '[11] VMA Energy, «Imagen de electrolizador PEM para generación de hidrógeno», Made-in-China. Accedido: 8 de mayo de 2026. [En línea]. Disponible en: https://es.made-in-china.com/co_vmaenergy/product_Water-Electrolysis-Pem-Hydrogen-Power-Electricity-Generator-Hydrogen-Plant-Gas-Generation_yusgynsnyg.html',
            ]),
            _construirModulo('6. Pilas de combustible', [
              '[12] SEAS Estudios Superiores Abiertos, Hidrógeno y pilas de combustible, Zaragoza, España: SEAS, s. f.',
              '[13] Toshiba, «H2One Leaflet», Toshiba Energy Systems. Accedido: 9 de mayo de 2026. [En línea]. Disponible en: https://www.global.toshiba/content/dam/toshiba/migration/energysolution/ess/hydrogen/file/H2One_Leaflet_EN.pdf',
              '[14] Wikipedia, «Imagen de William Robert Grove», Wikipedia. Accedido: 9 de mayo de 2026. [En línea]. Disponible en: https://es.wikipedia.org/wiki/William_Robert_Grove',
              '[15] Híbridos y Eléctricos, «Imagen del sistema de pila de combustible de Honda», Híbridos y Eléctricos. Accedido: 9 de mayo de 2026. [En línea]. Disponible en: https://www.hibridosyelectricos.com/coches/parece-motor-normal-pero-es-aparato-honda-utilizara-multitud-vehiculos-hidrogeno_71778_102.html',
              '[16] Honda, «Imagen del Honda FCX Clarity», Honda Automobiles. Accedido: 9 de mayo de 2026. [En línea]. Disponible en: https://es.automobiles.honda.com/clarity%20plug-in-hybrid',
              '[17] Toyota, «Imagen del Toyota Mirai», Toyota España. Accedido: 9 de mayo de 2026. [En línea]. Disponible en: https://www.toyota.es/coches/mirai',
              '[18] Hyundai, «Imagen del Hyundai Nexo (versión antigua)», Hyundai España. Accedido: 9 de mayo de 2026. [En línea]. Disponible en: https://www.hyundai.com/es/es/zonaeco/eco-drive/modelos/todo-sobre-hyundai-nexo-primer-coche-hidrogeno-espana',
              '[19] Híbridos y Eléctricos, «Imagen del camión Hyundai XCIENT Fuel Cell», Híbridos y Eléctricos. Accedido: 10 de mayo de 2026. [En línea]. Disponible en: https://www.hibridosyelectricos.com/camiones/hyundai-actualiza-camion-electrico-hidrogeno-eficiencia-configuracion-6x2_45635_102.html',
              '[20] Híbridos y Eléctricos, «Imagen de hidrogenera de la EMT», Híbridos y Eléctricos. Accedido: 10 de mayo de 2026. [En línea]. Disponible en: https://www.hibridosyelectricos.com/camiones/hyundai-actualiza-camion-electrico-hidrogeno-eficiencia-configuracion-6x2_45635_102.html',
              '[21] Hyundai News, «Imagen del anuncio del Hyundai Nexo con Mireia Belmonte», Hyundai Media Newsroom. Accedido: 10 de mayo de 2026. [En línea]. Disponible en: https://www.hyundai.news/es/articles/press-releases/mireia-belmonte-se-enfrenta-al-desafio-de-respirar-conectada-nexo.html',
            ]),
            _construirModulo('7. Distribución y almacenamiento', [
              '[22] Hiperbaric, «Compresión de H2», Hiperbaric. Accedido: 11 de mayo de 2026. [En línea]. Disponible en: https://www.hiperbaric.com/es/compresion-h2/',
              '[23] Calvera, «Equipos de hidrógeno», Calvera Hydrogen. Accedido: 11 de mayo de 2026. [En línea]. Disponible en: https://www.calvera.es/es/equipos/hidrogeno/',
              '[24] Atlas Copco, «Preocupaciones de seguridad del hidrógeno comprimido», Atlas Copco. Accedido: 11 de mayo de 2026. [En línea]. Disponible en: https://www.atlascopco.com/es-es/compressors/wiki/compressed-air-articles/compressed-hydrogen-safety-concerns',
              '[25] Hiperbaric, «Imagen de equipo de compresión de hidrógeno», Hiperbaric. Accedido: 11 de mayo de 2026. [En línea]. Disponible en: https://www.hiperbaric.com/es/compresion-h2/equipo-de-compresion/',
              '[26] Hiperbaric, «Logo oficial de Hiperbaric», Hiperbaric. Accedido: 12 de mayo de 2026. [En línea]. Disponible en: https://www.hiperbaric.com/',
              '[27] Hyundai, «Imagen del nuevo Hyundai Nexo», Hyundai España. Accedido: 12 de mayo de 2026. [En línea]. Disponible en: https://www.hyundai.com/es/es/modelos/nexo.html',
              '[28] Enagás, «Logo oficial de Enagás», Enagás. Accedido: 12 de mayo de 2026. [En línea]. Disponible en: https://www.enagas.es/',
            ]),
          ]),
          const SizedBox(height: 12),
          _construirBloque('Bloque del mundo real', Icons.public_outlined, [
            _construirModulo('8. Puntos de consumo', [
              '[29] IDAE, «Curso de formación», Campus IDAE. Accedido: 12 de mayo de 2026. [En línea]. Disponible en: https://formacion.idae.es/campus/mod/page/view.php?id=414',
              '[30] Enagás, «Agricultura e hidrógeno verde», Good New Energy. Accedido: 12 de mayo de 2026. [En línea]. Disponible en: https://goodnewenergy.enagas.es/innovadores/agricultura-hidrogeno-verde/',
              '[31] Atlanthy, «Amoniaco», Atlanthy. Accedido: 13 de mayo de 2026. [En línea]. Disponible en: https://www.atlanthy.com/amoniaco/',
              '[32] El Confidencial, «Air-made SAF: combustible sintético de Rolls Royce», Novaceno. Accedido: 13 de mayo de 2026. [En línea]. Disponible en: https://www.elconfidencial.com/tecnologia/novaceno/2023-11-27/air-made-saf-rolls-royce-combusible-sintetico_3781213/',
              '[33] Híbridos y Eléctricos, «Imagen del crucero de hidrógeno Viking», Híbridos y Eléctricos. Accedido: 13 de mayo de 2026. [En línea]. Disponible en: https://www.hibridosyelectricos.com/barcos/primer-crucero-mundo-hidrogeno-con-1000-plazas-239-eslora-ya-esta-en-agua-entra-en-servicio-en-noviembre-2026_85941_102.html',
              '[34] Va de Barcos, «Imagen del carguero fluvial propulsado por hidrógeno H2 Barge 1», Va de Barcos, mar. 2024. Accedido: 13 de mayo de 2026. [En línea]. Disponible en: https://vadebarcos.net/2024/03/30/el-h2-barge-1-el-primer-carguero-fluvial-en-el-mundo-propulsado-por-hidrogeno/',
              '(Nota: Las imágenes cruzadas de Airbus ZEROe y Hyundai XCIENT se omiten aquí al estar ya indexadas bajo los códigos [5] y [19]).',
            ]),
            _construirModulo('9. Proyectos', [
              '[35] AeH2, «Proyectos de Hidrógeno», Asociación Española del Hidrógeno. Accedido: 14 de mayo de 2026. [En línea]. Disponible en: https://aeh2.org/proyectos-hidrogeno/',
              '[36] H2med, «El primer gran corredor de hidrógeno verde de Europa», H2med Project. Accedido: 14 de mayo de 2026. [En línea]. Disponible en: https://h2medproject.com/es/el-primer-gran-corredor-de-hidrogeno-verde-de-europa/',
              '[37] Inspenet, «Australia impulsa el hidrógeno verde (WGEH)», Inspenet. Accedido: 14 de mayo de 2026. [En línea]. Disponible en: https://inspenet.com/noticias/australia-impulsa-el-hidrogeno-verde-wgeh/',
              '[38] WGEH, «Overview», Western Green Energy Hub. Accedido: 9 de junio de 2026. [En línea]. Disponible en: https://wgeh.com.au/overview/',
              '[39] ESD News, «Western Green Energy Hub secures global partnerships», Energy Source & Distribution. Accedido: 14 de mayo de 2026. [En línea]. Disponible en: https://esdnews.com.au/western-green-energy-hub-secures-global-partnerships/',
              '[40] pv magazine, «Total Eren inicia en Chile el proyecto de hidrógeno verde H2 Magallanes», pv magazine Latam. Accedido: 14 de mayo de 2026. [En línea]. Disponible en: https://www.pv-magazine-latam.com/2021/12/03/total-eren-inicia-en-chile-el-proyecto-de-hidrogeno-verde-h2-magallanes/',
              '[41] H2med, «Logo oficial de H2med», H2med Project. Accedido: 14 de mayo de 2026. [En línea]. Disponible en: https://h2medproject.com/',
              '[42] Más País, «Imagen del puerto de Marsella», Más País. Accedido: 15 de mayo de 2026. [En línea]. Disponible en: https://maspais.es/turismo/donde-alojarse/marsella.html',
              '[43] Los Arribes del Duero, «Imagen de Zamora», Los Arribes del Duero. Accedido: 15 de mayo de 2026. [En línea]. Disponible en: https://www.losarribesdelduero.com/que-ver-en-zamora/',
              '[44] WGEH, «Logo oficial de Western Green Energy Hub (WGEH)», Western Green Energy Hub. Accedido: 15 de mayo de 2026. [En línea]. Disponible en: https://wgeh.com.au/',
              '[45] ESD News, «Imagen de render del Western Green Energy Hub», Energy Source & Distribution. Accedido: 15 de mayo de 2026. [En línea]. Disponible en: https://esdnews.com.au/western-green-energy-hub-to-undergo-enviro-assessment/',
              '[46] H2 Magallanes, «Logo oficial del proyecto H2 Magallanes», pv magazine Latam. Accedido: 15 de mayo de 2026. [En línea]. Disponible en: https://www.pv-magazine-latam.com/2021/12/03/total-eren-inicia-en-chile-el-proyecto-de-hidrogeno-verde-h2-magallanes/',
            ]),
            _construirModulo('10. El hidrógeno y España', [
              '[47] Ministerio para la Transición Ecológica y el Reto Demográfico, Hoja de Ruta del Hidrógeno: una apuesta por el hidrógeno renovable, Gobierno de España, Madrid, España, 2020.',
              '[48] Xataka, «Puntos calientes del hidrógeno verde en España representados en un curioso mapa interactivo», Xataka. Accedido: 16 de mayo de 2026. [En línea]. Disponible en: https://www.xataka.com/energia/puntos-calientes-hidrogeno-verde-espana-representados-curioso-mapa-interactivo',
              '[49] Moeve, «Valle Andaluz del Hidrógeno Verde», Moeve Global. Accedido: 16 de mayo de 2026. [En línea]. Disponible en: https://www.moeveglobal.com/es/negocios/commercial-clean-energies/hidrogeno-verde/valle-andaluz',
              '[50] Vozpópuli, «Radiografía del Valle Andaluz del Hidrógeno Verde», Vozpópuli. Accedido: 16 de mayo de 2026. [En línea]. Disponible en: https://www.vozpopuli.com/espana/andalucia/radiografia-del-valle-andaluz-del-hidrogeno-verde-8400-empleos-y-3000-millones-de-inversion.html',
              '[51] La Robla Green, «Transición justa», La Robla Green. Accedido: 16 de mayo de 2026. [En línea]. Disponible en: https://laroblagreen.com/transicion-justa/',
              '[52] Heraldo de León, «La Robla Green comenzará a levantarse este mes», Heraldo de León. Accedido: 16 de mayo de 2026. [En línea]. Disponible en: https://www.heraldodeleon.es/articulo/comarcas/robla-green-comenzara-levantarse-mes-850-millones-inversion-media-800-trabajadores-tres-anos/20260116121250067950.html',
              '[53] El Economista, «Quién es Hygreen Energy, el gigante chino de electrolizadores», El Economista. Accedido: 17 de mayo de 2026. [En línea]. Disponible en: https://www.eleconomista.es/energia/noticias/12963376/08/24/quien-es-hygreen-energy-el-gigante-chino-de-electrolizadores-para-hidrogeno-verde-y-con-mucho-acento-espanol.html',
              '[54] Google, «Resultados de búsqueda: inversión hygreen energy en málaga», Google. Accedido: 17 de mayo de 2026. [En línea]. Disponible en: https://www.google.com/search?q=inversion+hygreen+energy+en+malaga...',
              '[55] Moeve, «Logo oficial de Moeve», Moeve Global. Accedido: 17 de mayo de 2026. [En línea]. Disponible en: https://www.moeveglobal.com/',
              '[56] La Robla Green, «Logo oficial de La Robla Green», La Robla Green. Accedido: 17 de mayo de 2026. [En línea]. Disponible en: https://laroblagreen.com/',
              '[57] La Robla Green, «Imagen de render del proyecto La Robla Green», La Robla Green. Accedido: 17 de mayo de 2026. [En línea]. Disponible en: https://laroblagreen.com/transicion-justa/',
              '[58] Hygreen Energy, «Logo oficial de Hygreen Energy», Hygreen Energy. Accedido: 17 de mayo de 2026. [En línea]. Disponible en: https://www.hygreenenergy.com/',
            ]),
            _construirModulo('11. Mitos sobre el hidrógeno', [
              '[59] Apilados, «¿Es el hidrógeno peligroso?», Apilados Blog. Accedido: 18 de mayo de 2026. [En línea]. Disponible en: https://apilados.com/blog/es-el-hidrogeno-peligroso/',
              '[60] JCU, «Fac Bib 2017», John Carroll University. Accedido: 18 de mayo de 2026. [En línea]. Disponible en: https://collected.jcu.edu/fac_bib_2017/11/',
              '[61] Swagelok, «Seguridad del combustible de hidrógeno», Swagelok. Accedido: 18 de mayo de 2026. [En línea]. Disponible en: https://www.swagelok.com/es/blog/hydrogen-fuel-safety',
              '[62] Atlanthy, «Agua e hidrógeno», Atlanthy. Accedido: 19 de mayo de 2026. [En línea]. Disponible en: https://www.atlanthy.com/agua-hidrogeno/',
              '[63] UNEP FI, «Preguntas frecuentes sobre el hidrógeno», UNEP FI. Accedido: 19 de mayo de 2026. [En línea]. Disponible en: https://www.unepfi.org/wordpress/wp-content/uploads/2021/07/PREGUN1.pdf',
              '[64] Reddit, «Imagen colorizada del desastre del Hindenburg (6 de mayo de 1937)», r/CatastrophicFailure. Accedido: 19 de mayo de 2026. [En línea]. Disponible en: https://www.reddit.com/r/CatastrophicFailure/comments/ju3fgg/hindenburg_disaster_may_6_1937_colorized/?tl=es-419',
              '[65] Wikimedia Commons, «Imagen del último vuelo del Hindenburg sobre la ciudad de Nueva York (6 de mayo de 1937)», Wikimedia Commons. Accedido: 19 de mayo de 2026. [En línea]. Disponible en: https://commons.wikimedia.org/wiki/File:Hindenburg%27s_last_flight_over_New_York_City_May_6_1937.jpg',
            ]),
          ]),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _construirBloque(String titulo, IconData icono, List<Widget> modulos) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ExpansionTile(
        leading: Icon(icono, color: _colorPrimario),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        shape: const Border(),
        children: modulos,
      ),
    );
  }

  Widget _construirModulo(String tituloModulo, List<String> citas) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 12.0,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              tituloModulo,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ...citas.map(
            (cita) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
              child: SelectableText(
                cita,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
