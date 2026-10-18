import 'package:flutter/material.dart';

import '../widgets/campo_formulario.dart';
import 'listado_screen.dart';
import 'registro_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _cargando = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validarEmail(String? valor) {
    final email = valor?.trim() ?? '';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Escribe un correo electrónico válido.';
    }
    return null;
  }

  String? _validarPassword(String? valor) {
    if (valor == null || valor.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres.';
    }
    return null;
  }

  Future<void> _abrirRegistro() async {
    final email = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => const RegistroScreen(),
      ),
    );

    if (!mounted) return;

    if (email != null && email.isNotEmpty) {
      _emailController.text = email;
    }
  }

  Future<void> _iniciarSesion() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _cargando = true;
      _error = null;
    });

    await Future<void>.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    setState(() => _cargando = false);

    final email = _emailController.text.trim();

    if (email.toLowerCase() == 'incorrecto@ejemplo.com') {
      setState(() {
        _error = 'Correo o contraseña incorrectos. Intenta nuevamente.';
      });
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ListadoScreen(email: email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.task_alt, size: 76),
                  const SizedBox(height: 16),
                  Text(
                    'TaskFlow',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Inicia sesión para continuar',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  CampoFormulario(
                    controller: _emailController,
                    etiqueta: 'Correo electrónico',
                    icono: Icons.email_outlined,
                    tipoTeclado: TextInputType.emailAddress,
                    validator: _validarEmail,
                  ),
                  const SizedBox(height: 16),
                  CampoFormulario(
                    controller: _passwordController,
                    etiqueta: 'Contraseña',
                    icono: Icons.lock_outline,
                    ocultarTexto: true,
                    validator: _validarPassword,
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _cargando ? null : _iniciarSesion,
                    child: _cargando
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Iniciar sesión'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _cargando ? null : _abrirRegistro,
                    child: const Text('¿No tienes cuenta? Regístrate'),
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
