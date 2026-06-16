import 'package:flutter/material.dart';
import 'dart:ui'; // Necesario para ImageFilter.blur

// PANTALLA DE CONEXIÓN (Maneja el estado del enlace con el ESP32)
class PantallaConexion extends StatefulWidget {
  //tiene un estado interno que puede cambiar
  const PantallaConexion({super.key});

  @override
  State<PantallaConexion> createState() => _PantallaConexionState();
}

class _PantallaConexionState extends State<PantallaConexion> {
  // --- VARIABLES DE ESTADO ---
  String estadoTexto = "Sistema Desconectado"; //inicial
  bool monitorizando = false;
  Color colorEstado = const Color.fromARGB(163, 7, 53, 221);

  // --- LÓGICA DE CONEXIÓN ---
  void cambiarEstado() {
    setState(() {
      monitorizando = !monitorizando;

      if (monitorizando) {
        estadoTexto = "Conectado. Recibiendo datos..."; // se pulsa el boton
        colorEstado = Colors.green;
      } else {
        estadoTexto =
            "Desconectado. Enlace Detenido"; // se pulsa y se desconecta
        colorEstado = Colors.red;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Usamos un Stack para superponer el desenfoque y el cartel sobre tu UI
    return Stack(
      children: [
        // 1. CAPA INFERIOR: Tu interfaz actual "congelada"
        AbsorbPointer(
          absorbing:
              true, // Esto desactiva cualquier interacción (clics en botones)
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/h2buttonicon.png',
                  height: 100,
                  color: colorEstado,
                ),
                const SizedBox(height: 30),
                const Text(
                  'Gestión del Enlace:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    estadoTexto,
                    style: TextStyle(fontSize: 16, color: colorEstado),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton.icon(
                  onPressed: cambiarEstado,
                  icon: Icon(
                    monitorizando
                        ? Icons.bluetooth_disabled
                        : Icons.bluetooth_connected,
                  ),
                  label: Text(
                    monitorizando
                        ? "DESCONECTAR EQUIPO"
                        : "VINCULAR ELECTROLIZADOR",
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 2. CAPA INTERMEDIA: Efecto de desenfoque (Blur)
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
            child: Container(
              color: Colors.white.withValues(
                alpha: 0.3,
              ), // Ligera capa blanca semitransparente
            ),
          ),
        ),

        // 3. CAPA SUPERIOR: Cartel de "¡En obras!"
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            decoration: BoxDecoration(
              color: Colors.orange.shade700,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.construction_rounded, color: Colors.white, size: 60),
                SizedBox(height: 15),
                Text(
                  '¡En obras!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'El enlace estará\ndisponible en breve.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
