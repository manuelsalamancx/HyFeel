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
                    '1. Responsable de los Datos',
                    'El responsable legal del tratamiento de los datos recabados a través de la aplicación HyFeel es Manuel José Salamanca Tejada. Al utilizar esta aplicación, aceptas las prácticas descritas en este documento.',
                  ),

                  _construirSeccion(
                    '2. Naturaleza Bidireccional de HyFeel',
                    'HyFeel no es solo una herramienta educativa, sino un ecosistema de investigación. Mientras adquieres conocimientos sobre la tecnología del hidrógeno, los datos generales de uso nos permiten generar métricas de valor sobre las tendencias de aprendizaje, detectar dificultades formativas y evaluar el interés demográfico en el sector del hidrógeno.',
                  ),

                  _construirSeccion(
                    '3. Datos Recopilados',
                    'Para el correcto funcionamiento de la plataforma y la extracción de métricas, recopilamos:\n\n'
                        '• Datos de identidad: Nombre, apellidos y correo electrónico (estrictamente privados).\n'
                        '• Datos demográficos y de contexto: Ciudad/región de conexión (sin rastreo GPS exacto) y perfil profesional o académico (si se proporciona).\n'
                        '• Métricas de rendimiento: Módulos completados, tasa de acierto/fallo en los tests y tiempos de retención por pantalla.\n'
                        '• Feedback cualitativo: Respuestas a encuestas de satisfacción, valoraciones y sugerencias de mejora introducidas voluntariamente.',
                  ),

                  _construirSeccion(
                    '4. Uso, Comercialización y Cesión a Terceros',
                    'Tus datos personales directos (nombre, apellidos y correo electrónico) son confidenciales, NO se venden ni se ceden a terceros, y se utilizan exclusivamente para gestionar tu cuenta.\n\n'
                        'Sin embargo, la información relativa a tu progreso, demografía y feedback es sometida a un proceso de ANONIMIZACIÓN ABSOLUTA. Al aceptar estos términos, otorgas tu consentimiento explícito para que estos datos estadísticos agrupados (imposibles de vincular a tu identidad real) puedan ser almacenados, publicados o comercializados bajo licencia a terceros (como investigadores, universidades o empresas del sector energético) con fines de estudio analítico y desarrollo del sector.',
                  ),

                  _construirSeccion(
                    '5. Tus Derechos (RGPD)',
                    'Como usuario, conservas en todo momento el derecho a acceder, rectificar, limitar o solicitar la eliminación de tus datos personales.\n\n'
                        'Puedes ejercer estos derechos de dos maneras:\n'
                        '1. Dirigiendo un correo electrónico a la dirección: manueljsalamancatejada@gmail.com\n'
                        '2. Utilizando la función "Eliminar cuenta" disponible en la sección de Ajustes de la aplicación, lo cual borrará permanentemente tus registros vinculados de nuestra base de datos activa.',
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
