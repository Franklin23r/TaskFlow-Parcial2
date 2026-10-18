import 'package:flutter/material.dart';

import '../widgets/campo_formulario.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmacionController = TextEditingController();

  bool _aceptaTerminos = false;
  bool _cargando = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmacionController.dispose();
    super.dispose();
  }

  String? _validarNombre(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Escribe tu nombre.';
    }
    return null;
  }

  String? _validarEmail(String? valor) {
    final email = valor?.trim() ?? '';
    final formato = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!formato.hasMatch(email)) {
      return 'Escribe un correo válido.';
    }
    return null;
  }

  String? _validarPassword(String? valor) {
    if (valor == null || valor.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres.';
    }
    return null;
  }

  String? _validarConfirmacion(String? valor) {
    if (valor != _passwordController.text) {
      return 'Las contraseñas no coinciden.';
    }
    return null;
  }

  Future<void> _registrar() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (!_aceptaTerminos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes aceptar los términos para continuar.'),
        ),
      );
      return;
    }

    setState(() => _cargando = true);

    await Future<void>.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    setState(() => _cargando = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Registro simulado correctamente. Ahora puedes iniciar sesión.',
        ),
      ),
    );

    Navigator.pop(context, _emailController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.person_add_alt_1, size: 64),
                  const SizedBox(height: 12),
                  Text(
                    'Regístrate en TaskFlow',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 24),
                  CampoFormulario(
                    controller: _nombreController,
                    etiqueta: 'Nombre completo',
                    icono: Icons.person_outline,
                    validator: _validarNombre,
                  ),
                  const SizedBox(height: 16),
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
                    onChanged: (_) {
                      if (_confirmacionController.text.isNotEmpty) {
                        _formKey.currentState?.validate();
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  CampoFormulario(
                    controller: _confirmacionController,
                    etiqueta: 'Confirmar contraseña',
                    icono: Icons.lock_reset,
                    ocultarTexto: true,
                    validator: _validarConfirmacion,
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _aceptaTerminos,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text('Acepto los términos y condiciones'),
                    onChanged: _cargando
                        ? null
                        : (valor) {
                            setState(() {
                              _aceptaTerminos = valor ?? false;
                            });
                          },
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _cargando ? null : _registrar,
                    child: _cargando
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Crear cuenta'),
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

