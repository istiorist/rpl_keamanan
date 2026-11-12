/// Model data untuk entitas Post.
///
/// Merepresentasikan struktur data post dari API JSONPlaceholder.
class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  /// Membuat instance [Post] dari JSON Map.
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'] ?? 0,
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }

  /// Mengonversi instance [Post] menjadi JSON Map.
  Map<String, dynamic> toJson() {
    return {'userId': userId, 'id': id, 'title': title, 'body': body};
  }
}
