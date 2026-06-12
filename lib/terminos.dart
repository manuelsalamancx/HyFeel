// =========================================================================
// PANTALLA DE TÉRMINOS Y PRIVACIDAD
// =========================================================================
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PantallaTerminos extends StatefulWidget {
  const PantallaTerminos({super.key});

  @override
  State<PantallaTerminos> createState() => _PantallaTerminosState();
}

class _PantallaTerminosState extends State<PantallaTerminos> {
  bool _guardando = false;

  Widget _construirSeccion(String titulo, String contenido) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 13, 71, 161),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            contenido,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Future<void> _aceptarTerminos() async {
    setState(() => _guardando = true);

    final usuario = FirebaseAuth.instance.currentUser;

    // Si el usuario ya está logueado (ej: entra desde Ajustes), actualizamos Firebase
    if (usuario != null) {
      try {
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(usuario.uid)
            .update({
              'terminosAceptados': true,
              'fechaAceptacion': FieldValue.serverTimestamp(),
            });
      } catch (e) {
        debugPrint('Error al guardar términos: $e');
      }
    }

    if (mounted) {
      setState(() => _guardando = false);
      // Hacemos pop devolviendo "true" para avisar a la pantalla anterior
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    const colorPrimario = Color.fromARGB(255, 13, 71, 161);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Fondo claro
      appBar: AppBar(
        title: const Text(
          'Términos y Privacidad',
          style: TextStyle(fontWeight: FontWeight.bold, color: colorPrimario),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: colorPrimario),
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Scrollbar(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Icon(
                      Icons.policy_outlined,
                      size: 60,
                      color: colorPrimario,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Política de Privacidad y\nCondiciones de Uso',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Última actualización: Mayo 2026',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Divider(height: 40, thickness: 1),

                  _construirSeccion(
                    '1. Responsable del Tratamiento y Normativa Aplicable',
                    'El responsable legal del tratamiento de los datos recabados a través de la aplicación HyFeel es Manuel José Salamanca Tejada (en adelante, "el Titular"), con correo electrónico de contacto: manueljsalamancatejada@gmail.com.\n\n'
                        'Todas las actividades de captura, almacenamiento y procesamiento de datos se realizan en estricto cumplimiento del Reglamento General de Protección de Datos (RGPD) (UE) 2016/679 y de la Ley Orgánica 3/2018 (LOPDGDD) de Protección de Datos Personales y garantía de los derechos digitales en España.',
                  ),

                  _construirSeccion(
                    '2. Naturaleza del Proyecto y Base Jurídica',
                    'HyFeel opera como una plataforma interactiva de divulgación científica (microlearning) y, de manera simultánea, como un ecosistema de investigación sociotécnica sobre la adopción de las tecnologías del hidrógeno y la transición energética.\n\n'
                        'La base jurídica que legitima el tratamiento de sus datos es el consentimiento explícito e informado que usted otorga al aceptar estos términos. Los datos de uso general recopilados permiten auditar la efectividad pedagógica del sistema, detectar curvas de dificultad formativa y mapear el interés demográfico en energías renovables, sirviendo de fundamento para estudios académicos y sectoriales.',
                  ),

                  _construirSeccion(
                    '3. Clasificación y Minimización de Datos',
                    'En virtud del principio de minimización, HyFeel solo recopila la información estrictamente necesaria para sus fines declarados, clasificada en tres categorías:\n\n'
                        '• Datos de Identidad (PII): Correo electrónico, identificador único de usuario (UID generado por Firebase de forma automatizada) y nombre o alias de perfil.\n'
                        '• Datos de Contexto Socioprofesional: Ciudad o región de residencia (obtenida sin rastreo por GPS exacto), sector socio-profesional actual y nivel de conocimientos previos autodeclarados sobre el hidrógeno.\n'
                        '• Métricas de Comportamiento y Rendimiento: Registro cronológico de respuestas en cuestionarios, módulos didácticos finalizados, tasas de acierto y fallo por tema, insignias obtenidas, duración de las sesiones y pantallas de abandono.',
                  ),

                  _construirSeccion(
                    '4. Privacidad, Anonimización Irreversible y Explotación de Datos',
                    'Sus datos personales directos (nombre y correo electrónico) están sujetos a un estricto deber de confidencialidad y secreto profesional. Bajo ninguna circunstancia serán vendidos, alquilados ni cedidos a terceros con fines comerciales o publicitarios.\n\n'
                        'No obstante, las métricas de rendimiento, fallos técnicos y datos de contexto sufren un proceso inmediato de ANONIMIZACIÓN ABSOLUTA E IRREVERSIBLE al transferirse a nuestra infraestructura analítica. Conforme al Considerando 26 del RGPD, la normativa de protección de datos no se aplica a la información anónima o agregada. Al aceptar estos términos, usted otorga su consentimiento inequívoco para que dichos datos disociados (imposibles de vincular con su identidad real) puedan ser analizados, publicados, transferidos o licenciados a terceros (incluyendo universidades, consultoras energéticas o entidades de investigación) con el fin de promover el desarrollo científico y de mercado del sector del hidrógeno.',
                  ),

                  _construirSeccion(
                    '5. Infraestructura, Almacenamiento y Seguridad',
                    'Los datos recolectados se procesan utilizando los servicios de computación en la nube de Google Cloud Platform (Firebase Firestore y el almacén analítico BigQuery).\n\n'
                        'Para garantizar el cumplimiento de los estándares de seguridad europeos, la selección de servidores está restringida geográficamente a regiones dentro de la Unión Europea (UE). La información se transmite de forma cifrada mediante protocolos seguros (HTTPS/TLS) tanto en tránsito como en reposo, protegiendo el ecosistema frente a accesos no autorizados.',
                  ),

                  _construirSeccion(
                    '6. Ejercicio de Derechos (ARCO+) y Retención',
                    'Usted conserva en todo momento los derechos de acceso, rectificación, supresión (derecho al olvido), limitación del tratamiento y portabilidad de sus datos personales. Puede ejercerlos enviando una solicitud formal por escrito al correo electrónico manueljsalamancatejada@gmail.com.\n\n'
                        'Asimismo, la plataforma dispone de un mecanismo automatizado de rescisión contractual mediante la función "Eliminar Cuenta" en la sección de Ajustes. La ejecución de esta acción eliminará de forma permanente e inmediata sus datos de identidad de las bases de datos activas de producción (Firestore). En cumplimiento normativo, las métricas históricas de rendimiento que ya hayan sido disociadas en el almacén analítico (BigQuery) permanecerán de forma puramente estadística, anónima y agregada, al no constituir ya datos de carácter personal.',
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _guardando ? null : _aceptarTerminos,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorPrimario,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 2,
                      ),
                      child: _guardando
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'He leído y acepto los términos',
                              style: TextStyle(
                                fontSize: 16,
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
      ),
    );
  }
}
