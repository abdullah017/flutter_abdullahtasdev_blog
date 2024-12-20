import 'package:abdullahtasdev/data/models/audio_blog_model.dart';
import 'package:abdullahtasdev/presentation/frontend/widgets/audio_player/audioplayer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class AudioBlogDetailContent extends StatelessWidget {
  final AudioBlog audioBlog;

  const AudioBlogDetailContent({super.key, required this.audioBlog});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  Text(
                    'Tarih: ${_formatDate(audioBlog.createdAt)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: HtmlWidget(
                      audioBlog.content,
                      textStyle: const TextStyle(
                        fontSize: 16.0,
                        height: 1.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (audioBlog.audioUrl.isNotEmpty)
                    JustAudioPlayerWidget(audioUrl: audioBlog.audioUrl)
                  else
                    const Text('Ses dosyası bulunamadı.',
                        style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
