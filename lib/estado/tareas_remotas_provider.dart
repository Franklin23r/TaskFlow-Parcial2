import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../datos/tareas_api.dart';
import '../modelos/tarea.dart';

/// Proporciona un cliente HTTP compartido y lo cierra al finalizar.
final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

/// Construye el servicio REST utilizando el cliente HTTP.
final tareasApiProvider = Provider<TareasApi>((ref) {
  final client = ref.watch(httpClientProvider);
  return TareasApi(client: client);
});

/// Administra la carga, recarga y creación de tareas remotas.
class TareasRemotasNotifier extends AsyncNotifier<List<Tarea>> {
  @override
  Future<List<Tarea>> build() {
    return ref.watch(tareasApiProvider).obtenerTareas();
  }

  /// Vuelve a consultar las tareas y controla los errores.
  Future<void> recargar() async {
    state = const AsyncLoading<List<Tarea>>();

    state = await AsyncValue.guard(
      () => ref.read(tareasApiProvider).obtenerTareas(),
    );
  }

  /// Crea una tarea y agrega el resultado a una lista nueva.
  Future<void> crear(Tarea tarea) async {
    final nuevaTarea =
        await ref.read(tareasApiProvider).crearTarea(tarea);

    final tareasActuales = state.asData?.value ?? <Tarea>[];

    state = AsyncData<List<Tarea>>([
      ...tareasActuales,
      nuevaTarea,
    ]);
  }
}

/// Provider que expone el estado asíncrono de las tareas remotas.
final tareasRemotasProvider =
    AsyncNotifierProvider<TareasRemotasNotifier, List<Tarea>>(
  TareasRemotasNotifier.new,
);

