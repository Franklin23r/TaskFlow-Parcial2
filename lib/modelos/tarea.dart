 // ignore_for_file: avoid_print
// (Los print vienen de la Semana 3; se conservan para no romper ejercicios previos.)

/// Clase Tarea de TaskFlow.
class Tarea {
  int? id;
  String titulo;
  String descripcion;
  DateTime fechaLimite;
  bool completada = false;
  String categoria;

  int _prioridad; // 1 = baja, 2 = media, 3 = alta

  Tarea({
    this.id,
    required this.titulo,
    this.descripcion = '',
    required this.fechaLimite,
    this.categoria = 'General',
    int prioridad = 2,
  }) : _prioridad = prioridad;

  /// Convierte una tarea recibida desde JSON.
  factory Tarea.fromJson(Map<String, dynamic> json) {
    final tituloJson = json['title'];

    if (tituloJson is! String || tituloJson.trim().isEmpty) {
      throw FormatException(
        'La tarea recibida no tiene un título válido.',
      );
    }

    final tarea = Tarea(
      id: json['id'] is int ? json['id'] as int : null,
      titulo: tituloJson,
      fechaLimite: DateTime.now(),
      categoria: 'General',
      prioridad: 2,
    );

    tarea.completada =
        json['completed'] is bool ? json['completed'] as bool : false;

    return tarea;
  }

  /// Convierte la tarea al formato que espera la API.
  Map<String, dynamic> toJson() {
    return {
      'title': titulo,
      'completed': completada,
      'userId': 1,
    };
  }

  int get prioridad => _prioridad;

  set prioridad(int valor) {
    if (valor >= 1 && valor <= 3) {
      _prioridad = valor;
    } else {
      print('La prioridad debe estar entre 1 (baja) y 3 (alta).');
    }
  }

  /// Texto legible de la prioridad para mostrar en la interfaz.
  String get prioridadTexto => switch (_prioridad) {
        1 => 'Baja',
        3 => 'Alta',
        _ => 'Media',
      };

  void completar() {
    completada = true;
  }

  @override
  String toString() {
    final estado = completada ? 'completada' : 'pendiente';
    return '[$categoria] $titulo (prioridad $_prioridad, $estado)';
  }
}
