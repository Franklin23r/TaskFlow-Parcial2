import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../estado/publicaciones_provider.dart';
import '../modelos/publicacion.dart';
import 'login_screen.dart';

class ListadoScreen extends ConsumerStatefulWidget {
  final String email;

  const ListadoScreen({
    super.key,
    required this.email,
  });

  @override
  ConsumerState<ListadoScreen> createState() => _ListadoScreenState();
}

class _ListadoScreenState extends ConsumerState<ListadoScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_detectarFinal);
  }

  void _detectarFinal() {
    if (!_scrollController.hasClients) return;

    final posicion = _scrollController.position;
    if (posicion.pixels >= posicion.maxScrollExtent - 250) {
      ref.read(publicacionesProvider.notifier).cargarMas();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_detectarFinal);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _actualizar() async {
    await ref.read(publicacionesProvider.notifier).recargar();
  }

  Future<void> _cerrarSesion() async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  Widget _tarjetaPublicacion(Publicacion publicacion) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Publicación #${publicacion.id}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              publicacion.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(publicacion.body),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final publicacionesAsync = ref.watch(publicacionesProvider);
    final notifier = ref.read(publicacionesProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Publicaciones'),
        actions: [
          IconButton(
            tooltip: 'Actualizar publicaciones',
            onPressed: _actualizar,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: _cerrarSesion,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                const Icon(Icons.account_circle_outlined),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.email,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: publicacionesAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.wifi_off, size: 48),
                      const SizedBox(height: 12),
                      const Text(
                        'No pudimos cargar las publicaciones. '
                        'Revisa tu conexión e inténtalo de nuevo.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: _actualizar,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (publicaciones) {
                if (publicaciones.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _actualizar,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 150),
                        Center(child: Text('No hay publicaciones.')),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _actualizar,
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: publicaciones.length +
                        (notifier.hayMas || notifier.cargandoMas ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < publicaciones.length) {
                        return _tarjetaPublicacion(publicaciones[index]);
                      }

                      if (notifier.errorPaginacion != null) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(notifier.errorPaginacion!),
                              TextButton(
                                onPressed: () async {
                                  await notifier.cargarMas();
                                  if (mounted) setState(() {});
                                },
                                child: const Text('Reintentar carga'),
                              ),
                            ],
                          ),
                        );
                      }

                      if (notifier.cargandoMas) {
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: Text('Desliza para cargar más'),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

