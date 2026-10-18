import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../estado/tareas_remotas_provider.dart';
import '../modelos/tarea.dart';
import 'nueva_tarea_screen.dart';

class TareasRemotasScreen extends ConsumerWidget {
  const TareasRemotasScreen({super.key});

  Future<void> _crearTarea(BuildContext context, WidgetRef ref) async {
    final nueva = await Navigator.push<Tarea>(
      context,
      MaterialPageRoute(
        builder: (_) => const NuevaTareaScreen(),
      ),
    );

    if (!context.mounted || nueva == null) return;

    try {
      await ref.read(tareasRemotasProvider.notifier).crear(nueva);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tarea "${nueva.titulo}" enviada a la API'),
        ),
      );
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo crear la tarea: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tareasAsync = ref.watch(tareasRemotasProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas en la nube'),
        actions: [
          IconButton(
            tooltip: 'Recargar tareas',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(tareasRemotasProvider.notifier).recargar();
            },
          ),
        ],
      ),
      body: tareasAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.cloud_off,
                  size: 56,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No se pudieron cargar las tareas.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(tareasRemotasProvider.notifier).recargar();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
        data: (tareas) {
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(tareasRemotasProvider.notifier).recargar(),
            child: tareas.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 180),
                      Center(child: Text('No hay tareas remotas.')),
                    ],
                  )
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: tareas.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final tarea = tareas[index];

                      return ListTile(
                        leading: Icon(
                          tarea.completada
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: tarea.completada ? Colors.green : null,
                        ),
                        title: Text(tarea.titulo),
                        subtitle: Text(
                          tarea.completada ? 'Completada' : 'Pendiente',
                        ),
                      );
                    },
                  ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _crearTarea(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Nueva tarea'),
      ),
    );
  }
}
