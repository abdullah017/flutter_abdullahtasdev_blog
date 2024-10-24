import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/controllers/audio_blog_detail_controller.dart';

class AudioBlogDetailPage extends StatelessWidget {
  final int blogId; // Blog ID parametresi

  const AudioBlogDetailPage({
    super.key,
    required this.blogId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AudioBlogDetailController());
    controller.loadAudioBlog(blogId); // Blog verisini yüklemek için çağırıyoruz

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.title.value)), // Başlığı dinliyoruz
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Quill Delta içeriğini HTML formatına dönüştürüyoruz
        final List<Map<String, dynamic>> delta =
            jsonDecode(controller.content.value);
        final converter = QuillDeltaToHtmlConverter(delta);
        final htmlContent = converter.convert(); // Delta'dan HTML'e dönüştürme

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık
              Text(
                controller.title.value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Tarih
              Text(
                'Tarih: ${controller.date.value}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),

              // Blog görseli
              if (controller.imageUrl.value.isNotEmpty) ...[
                Image.network(controller.imageUrl.value),
                const SizedBox(height: 16),
              ],

              // Blog içeriği
              Html(data: htmlContent), // HTML içeriği burada render ediliyor

              const SizedBox(height: 16),

              // Sesli blog oynatıcı
              const Text(
                'Ses Dosyası',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              AudioPlayerWidget(audioUrl: controller.audioUrl.value),
            ],
          ),
        );
      }),
    );
  }
}

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerWidget({super.key, required this.audioUrl});

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  double playbackSpeed = 1.0;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    await _audioPlayer.setSourceUrl(widget.audioUrl);
    await _audioPlayer.setPlaybackRate(playbackSpeed);
    await _audioPlayer.resume();
    setState(() {
      isPlaying = true;
    });
  }

  Future<void> _pauseAudio() async {
    await _audioPlayer.pause();
    setState(() {
      isPlaying = false;
    });
  }

  void _changeSpeed(double speed) {
    setState(() {
      playbackSpeed = speed;
    });
    _audioPlayer.setPlaybackRate(speed);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: isPlaying ? _pauseAudio : _playAudio,
              child: Text(isPlaying ? 'Durdur' : 'Oynat'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Ses hızını değiştirme butonları
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => _changeSpeed(0.5),
              child: const Text('0.5x'),
            ),
            ElevatedButton(
              onPressed: () => _changeSpeed(1.0),
              child: const Text('1.0x'),
            ),
            ElevatedButton(
              onPressed: () => _changeSpeed(1.5),
              child: const Text('1.5x'),
            ),
            ElevatedButton(
              onPressed: () => _changeSpeed(2.0),
              child: const Text('2.0x'),
            ),
          ],
        ),
      ],
    );
  }
}
