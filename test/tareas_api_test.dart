import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:taskflow/datos/tareas_api.dart';

class ClientePrueba extends http.BaseClient {
  final Future<http.StreamedResponse> Function(http.BaseRequest request)
      respuesta;

  ClientePrueba(this.respuesta);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return respuesta(request);
  }
}

http.StreamedResponse respuestaHttp(int codigo, String cuerpo) {
  return http.StreamedResponse(
    Stream.value(utf8.encode(cuerpo)),
    codigo,
  );
}

void main() {
  group('Pruebas de errores de TareasApi', () {
    test('Error 500 del servidor se controla correctamente', () async {
      final cliente = ClientePrueba(
        (_) async => respuestaHttp(500, 'Error del servidor'),
      );
      final api = TareasApi(client: cliente);

      await expectLater(
        api.obtenerTareas(),
        throwsA(
          isA<ApiException>().having(
            (error) => error.codigo,
            'código HTTP',
            500,
          ),
        ),
      );

      cliente.close();
    });

    test('Respuesta JSON inválida se controla correctamente', () async {
      final cliente = ClientePrueba(
        (_) async => respuestaHttp(200, 'esto no es JSON'),
      );
      final api = TareasApi(client: cliente);

      await expectLater(
        api.obtenerTareas(),
        throwsA(isA<ApiException>()),
      );

      cliente.close();
    });

    test('Error de conexión se controla correctamente', () async {
      final cliente = ClientePrueba(
        (_) async => throw http.ClientException('Conexión fallida'),
      );
      final api = TareasApi(client: cliente);

      await expectLater(
        api.obtenerTareas(),
        throwsA(
          isA<ApiException>().having(
            (error) => error.mensaje,
            'mensaje',
            contains('conexión a internet'),
          ),
        ),
      );

      cliente.close();
    });

    test('Tiempo de espera se controla correctamente', () async {
      final cliente = ClientePrueba((_) async {
        await Future<void>.delayed(const Duration(seconds: 11));
        return respuestaHttp(200, '[]');
      });
      final api = TareasApi(client: cliente);

      await expectLater(
        api.obtenerTareas(),
        throwsA(
          isA<ApiException>().having(
            (error) => error.mensaje,
            'mensaje',
            contains('demasiado'),
          ),
        ),
      );

      cliente.close();
    });
  });
}
