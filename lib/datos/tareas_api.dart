import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../modelos/tarea.dart';

/// Error controlado para los problemas de comunicación con la API.
class ApiException implements Exception {
  final String mensaje;
  final int? codigo;

  ApiException(this.mensaje, {this.codigo});

  @override
  String toString() {
    if (codigo != null) {
      return 'ApiException ($codigo): $mensaje';
    }
    return 'ApiException: $mensaje';
  }
}

/// Servicio responsable de toda la comunicación con la API REST.
class TareasApi {
  final http.Client _client;

  static final Uri _baseUri =
      Uri.parse('https://jsonplaceholder.typicode.com');

  TareasApi({required http.Client client}) : _client = client;

  /// Consulta las primeras 15 tareas.
  Future<List<Tarea>> obtenerTareas() async {
    final uri = _baseUri.replace(
      path: '/todos',
      queryParameters: {'_limit': '15'},
    );

    final response = await _ejecutar(
      () => _client.get(uri),
    );

    if (response.statusCode != 200) {
      throw ApiException(
        'No se pudieron consultar las tareas.',
        codigo: response.statusCode,
      );
    }

    try {
      final dynamic datos = jsonDecode(response.body);

      if (datos is! List) {
        throw const FormatException('La respuesta no es una lista.');
      }

      return datos.map((elemento) {
        if (elemento is! Map) {
          throw const FormatException('Una tarea tiene formato inválido.');
        }

        return Tarea.fromJson(Map<String, dynamic>.from(elemento));
      }).toList();
    } on FormatException {
      throw ApiException('La API devolvió datos con formato inválido.');
    } on TypeError {
      throw ApiException('No se pudieron interpretar las tareas recibidas.');
    }
  }

  /// Envía una nueva tarea y espera una respuesta HTTP 201.
  Future<Tarea> crearTarea(Tarea tarea) async {
    final uri = _baseUri.replace(path: '/todos');

    final response = await _ejecutar(
      () => _client.post(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(tarea.toJson()),
      ),
    );

    if (response.statusCode != 201) {
      throw ApiException(
        'No se pudo crear la tarea.',
        codigo: response.statusCode,
      );
    }

    try {
      final dynamic datos = jsonDecode(response.body);

      if (datos is! Map) {
        throw const FormatException('La respuesta no es un objeto.');
      }

      return Tarea.fromJson(Map<String, dynamic>.from(datos));
    } on FormatException {
      throw ApiException('La API devolvió una tarea con formato inválido.');
    } on TypeError {
      throw ApiException('No se pudo interpretar la tarea creada.');
    }
  }

  /// Aplica un límite de tiempo y convierte errores de conexión.
  Future<T> _ejecutar<T>(Future<T> Function() solicitud) async {
    try {
      return await solicitud().timeout(
        const Duration(seconds: 10),
      );
    } on TimeoutException {
      throw ApiException(
        'La solicitud tardó demasiado. Intenta nuevamente.',
      );
    } on http.ClientException {
      throw ApiException(
        'No se pudo conectar con el servidor. '
        'Verifica tu conexión a internet.',
      );
    }
  }
}
