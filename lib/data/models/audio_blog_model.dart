// lib/models/audio_blog.dart

class AudioBlog {
  final int id;
  final String title;
  final String content;
  final String imageUrl;
  final DateTime createdAt;
  final String audioUrl;

  AudioBlog({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.createdAt,
    required this.audioUrl,
  });

  factory AudioBlog.fromJson(Map<String, dynamic> json) {
    return AudioBlog(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['cover_image'] ?? '',
      createdAt:
          DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      audioUrl: json['audio_url'] ?? '',
    );
  }
}
