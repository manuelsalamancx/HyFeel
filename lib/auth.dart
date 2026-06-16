import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'main.dart';
import 'terminos.dart';

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
          // Comprueba si el usuario está logueado Y tiene el correo verificado
          if (snapshot.data!.emailVerified) {
            return const PaginaBase();
          } else {
            // El usuario no está verificado.
            // Usamos Future.microtask para cerrar sesión DESPUÉS de dibujar la pantalla
            // y evitar que Flutter se quede pillado (congelado) durante el build.
            Future.microtask(() => FirebaseAuth.instance.signOut());
            return const PantallaLogin();
          }
        }
        return const PantallaLogin();
      },
    );
  }
}

// ============================================================================
// WIDGETS REUTILIZABLES
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

Widget _construirBotonSocial({
  required String texto,
  required IconData icono,
  required Color colorIcono,
  required VoidCallback onPressed,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    height: 50,
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icono, color: colorIcono),
          const SizedBox(width: 10),
          Text(
            texto,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
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

  // Método para iniciar sesión por correo
  Future<void> _iniciarSesion() async {
    setState(() => _isLoading = true);
    try {
      UserCredential credencial = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      // Comprobar si el correo es real/verificado
      if (credencial.user != null && !credencial.user!.emailVerified) {
        await FirebaseAuth.instance.signOut();
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Debes verificar tu correo para poder entrar. Revisa tu bandeja de entrada o Spam.',
              ),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 4),
            ),
          );
        }
        return;
      }
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

  // Método para iniciar sesión con Google
  Future<void> _iniciarSesionGoogle() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        if (mounted) setState(() => _isLoading = false);
        return; // El usuario cerró el pop-up de Google
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCred = await FirebaseAuth.instance
          .signInWithCredential(credential);

      // Si es la primera vez que entra con Google, guardamos su nombre en Firestore
      if (userCred.additionalUserInfo?.isNewUser == true) {
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(userCred.user!.uid)
            .set({
              'nombre': userCred.user!.displayName ?? 'Usuario',
              'apellidos': '',
              'email': userCred.user!.email ?? '',
              'fechaRegistro': FieldValue.serverTimestamp(),
              'modulosCompletados': [],
              'testsCompletados': [],
              'terminosAceptados': true,
            });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al iniciar sesión con Google.'),
          backgroundColor: Colors.redAccent,
        ),
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
                      etiqueta: 'Correo Electrónico',
                      tipoTeclado: TextInputType.emailAddress,
                    ),
                    _construirCampoTextoModerno(
                      controlador: _passwordController,
                      icono: Icons.lock_outline,
                      etiqueta: 'Contraseña',
                      ocultarTexto: true,
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const PantallaRecuperacion(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 0,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          '¿Has olvidado tu contraseña?',
                          style: TextStyle(
                            color: Color(0xFF01579B),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
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
                                'Inicia sesión',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),

                    // --- SECCIÓN DE INICIO SOCIAL ---
                    const Row(
                      children: [
                        Expanded(child: Divider(color: Colors.black26)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "O entra con",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.black26)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    _construirBotonSocial(
                      texto: 'Continuar con Google',
                      icono: Icons.g_mobiledata,
                      colorIcono: Colors.red,
                      onPressed: _iniciarSesionGoogle,
                    ),

                    // ---------------------------------
                    const SizedBox(height: 10),
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
// PANTALLA DE REGISTRO AMPLIADA (CON TÉRMINOS Y PRIVACIDAD)
// ============================================================================
class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final _nombreController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _terminosAceptados = false;

  Future<void> _registrarUsuario() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Las contraseñas no coinciden.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La contraseña debe tener al menos 6 caracteres.'),
          backgroundColor: Colors.orange,
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
    if (!_terminosAceptados) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Debes aceptar la Política de Privacidad para continuar.',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      UserCredential credencial = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      // Enviar correo de verificación
      await credencial.user?.sendEmailVerification();

      // Guardar el perfil en Firestore
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(credencial.user!.uid)
          .set({
            'nombre': _nombreController.text.trim(),
            'apellidos': _apellidosController.text.trim(),
            'email': _emailController.text.trim(),
            'fechaRegistro': FieldValue.serverTimestamp(),
            'modulosCompletados': [],
            'testsCompletados': [],
            'terminosAceptados': true,
            'fechaAceptacion': FieldValue.serverTimestamp(),
          });

      // Cerramos sesión silenciosamente para forzar la verificación.
      await FirebaseAuth.instance.signOut();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '¡Registro exitoso! Revisa tu correo (y el Spam) para verificar tu cuenta antes de entrar.',
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
          ),
        );

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const PuertaAutenticacion()),
          (Route<dynamic> route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String mensaje = 'Error al registrarse.';
      if (e.code == 'weak-password') {
        mensaje = 'La contraseña debe tener al menos 6 caracteres.';
      } else if (e.code == 'email-already-in-use') {
        mensaje = 'Este correo ya está registrado.';
      } else if (e.code == 'invalid-email') {
        mensaje = 'El formato del correo es inválido.';
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
                      const Divider(
                        color: Colors.black12,
                        height: 30,
                        thickness: 1,
                      ),

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

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _terminosAceptados,
                            activeColor: const Color(0xFF01579B),
                            onChanged: (bool? valor) {
                              setState(() {
                                _terminosAceptados = valor ?? false;
                              });
                            },
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final bool? aceptado = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PantallaTerminos(),
                                  ),
                                );
                                if (aceptado == true) {
                                  setState(() {
                                    _terminosAceptados = true;
                                  });
                                }
                              },
                              child: const Text(
                                'He leído y acepto la Política de Privacidad y Condiciones de Uso.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF01579B),
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
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

// ============================================================================
// PANTALLA DE RECUPERACIÓN DE CONTRASEÑA
// ============================================================================
class PantallaRecuperacion extends StatefulWidget {
  const PantallaRecuperacion({super.key});

  @override
  State<PantallaRecuperacion> createState() => _PantallaRecuperacionState();
}

class _PantallaRecuperacionState extends State<PantallaRecuperacion> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _enviarCorreoRecuperacion() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, introduce tu correo electrónico.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enlace enviado! Revisa tu bandeja de Spam.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String mensaje = 'Error al enviar el correo.';
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        mensaje = 'El correo ingresado no es válido o no está registrado.';
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE1F5FE), Color(0xFF4FC3F7)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Icon(
                  Icons.mark_email_read_outlined,
                  size: 80,
                  color: Color(0xFF01579B),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Recuperar Acceso',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF01579B),
                  ),
                ),
                const SizedBox(height: 15),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Introduce la dirección de correo electrónico asociada a tu cuenta. Te enviaremos un enlace seguro para restablecer tu contraseña.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.orange.shade800,
                              size: 24,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Por favor, revisa también tu carpeta de Spam o Correo no deseado si no ves el mensaje en tu bandeja principal.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange.shade900,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),

                      _construirCampoTextoModerno(
                        controlador: _emailController,
                        icono: Icons.email_outlined,
                        etiqueta: 'Correo Electrónico',
                        tipoTeclado: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 10),

                      _isLoading
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF01579B),
                                  foregroundColor: Colors.white,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                onPressed: _enviarCorreoRecuperacion,
                                child: const Text(
                                  'Enviar Enlace',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
