import 'dart:isolate';
import 'package:flutter/material.dart';

/// SEMANA 14 - SESIÓN 1 (sección 1.8): esperar no es lo mismo que trabajar.
class ExperimentoIsolateScreen extends StatefulWidget {
  const ExperimentoIsolateScreen({super.key});

  @override
  State<ExperimentoIsolateScreen> createState() =>
      _ExperimentoIsolateScreenState();
}

const int _iteraciones = 400000000;

int calculoPesado(int n) {
  var total = 0;
  for (var i = 0; i < n; i++) {
    total += i % 7;
  }
  return total;
}

/// Ejecuta el cálculo en el hilo principal.
Future<int> sinIsolate() async {
  return calculoPesado(_iteraciones);
}

/// Ejecuta el mismo cálculo en otro isolate.
Future<int> conIsolate() async {
  return Isolate.run(() => calculoPesado(_iteraciones));
}

class _ExperimentoIsolateScreenState
    extends State<ExperimentoIsolateScreen> {
  String _resultado = 'Presiona un botón y observa el indicador.';
  bool _ocupado = false;

  Future<void> _ejecutar(
      String nombre, Future<int> Function() tarea) async {
    setState(() {
      _ocupado = true;
      _resultado = 'Ejecutando "$nombre"...';
    });

    final reloj = Stopwatch()..start();
    String mensaje;

    try {
      final valor = await tarea();
      mensaje = '$nombre: resultado $valor en '
          '${reloj.elapsedMilliseconds} ms';
    } catch (e) {
      mensaje = '$nombre: ocurrió un error: $e';
    }

    if (!mounted) return;

    setState(() {
      _ocupado = false;
      _resultado = mensaje;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Experimento: isolates')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _ocupado
                  ? null
                  : () => _ejecutar('Sin isolate', sinIsolate),
              child: const Text('Sin isolate'),
            ),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: _ocupado
                  ? null
                  : () => _ejecutar('Con isolate', conIsolate),
              child: const Text('Con isolate'),
            ),
            const SizedBox(height: 24),
            Text(_resultado, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
