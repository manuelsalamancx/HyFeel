import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

void verificarYMostrarOnboarding(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool seenLocally = prefs.getBool('seenOnboarding') ?? false;

  // 1. Filtro rápido: Si este móvil ya sabe que lo rellenó, salimos al instante
  if (seenLocally) return;

  // 2. Filtro definitivo en la nube: Comprobamos si el usuario actual ya existe en la colección
  String? userUid = FirebaseAuth.instance.currentUser?.uid;

  if (userUid != null) {
    try {
      var query = await FirebaseFirestore.instance
          .collection('metricas_analiticas')
          .where('uid', isEqualTo: userUid)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        // ¡El usuario ya lo rellenó en el pasado desde otro móvil!
        // Actualizamos la memoria de ESTE teléfono para no volver a preguntarle a Firebase
        await prefs.setBool('seenOnboarding', true);
        return; // Salimos sin mostrar el pop-up
      }
    } catch (e) {
      debugPrint('Error comprobando si existe el usuario: $e');
      // Si falla la conexión, dejamos que siga y muestre el pop-up por si acaso
    }
  }

  // 3. Si llegamos aquí, es un usuario genuinamente nuevo en la app.
  // Lanzamos el pop-up flotante con fondo difuminado
  if (context.mounted) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Obliga a rellenarlo (no se cierra al tocar fuera)
      builder: (BuildContext context) {
        // Variables locales para capturar las selecciones dentro del diálogo
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
          filter: ImageFilter.blur(
            sigmaX: 8.0,
            sigmaY: 8.0,
          ), // El difuminado de fondo
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
                          ),
                          onPressed: () async {
                            if (!formKey.currentState!.validate()) return;

                            try {
                              // Obtenemos el ID único del usuario actual logueado
                              String? currentUserUid =
                                  FirebaseAuth.instance.currentUser?.uid;

                              // Guardamos los datos limpios vinculados a su cuenta
                              await FirebaseFirestore.instance
                                  .collection('metricas_analiticas')
                                  .add({
                                    'uid': currentUserUid ?? 'anonimo',
                                    'ciudad': selectedProvince,
                                    'perfil': selectedProfile,
                                    'area_conocimiento': selectedArea,
                                    'nivel_previo': selectedKnowledgeLevel,
                                    'timestamp': FieldValue.serverTimestamp(),
                                  });

                              // Bloqueamos localmente para que nunca vuelva a saltar en este dispositivo
                              await prefs.setBool('seenOnboarding', true);

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
                          child: const Text('Comenzar'),
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
