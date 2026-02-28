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
      // SafeArea evita que el texto se tape con la barra de estado del móvil
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Cargamos la imagen de los assets
          image: DecorationImage(
            image: AssetImage('assets/images/background_home.png'),
            // 'cover' asegura que la imagen llene todo el espacio sin deformarse,
            // recortando los bordes si es necesario.
            fit: BoxFit.cover,
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0), // Margen general de 24 píxeles
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // Estira los hijos a lo ancho
              children: [
                const SizedBox(height: 40), // Espacio vacío vertical
                // --- SECCIÓN 1: TÍTULO ---
                Text(
                  "Bienvenido a HyFeel.",
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(134, 188, 233, 1),
                    height: 1.2,
                  ),
                ),
                //--- SECCIÓN SUBTITULO
                Text.rich(
                  TextSpan(
                    // 1. ESTILO BASE (Afecta a toda la frase por defecto)
                    style: TextStyle(
                      fontFamily: 'MifuenteTFG',
                      fontSize: 33,
                      color: Color.fromRGBO(134, 188, 233, 1),
                    ),
                    children: [
                      // 2. PRIMERA PARTE (Normal)
                      const TextSpan(text: "Tu app para formación en "),

                      // 3. SEGUNDA PARTE (Solo la palabra 'futuro' en negrita)
                      TextSpan(
                        text: "futuro.",
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold, // <--- Aquí activamos la negrita
                          color: Color.fromRGBO(134, 188, 233, 1),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                Container(
                  height: 150,

                  // Define una altura fija para mantener el diseño estable
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Image.asset(
                    'assets/images/logohome.png', // La ruta EXACTA
                    fit: BoxFit
                        .contain, // Ajusta la imagen sin recortarla ni deformarla
                  ),
                ),

                const SizedBox(height: 20),
                const Spacer(),
                // --- SECCIÓN 3: BOTONES DE NAVEGACIÓN ---
                // He extraído el diseño del botón a un widget propio abajo para no repetir código
                _BotonAcceso(
                  icono: Icons.insights,
                  titulo: "Monitorización",
                  subtitulo: "Datos en Tiempo Real",
                  colorFondo: Color.fromRGBO(135, 200, 253, 1),
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

                const SizedBox(height: 10), // Separación entre botones

                _BotonAcceso(
                  icono: Icons.school,
                  titulo: "Aprende sobre H2",
                  subtitulo: "Zona Didáctica",
                  colorFondo: Color.fromRGBO(135, 200, 253, 1),
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

                const SizedBox(height: 10), // Separación entre botones

                _BotonAcceso(
                  icono: Icons.quiz,
                  titulo: "Convierte en experto",
                  subtitulo: "Zona Evaluación",
                  colorFondo: Color.fromRGBO(135, 200, 253, 1),
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

                const SizedBox(height: 20),
              ],
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
