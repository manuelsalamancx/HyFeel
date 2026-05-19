// =========================================================================
// SERVICIO DE NOTIFICACIONES (notificaciones.dart)
// =========================================================================
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'dart:math'; // <--- AÑADE ESTO ARRIBA

// Este manejador debe estar fuera de cualquier clase (Top-level)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint(
    "Notificación push recibida en segundo plano: ${message.messageId}",
  );
}

class ServicioNotificaciones {
  static final FlutterLocalNotificationsPlugin _localPlugin =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // ID fijo para el recordatorio, para poder sobrescribirlo o cancelarlo fácilmente
  static const int _idRecordatorio = 999;

  static Future<void> inicializar() async {
    // 1. Inicializar la base de datos de zonas horarias (Crítico para programar en el futuro)
    tz.initializeTimeZones();

    // 2. Solicitar permisos al usuario (iOS y Android 13+)
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    // 3. Configurar Firebase Cloud Messaging (Push)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Suscribir al usuario a un "topic" global para envíos masivos
    await _fcm.subscribeToTopic('todos');

    // 4. Configurar Notificaciones Locales
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('launch_background');
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _localPlugin.initialize(settings: settings);

    // 5. Programar el recordatorio automático al abrir la app
    await programarRecordatorioInactividad();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        // Usamos el hashcode del mensaje como ID para que no se pisen si llegan varios
        mostrarNotificacionLocal(
          id: message.hashCode,
          titulo: message.notification!.title ?? 'Aviso de HyFeel',
          cuerpo: message.notification!.body ?? '',
        );
      }
    });
  }

  // =========================================================================
  // LÓGICA DE RETENCIÓN: RECORDATORIO A LOS 3 DÍAS
  // =========================================================================
  static Future<void> programarRecordatorioInactividad() async {
    // Primero, cancelamos cualquier recordatorio previo (AHORA USA ETIQUETA 'id:')
    await _localPlugin.cancel(id: _idRecordatorio);

    // Comprobamos si el usuario tiene las notificaciones encendidas en Ajustes
    final prefs = await SharedPreferences.getInstance();
    final activas = prefs.getBool('notificaciones_activas') ?? true;

    if (!activas) return;

    // Calculamos el momento exacto: Ahora mismo + 3 días
    final momentoDisparo = tz.TZDateTime.now(
      tz.UTC,
    ).add(const Duration(days: 1));

    final List<Map<String, String>> mensajes = [
      {
        'titulo': '¡El mundo te necesita! 🌍',
        'cuerpo':
            'Tu conocimiento sobre el hidrógeno se está enfriando a -253º. Se va a convertir en líquido.',
      },
      {
        'titulo': '¡Recarga tus pilas! 🔋',
        'cuerpo':
            'Mantén tu racha de aprendizaje activa. Un par de módulos al día marcan la diferencia.',
      },
      {
        'titulo': '¡El H₂ no descansa! 💨',
        'cuerpo':
            '¿Te acuerdas de cómo funcionaba la electrólisis? Entra un momento y pon a prueba tu memoria.',
      },
      {
        'titulo': 'Presión estabilizada 🌡️',
        'cuerpo':
            'Es un gran momento para revisar los módulos de teoría y comprobar tus avances.',
      },
    ];

    final random = Random();
    final mensajeSeleccionado = mensajes[random.nextInt(mensajes.length)];

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'canal_retencion_hyfeel',
          'Recordatorios de Inactividad',
          channelDescription:
              'Avisos automáticos si pasas días sin entrar a la app',
          importance: Importance.max,
          priority: Priority.high,
          icon: 'launch_background',
          color: Color.fromARGB(255, 13, 71, 161),
        );

    await _localPlugin.zonedSchedule(
      id: _idRecordatorio,
      title: mensajeSeleccionado['titulo']!,
      body: mensajeSeleccionado['cuerpo']!,
      scheduledDate: momentoDisparo,
      notificationDetails: const NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  // =========================================================================
  // NOTIFICACIONES INSTANTÁNEAS
  // =========================================================================
  static Future<void> mostrarNotificacionLocal({
    required int id,
    required String titulo,
    required String cuerpo,
  }) async {
    // Comprobar ajustes antes de mostrar
    final prefs = await SharedPreferences.getInstance();
    final activas = prefs.getBool('notificaciones_activas') ?? true;

    if (!activas) return;

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'canal_educativo_hyfeel',
          'Avisos Educativos HyFeel',
          channelDescription: 'Recordatorios y logros de aprendizaje',
          importance: Importance.max,
          priority: Priority.high,
          icon: 'launch_background',
          color: Color.fromARGB(255, 13, 71, 161),
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _localPlugin.show(
      id: id,
      title: titulo,
      body: cuerpo,
      notificationDetails: details,
    );
  }

  // =========================================================================
  // GESTIÓN DEL INTERRUPTOR DE AJUSTES
  // =========================================================================
  static Future<void> establecerEstadoNotificaciones(bool activas) async {
    if (activas) {
      await _fcm.subscribeToTopic('todos');
      await programarRecordatorioInactividad(); // Reactivar el contador de inactividad
    } else {
      await _fcm.unsubscribeFromTopic('todos');
      await _localPlugin.cancelAll(); // Borrar cualquier alerta programada
    }
  }
}
