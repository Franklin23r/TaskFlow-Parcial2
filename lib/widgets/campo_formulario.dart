import 'package:flutter/material.dart';

class CampoFormulario extends StatelessWidget {
  final TextEditingController controller;
  final String etiqueta;
  final IconData icono;
  final String? Function(String?) validator;
  final bool ocultarTexto;
  final TextInputType tipoTeclado;
  final void Function(String)? onChanged;

  const CampoFormulario({
    super.key,
    required this.controller,
    required this.etiqueta,
    required this.icono,
    required this.validator,
    this.ocultarTexto = false,
    this.tipoTeclado = TextInputType.text,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: ocultarTexto,
      keyboardType: tipoTeclado,
      validator: validator,
      onChanged: onChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: etiqueta,
        prefixIcon: Icon(icono),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
