import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../datos/publicaciones_api.dart';
import '../modelos/publicacion.dart';

final publicacionesHttpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final publicacionesApiProvider = Provider<PublicacionesApi>((ref) {
  return PublicacionesApi(
    client: ref.watch(publicacionesHttpClientProvider),
  );
});

final publicacionesProvider =
    AsyncNotifierProvider<PublicacionesNotifier, List<Publicacion>>(
  PublicacionesNotifier.new,
);

class PublicacionesNotifier extends AsyncNotifier<List<Publicacion>> {
  static const int _limite = 15;

  int _pagina = 1;
  bool _hayMas = true;
  bool _cargandoMas = false;
  String? _errorPaginacion;

  bool get cargandoMas => _cargandoMas;
  bool get hayMas => _hayMas;
  String? get errorPaginacion => _errorPaginacion;

  @override
  Future<List<Publicacion>> build() async {
    _pagina = 1;
    _hayMas = true;
    _cargandoMas = false;
    _errorPaginacion = null;

    final publicaciones =
        await ref.watch(publicacionesApiProvider).obtenerPagina(
              pagina: 1,
              limite: _limite,
            );

    _hayMas = publicaciones.length == _limite;
    return publicaciones;
  }

  Future<void> recargar() async {
    if (_cargandoMas) return;

    state = const AsyncLoading<List<Publicacion>>();

    _pagina = 1;
    _hayMas = true;
    _errorPaginacion = null;

    state = await AsyncValue.guard(
      () => ref.read(publicacionesApiProvider).obtenerPagina(
            pagina: 1,
            limite: _limite,
          ),
    );

    final datos = state.asData?.value;
    if (datos != null) {
      _hayMas = datos.length == _limite;
    }
  }

  Future<void> cargarMas() async {
    if (_cargandoMas || !_hayMas || state.asData == null) return;

    _cargandoMas = true;
    _errorPaginacion = null;
    final siguientePagina = _pagina + 1;

    try {
      final nuevas = await ref
          .read(publicacionesApiProvider)
          .obtenerPagina(
            pagina: siguientePagina,
            limite: _limite,
          );

      final actuales = state.asData?.value ?? <Publicacion>[];

      _pagina = siguientePagina;
      _hayMas = nuevas.length == _limite;

      state = AsyncData< List<Publicacion> >([
        ...actuales,
        ...nuevas,
      ]);
    } catch (_) {
      _errorPaginacion =
          'No se pudieron cargar más publicaciones. Intenta nuevamente.';
    } finally {
      _cargandoMas = false;
    }
  }
}
