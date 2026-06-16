import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

void verificarYMostrarOnboarding(BuildContext context) async {
  // Obtenemos el UID antes de nada para aislar la memoria por usuario
  String? userUid = FirebaseAuth.instance.currentUser?.uid;
  if (userUid == null) return; // Si no hay usuario activo, cortamos

  SharedPreferences prefs = await SharedPreferences.getInstance();

  // 1. Filtro rápido: Comprobamos si ESTE usuario ya lo rellenó en ESTE móvil
  String claveMemoriaLocal = 'onboarding_$userUid';
  bool seenLocally = prefs.getBool(claveMemoriaLocal) ?? false;

  if (seenLocally) return;

  // 2. Filtro definitivo en la nube: Miramos directamente en su perfil de usuario
  try {
    var userDoc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(userUid)
        .get();

    if (userDoc.exists) {
      var datos = userDoc.data()!;
      // Si ya tiene la marca de completado en su perfil, guardamos local y no mostramos
      if (datos.containsKey('onboardingCompletado') &&
          datos['onboardingCompletado'] == true) {
        await prefs.setBool(claveMemoriaLocal, true);
        return;
      }
    }
  } catch (e) {
    debugPrint('Error comprobando el estado del onboarding: $e');
  }

  // 3. Si llegamos aquí, es un usuario nuevo (Clásico o Google). Lanzamos el pop-up.
  if (context.mounted) {
    showDialog(
      context: context,
      barrierDismissible: false, // Obliga a rellenarlo
      builder: (BuildContext context) {
        String? selectedProvince;
        String? selectedProfile;
        String? selectedArea;
        String? selectedKnowledgeLevel;

        final List<String> provinces = [
          'Álava',
          'Albacete',
          'Alicante',
          'Almería',
          'Asturias',
          'Ávila',
          'Badajoz',
          'Barcelona',
          'Burgos',
          'Cáceres',
          'Cádiz',
          'Cantabria',
          'Castellón',
          'Ciudad Real',
          'Córdoba',
          'Cuenca',
          'Gerona',
          'Granada',
          'Guadalajara',
          'Guipúzcoa',
          'Huelva',
          'Huesca',
          'Islas Baleares',
          'Jaén',
          'La Coruña',
          'La Rioja',
          'Las Palmas',
          'León',
          'Lérida',
          'Lugo',
          'Madrid',
          'Málaga',
          'Murcia',
          'Navarra',
          'Orense',
          'Palencia',
          'Pontevedra',
          'Salamanca',
          'Segovia',
          'Sevilla',
          'Soria',
          'Tarragona',
          'Tenerife',
          'Teruel',
          'Toledo',
          'Valencia',
          'Valladolid',
          'Vizcaya',
          'Zamora',
          'Zaragoza',
          'Ceuta',
          'Melilla',
        ];

        final List<String> profiles = [
          'Estudiante',
          'Profesional del sector',
          'Curioso / Hobby',
        ];

        final List<String> areas = [
          'Ingeniería y Tecnología',
          'Ciencias Exactas y Naturales',
          'Ciencias de la Salud',
          'Ciencias Sociales y Jurídicas',
          'Arte y Humanidades',
          'Otra',
        ];

        final List<String> knowledgeLevels = [
          'Nulo (No sé qué es)',
          'Básico (Sé qué es, pero poco más)',
          'Avanzado (Conozco tecnologías y vectores)',
        ];

        final formKey = GlobalKey<FormState>();

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              '¡Antes de empezar!',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Configura tu perfil.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        // Dropdown 1: Provincia
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Provincia',
                            border: OutlineInputBorder(),
                          ),
                          initialValue: selectedProvince,
                          items: provinces
                              .map(
                                (p) =>
                                    DropdownMenuItem(value: p, child: Text(p)),
                              )
                              .toList(),
                          onChanged: (val) =>
                              setState(() => selectedProvince = val),
                          validator: (val) =>
                              val == null ? 'Selecciona una provincia' : null,
                        ),
                        const SizedBox(height: 15),

                        // Dropdown 2: Perfil
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Perfil',
                            border: OutlineInputBorder(),
                          ),
                          initialValue: selectedProfile,
                          items: profiles
                              .map(
                                (p) =>
                                    DropdownMenuItem(value: p, child: Text(p)),
                              )
                              .toList(),
                          onChanged: (val) =>
                              setState(() => selectedProfile = val),
                          validator: (val) =>
                              val == null ? 'Selecciona un perfil' : null,
                        ),
                        const SizedBox(height: 15),

                        // Dropdown 3: Área
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Área de conocimiento',
                            border: OutlineInputBorder(),
                          ),
                          initialValue: selectedArea,
                          items: areas
                              .map(
                                (p) =>
                                    DropdownMenuItem(value: p, child: Text(p)),
                              )
                              .toList(),
                          onChanged: (val) =>
                              setState(() => selectedArea = val),
                          validator: (val) =>
                              val == null ? 'Selecciona un área' : null,
                        ),
                        const SizedBox(height: 15),

                        // Dropdown 4: Nivel
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Conocimiento previo H2',
                            border: OutlineInputBorder(),
                          ),
                          initialValue: selectedKnowledgeLevel,
                          items: knowledgeLevels
                              .map(
                                (p) =>
                                    DropdownMenuItem(value: p, child: Text(p)),
                              )
                              .toList(),
                          onChanged: (val) =>
                              setState(() => selectedKnowledgeLevel = val),
                          validator: (val) =>
                              val == null ? 'Selecciona un nivel' : null,
                        ),
                        const SizedBox(height: 25),

                        // Botón de confirmación
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            backgroundColor: const Color.fromARGB(
                              255,
                              13,
                              71,
                              161,
                            ),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            if (!formKey.currentState!.validate()) return;

                            try {
                              // 1. Enviamos los datos limpios a Firebase para BigQuery
                              await FirebaseFirestore.instance
                                  .collection('metricas_analiticas')
                                  .add({
                                    'uid': userUid,
                                    'ciudad': selectedProvince,
                                    'perfil': selectedProfile,
                                    'area_conocimiento': selectedArea,
                                    'nivel_previo': selectedKnowledgeLevel,
                                    'timestamp': FieldValue.serverTimestamp(),
                                  });

                              // 2. NUEVO: Marcamos en su perfil de usuario que ya lo ha completado
                              await FirebaseFirestore.instance
                                  .collection('usuarios')
                                  .doc(userUid)
                                  .set({
                                    'onboardingCompletado': true,
                                  }, SetOptions(merge: true));

                              // 3. Bloqueamos localmente vinculado al UID
                              await prefs.setBool(claveMemoriaLocal, true);

                              if (context.mounted) Navigator.of(context).pop();
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error al guardar: $e'),
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text(
                            'Comenzar',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
