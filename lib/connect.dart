import 'package:flutter/material.dart';

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
    //constructor
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Icono dinámico (Optimizado: se eliminó el operador ternario redundante)
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

          // Botón de Acción
          ElevatedButton.icon(
            onPressed: cambiarEstado,
            icon: Icon(
              monitorizando
                  ? Icons.bluetooth_disabled
                  : Icons.bluetooth_connected,
            ),
            label: Text(
              monitorizando ? "DESCONECTAR EQUIPO" : "VINCULAR ELECTROLIZADOR",
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            ),
          ),
        ],
      ),
    );
  }
}
