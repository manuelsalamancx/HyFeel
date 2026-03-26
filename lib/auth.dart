import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';

// ============================================================================
// PUERTA DE ENLACE (AUTH GATE)
// ============================================================================
class PuertaAutenticacion extends StatelessWidget {
  const PuertaAutenticacion({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFE1F5FE),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF01579B)),
            ),
          );
        }
        if (snapshot.hasData) {
          return const PaginaBase();
        }
        return const PantallaLogin();
      },
    );
  }
}

// ============================================================================
// WIDGET REUTILIZABLE: CAMPO DE TEXTO MODERNO
// ============================================================================
Widget _construirCampoTextoModerno({
  required TextEditingController controlador,
  required IconData icono,
  required String etiqueta,
  bool ocultarTexto = false,
  TextInputType tipoTeclado = TextInputType.text,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.9),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: TextField(
      controller: controlador,
      obscureText: ocultarTexto,
      keyboardType: tipoTeclado,
      style: const TextStyle(fontSize: 16, color: Colors.black87),
      decoration: InputDecoration(
        prefixIcon: Icon(icono, color: const Color(0xFF01579B)),
        labelText: etiqueta,
        labelStyle: const TextStyle(color: Colors.black54),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    ),
  );
}

// ============================================================================
// PANTALLA DE LOGIN
// ============================================================================
class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _iniciarSesion() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String mensaje = 'Error al iniciar sesión.';
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        mensaje = 'Correo o contraseña incorrectos.';
      } else if (e.code == 'invalid-email') {
        mensaje = 'El formato del correo no es válido.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensaje), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE1F5FE), Color(0xFF4FC3F7)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              physics: const BouncingScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF01579B).withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.water_drop,
                        size: 60,
                        color: Color(0xFF01579B),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'HyFeel',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF01579B),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Monitorización y Didáctica H₂',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 40),
                    _construirCampoTextoModerno(
                      controlador: _emailController,
                      icono: Icons.email_outlined,
                      etiqueta: 'Correo Institucional',
                      tipoTeclado: TextInputType.emailAddress,
                    ),
                    _construirCampoTextoModerno(
                      controlador: _passwordController,
                      icono: Icons.lock_outline,
                      etiqueta: 'Contraseña',
                      ocultarTexto: true,
                    ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF01579B),
                                foregroundColor: Colors.white,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              onPressed: _iniciarSesion,
                              child: const Text(
                                'Entrar al Sistema',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PantallaRegistro(),
                          ),
                        );
                      },
                      child: const Text(
                        '¿Nuevo usuario? Crea tu cuenta',
                        style: TextStyle(
                          color: Color(0xFF0277BD),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// PANTALLA DE REGISTRO AMPLIADA
// ============================================================================
class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  // Controladores ampliados
  final _nombreController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _registrarUsuario() async {
    // 1. Validación local básica
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Las contraseñas no coinciden.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    if (_nombreController.text.isEmpty || _apellidosController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, rellena tus datos personales.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      // 2. Crear credenciales en Auth
      UserCredential credencial = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      // 3. Guardar el perfil ampliado en Firestore
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(credencial.user!.uid)
          .set({
            'nombre': _nombreController.text.trim(),
            'apellidos': _apellidosController.text.trim(),
            'ciudad': _ciudadController.text.trim(),
            'email': _emailController.text.trim(),
            'fechaRegistro': FieldValue.serverTimestamp(),
            'modulosCompletados': [],
            'testsCompletados': [],
          });

      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String mensaje = 'Error al registrarse.';
      if (e.code == 'weak-password') {
        mensaje = 'La contraseña debe tener al menos 6 caracteres.';
      } else if (e.code == 'email-already-in-use') {
        mensaje = 'Este correo ya está registrado.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensaje), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidosController.dispose();
    _ciudadController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF01579B)),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFFE1F5FE), Color(0xFF4FC3F7)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 10.0,
            ),
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const Icon(
                  Icons.person_add_alt_1,
                  size: 50,
                  color: Color(0xFF01579B),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Crear Perfil',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF01579B),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Completa tus datos para comenzar',
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
                const SizedBox(height: 30),

                // Formulario dentro de una tarjeta translúcida
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.8),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Datos Personales
                      _construirCampoTextoModerno(
                        controlador: _nombreController,
                        icono: Icons.person_outline,
                        etiqueta: 'Nombre',
                      ),
                      _construirCampoTextoModerno(
                        controlador: _apellidosController,
                        icono: Icons.badge_outlined,
                        etiqueta: 'Apellidos',
                      ),
                      _construirCampoTextoModerno(
                        controlador: _ciudadController,
                        icono: Icons.location_city_outlined,
                        etiqueta: 'Ciudad de residencia',
                      ),
                      const Divider(
                        color: Colors.black12,
                        height: 30,
                        thickness: 1,
                      ),

                      // Credenciales de Acceso
                      _construirCampoTextoModerno(
                        controlador: _emailController,
                        icono: Icons.email_outlined,
                        etiqueta: 'Correo Electrónico',
                        tipoTeclado: TextInputType.emailAddress,
                      ),
                      _construirCampoTextoModerno(
                        controlador: _passwordController,
                        icono: Icons.lock_outline,
                        etiqueta: 'Contraseña',
                        ocultarTexto: true,
                      ),
                      _construirCampoTextoModerno(
                        controlador: _confirmPasswordController,
                        icono: Icons.lock_reset,
                        etiqueta: 'Confirmar Contraseña',
                        ocultarTexto: true,
                      ),
                      const SizedBox(height: 10),

                      _isLoading
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF01579B),
                                  foregroundColor: Colors.white,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                onPressed: _registrarUsuario,
                                child: const Text(
                                  'Completar Registro',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
