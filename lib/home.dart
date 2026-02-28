import 'package:flutter/material.dart';
import 'main.dart';

class PantallaHome extends StatefulWidget {
  const PantallaHome({super.key});

  @override
  State<PantallaHome> createState() => _PantallaHomeState();
}

class _PantallaHomeState extends State<PantallaHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background_home.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          // 1. AÑADIDO: SingleChildScrollView para permitir el desplazamiento
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  // --- SECCIÓN 1: TÍTULO ---
                  Text(
                    "Bienvenido a HyFeel.",
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color.fromRGBO(134, 188, 233, 1),
                      height: 1.2,
                    ),
                  ),

                  // --- SECCIÓN 2: SUBTÍTULO ---
                  const Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontFamily:
                            'MiFuenteTFG', // Corregida la mayúscula para coincidir con el main
                        fontSize: 33,
                        color: Color.fromRGBO(134, 188, 233, 1),
                      ),
                      children: [
                        TextSpan(text: "Tu app para formación en "),
                        TextSpan(
                          text: "futuro.",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // LOGO
                  Container(
                    height: 150,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Image.asset(
                      'assets/images/logohome.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  // 2. ELIMINADO: const Spacer(),
                  // Lo sustituimos por un espacio fijo para que empuje los botones un poco hacia abajo
                  const SizedBox(height: 40),

                  // --- SECCIÓN 3: BOTONES DE NAVEGACIÓN ---
                  _BotonAcceso(
                    icono: Icons.insights,
                    titulo: "Inicio",
                    subtitulo: "Descubre todo y más",
                    colorFondo: const Color.fromRGBO(135, 200, 253, 1),
                    colorTexto: Colors.white,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const PaginaBase(indiceInicial: 0),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  _BotonAcceso(
                    icono: Icons.school,
                    titulo: "Aprende sobre H2",
                    subtitulo: "Zona Didáctica",
                    colorFondo: const Color.fromRGBO(135, 200, 253, 1),
                    colorTexto: Colors.white,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const PaginaBase(indiceInicial: 1),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  _BotonAcceso(
                    icono: Icons.quiz,
                    titulo: "Convierte en experto",
                    subtitulo: "Zona Evaluación",
                    colorFondo: const Color.fromRGBO(135, 200, 253, 1),
                    colorTexto: Colors.white,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const PaginaBase(indiceInicial: 2),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  _BotonAcceso(
                    icono: Icons.wifi,
                    titulo: "Monitorización",
                    subtitulo: "Datos en tiempo real",
                    colorFondo: const Color.fromRGBO(135, 200, 253, 1),
                    colorTexto: Colors.white,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          // 3. CORREGIDO: Cambiado de 1 a 3 para ir a la pestaña de Conexión
                          builder: (context) =>
                              const PaginaBase(indiceInicial: 3),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  _BotonAcceso(
                    icono: Icons.settings,
                    titulo: "Ajustes",
                    subtitulo: "",
                    colorFondo: const Color.fromRGBO(135, 200, 253, 1),
                    colorTexto: Colors.white,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          // 3. CORREGIDO: Cambiado de 1 a 3 para ir a la pestaña de Conexión
                          builder: (context) =>
                              const PaginaBase(indiceInicial: 3),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ), // Margen inferior extra para que el último botón no quede pegado al final al scrollear
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- WIDGET AUXILIAR (COMPONENTE REUTILIZABLE) ---
// Esto es buena práctica de ingeniería: "Don't Repeat Yourself" (DRY)
class _BotonAcceso extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String subtitulo;
  final Color colorFondo;
  final Color colorTexto;
  final VoidCallback onTap;

  const _BotonAcceso({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.colorFondo,
    required this.colorTexto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colorFondo,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias, // Recorta el efecto de "ola" al pulsar
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Row(
            children: [
              Icon(icono, size: 40, color: colorTexto),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorTexto,
                      ),
                    ),
                    Text(
                      subtitulo,
                      style: TextStyle(
                        fontSize: 14,
                        color: colorTexto.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward,
                color: colorTexto.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
