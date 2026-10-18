class Publicacion {
  final int id;
  final int userId;
  final String title;
  final String body;

  const Publicacion({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory Publicacion.fromJson(Map<String, dynamic> json) {
    return Publicacion(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}
