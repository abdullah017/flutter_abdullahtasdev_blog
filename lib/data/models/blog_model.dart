// lib/models/blog.dart

class Blog {
  final int id;
  final String title;
  final String coverImage;
  final String content;
  final DateTime createdAt;

  Blog({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.content,
    required this.createdAt,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Başlık Yok',
      coverImage: json['cover_image'] ?? '',
      content: json['content'] ?? '',
      createdAt:
          DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
    );
  }
}
