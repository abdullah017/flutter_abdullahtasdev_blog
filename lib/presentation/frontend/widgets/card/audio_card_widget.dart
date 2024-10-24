import 'dart:math';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waveform_flutter/waveform_flutter.dart'; // waveform_flutter paketini eklediğinizden emin olun

// wave_flutter paketinden Amplitude sınıfını kullanıyoruz, kendi Amplitude sınıfınızı tanımlamayın.

class AudioBlogCard extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String date;
  final String audioUrl;

  const AudioBlogCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.date,
    required this.audioUrl,
  });

  @override
  _AudioBlogCardState createState() => _AudioBlogCardState();
}

class _AudioBlogCardState extends State<AudioBlogCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isHovered = false;
  html.AudioElement? _audioElement;
  bool isPlayingPreview = false;

  @override
  void initState() {
    super.initState();
    // AnimationController'ı başlatın
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Animasyonu tanımlayın (0'dan pi'ye)
    _animation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Animasyon durumu dinleyicisi
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isHovered = true;
        });
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          isHovered = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioElement?.pause();
    _audioElement = null;
    super.dispose();
  }

  void _onHover(bool hovering) {
    if (hovering) {
      _controller.forward();
      _playPreview();
    } else {
      _controller.reverse();
      _stopPreview();
    }
  }

  void _playPreview() {
    if (!isPlayingPreview && widget.audioUrl.isNotEmpty) {
      setState(() {
        isPlayingPreview = true;
      });
      print('Playing audio from URL: ${widget.audioUrl}');
      _audioElement?.pause(); // Varolan sesi durdur
      _audioElement = html.AudioElement(widget.audioUrl)
        ..autoplay = true
        ..onEnded.listen((event) {
          print('Audio playback completed.');
          setState(() {
            isPlayingPreview = false;
          });
        })
        ..onError.listen((event) {
          print('Error playing audio.');
          setState(() {
            isPlayingPreview = false;
          });
          // Hata mesajı göstermek için SnackBar ekleyebilirsiniz
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ses oynatılırken bir hata oluştu.')),
          );
        });
      // 30 saniye sonra durdur
      Future.delayed(const Duration(seconds: 30), () {
        if (mounted) {
          // Widget hala mounted ise
          _stopPreview();
        }
      });
    }
  }

  void _stopPreview() {
    if (isPlayingPreview) {
      _audioElement?.pause();
      _audioElement?.currentTime = 0;
      setState(() {
        isPlayingPreview = false;
      });
      print('Audio preview stopped.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          // Ön yüz mü yoksa arka yüz mü görünecek
          bool isFront = _animation.value < (pi / 2);
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspektif ekleyin
              ..rotateY(_animation.value),
            child: Stack(
              children: [
                // Ön Yüz
                Visibility(
                  visible: isFront,
                  child: _FrontCardContent(
                    title: widget.title,
                    imageUrl: widget.imageUrl,
                    date: widget.date,
                  ),
                ),
                // Arka Yüz
                Visibility(
                  visible: !isFront,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(pi),
                    child: _BackCardContent(
                      stopPreview: _stopPreview,
                      audioUrl: widget.audioUrl,
                      isPlayingPreview: isPlayingPreview,
                      waveformData: [], // wave_flutter paketinde dalga verisi gerekmiyor
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FrontCardContent extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String date;

  const _FrontCardContent({
    required this.title,
    required this.imageUrl,
    required this.date,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Tarihi formatlayın
    final DateTime parsedDate = DateTime.parse(date);
    final String formattedDate = DateFormat('dd.MM.yyyy').format(parsedDate);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Blog resmi
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Blog başlığı
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Blog tarihi
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              formattedDate,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackCardContent extends StatefulWidget {
  final VoidCallback stopPreview;
  final String audioUrl;
  final bool isPlayingPreview;
  final List<double> waveformData;

  const _BackCardContent({
    required this.stopPreview,
    required this.audioUrl,
    required this.isPlayingPreview,
    required this.waveformData,
  });

  @override
  _BackCardContentState createState() => _BackCardContentState();
}

class _BackCardContentState extends State<_BackCardContent> {
  late Stream<Amplitude> _amplitudeStream;

  @override
  void initState() {
    super.initState();
    if (widget.isPlayingPreview) {
      _amplitudeStream = createRandomAmplitudeStream();
    }
  }

  @override
  void didUpdateWidget(covariant _BackCardContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlayingPreview && !oldWidget.isPlayingPreview) {
      _amplitudeStream = createRandomAmplitudeStream();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Stream<Amplitude> createRandomAmplitudeStream() async* {}
  Stream<Amplitude> createRandomAmplitudeStream() async* {
    yield* Stream.periodic(
      const Duration(milliseconds: 70),
      (count) => Amplitude(
        current: Random().nextDouble() * 100,
        max: 100,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey[900],
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Eğer ses çalıyor ise dalga göster, değilse metin göster
            widget.isPlayingPreview
                ? SizedBox(
                    height: 100,
                    child: AnimatedWaveList(
                      stream:
                          _amplitudeStream, // Amplitude stream doğrudan kullanılıyor
                    ),
                  )
                : const Text(
                    'Şimdi Dinle',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                widget.stopPreview(); // Önizlemeyi durdur
                // Detay sayfasına yönlendirme
                Navigator.pushNamed(context, '/audio_blog_detail',
                    arguments: widget.audioUrl);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text('Devamını Dinle'),
            ),
          ],
        ),
      ),
    );
  }
}
