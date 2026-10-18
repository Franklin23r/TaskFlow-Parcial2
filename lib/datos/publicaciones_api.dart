import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../modelos/publicacion.dart';

class PublicacionesApiException implements Exception {
  final String mensaje;

  const PublicacionesApiException(this.mensaje);

  @override
  String toString() => mensaje;
}

class PublicacionesApi {
  final http.Client _client;

  static final Uri _baseUri =
      Uri.parse('https://jsonplaceholder.typicode.com');

  PublicacionesApi({required http.Client client})
      : _client = client;

  Future<List<Publicacion>> obtenerPagina({
    required int pagina,
    int limite = 15,
  }) async {
    final uri = _baseUri.replace(
      path: '/posts',
      queryParameters: {
        '_page': '$pagina',
        '_limit': '$limite',
      },
    );

    late http.Response response;

    try {
      response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw const PublicacionesApiException(
        'La solicitud tardó demasiado. Intenta nuevamente.',
      );
    } on http.ClientException {
      throw const PublicacionesApiException(
        'No se pudo conectar. Revisa tu conexión a internet.',
      );
    }

    if (response.statusCode != 200) {
      throw PublicacionesApiException(
        'No se pudieron cargar las publicaciones '
        '(HTTP ${response.statusCode}).',
      );
    }

    try {
      final dynamic datos = jsonDecode(response.body);

      if (datos is! List) {
        throw const FormatException();
      }

      return datos.map((elemento) {
        if (elemento is! Map) {
          throw const FormatException();
        }

        return Publicacion.fromJson(
          Map<String, dynamic>.from(elemento),
        );
      }).toList();
    } on FormatException {
      throw const PublicacionesApiException(
        'El servidor devolvió datos con formato inválido.',
      );
    } on TypeError {
      throw const PublicacionesApiException(
        'No se pudieron interpretar las publicaciones.',
      );
    }
  }
}
