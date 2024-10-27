import 'dart:math' as math;
import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cached_network_image/cached_network_image.dart';

class JustAudioPlayerWidget extends StatefulWidget {
  final String audioUrl;
  final String? albumArtUrl;

  const JustAudioPlayerWidget({
    super.key,
    required this.audioUrl,
    this.albumArtUrl,
  });

  @override
  State<JustAudioPlayerWidget> createState() => _JustAudioPlayerWidgetState();
}

class _JustAudioPlayerWidgetState extends State<JustAudioPlayerWidget>
    with TickerProviderStateMixin {
  late final AudioPlayer _audioPlayer;
  bool isPlaying = false;
  double playbackSpeed = 1.0;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  Color waweStartColor = const Color.fromARGB(255, 184, 9, 158);
  Color waweEndColor = const Color.fromARGB(255, 99, 9, 184);

  late AnimationController _iconAnimationController;
  late AnimationController _waveAnimationController;

  // StreamSubscription'ları tanımlayın
  late final StreamSubscription<PlayerState> _playerStateSubscription;
  late final StreamSubscription<Duration> _positionSubscription;
  late final StreamSubscription<Duration?> _durationSubscription;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initializeAudioPlayer();

    _iconAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _waveAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Stream dinleyicilerini başlatın ve Subscription'ları saklayın
    _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
      if (!mounted) return; // Widget ağaçta değilse setState çağırma
      setState(() {
        isPlaying = state.playing;
        if (isPlaying) {
          _iconAnimationController.forward();
          _waveAnimationController.repeat();
        } else {
          _iconAnimationController.reverse();
          _waveAnimationController.stop();
        }
      });
    });

    _positionSubscription = _audioPlayer.positionStream.listen((newPosition) {
      if (!mounted) return;
      setState(() {
        position = newPosition;
      });
    });

    _durationSubscription = _audioPlayer.durationStream.listen((newDuration) {
      if (!mounted) return;
      setState(() {
        duration = newDuration ?? Duration.zero;
      });
    });
  }

  void _initializeAudioPlayer() async {
    try {
      await _audioPlayer.setUrl(widget.audioUrl);
    } catch (e) {
      if (kDebugMode) {
        print('Ses kaynağı ayarlanırken hata oluştu: $e');
      }
      if (mounted) {
        // Widget ağaçta olup olmadığını kontrol edin
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ses kaynağı yüklenemedi: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    // StreamSubscription'ları iptal edin
    _playerStateSubscription.cancel();
    _positionSubscription.cancel();
    _durationSubscription.cancel();

    _audioPlayer.dispose();
    _iconAnimationController.dispose();
    _waveAnimationController.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    await _audioPlayer.play();
    // setState() burada zaten dinleyicilerden gelecektir, ekstra setState gerekmez
  }

  Future<void> _pauseAudio() async {
    await _audioPlayer.pause();
    // setState() burada zaten dinleyicilerden gelecektir, ekstra setState gerekmez
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Album Sanatı
                if (widget.albumArtUrl != null &&
                    widget.albumArtUrl!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.albumArtUrl!,
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Container(
                        height: 150,
                        width: 150,
                        color: Colors.grey[300],
                        child: const Icon(Icons.music_note,
                            size: 80, color: Colors.white),
                      ),
                    ),
                  )
                else
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.music_note,
                        size: 80, color: Colors.white),
                  ),
                const SizedBox(height: 24),

                // Play/Pause Kontrolleri
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.fast_rewind,
                          color: Colors.white, size: 30),
                      onPressed: () {
                        _audioPlayer
                            .seek(position - const Duration(seconds: 15));
                      },
                    ),
                    GestureDetector(
                      onTap: isPlaying ? _pauseAudio : _playAudio,
                      child: AnimatedIcon(
                        icon: AnimatedIcons.play_pause,
                        progress: _iconAnimationController,
                        size: 64,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.fast_forward,
                          color: Colors.white, size: 30),
                      onPressed: () {
                        _audioPlayer
                            .seek(position + const Duration(seconds: 15));
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Zaman Çizelgesi ve Zaman Bilgisi
                Row(
                  children: [
                    Text(
                      _formatDuration(position),
                      style: const TextStyle(color: Colors.white),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.blueAccent,
                          inactiveTrackColor: Colors.grey[300],
                          thumbColor: Colors.blueAccent,
                          overlayColor: Colors.blueAccent.withAlpha(32),
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 8.0),
                          overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 16.0),
                        ),
                        child: Slider(
                          min: 0,
                          max: duration.inSeconds.toDouble(),
                          value: position.inSeconds
                              .clamp(0, duration.inSeconds)
                              .toDouble(),
                          onChanged: (value) {
                            _audioPlayer.seek(Duration(seconds: value.toInt()));
                          },
                        ),
                      ),
                    ),
                    Text(
                      _formatDuration(duration),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Dalga Formu Animasyonu
                AnimatedBuilder(
                  animation: _waveAnimationController,
                  builder: (context, child) {
                    return Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: CustomPaint(
                        painter: WavePainter(
                            position,
                            duration,
                            _waveAnimationController.value,
                            waweStartColor,
                            waweEndColor),
                        child: Container(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Dalga Formu Painter
class WavePainter extends CustomPainter {
  final Duration position;
  final Duration duration;
  final double animationValue;
  final Color startColor; // Gradyan başlangıç rengi
  final Color endColor; // Gradyan bitiş rengi

  WavePainter(this.position, this.duration, this.animationValue,
      this.startColor, this.endColor);

  @override
  void paint(Canvas canvas, Size size) {
    if (duration.inSeconds == 0) return;

    double progress = position.inSeconds / duration.inSeconds;

    // Gradyan renk eklemek için Paint içinde Shader kullanımı
    Paint paint = Paint()
      ..shader = LinearGradient(
        colors: [startColor.withOpacity(0.5), endColor.withOpacity(0.5)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    Path path = Path();

    // Dalga formu için sabit bir faz ekleyerek animasyon
    double phase = animationValue * 2 * math.pi;

    for (double i = 0; i <= size.width; i += 4) {
      double normalizedX = i / size.width;
      double y = size.height / 2 +
          20 * math.sin((normalizedX * 2 * math.pi) + phase) * (1 - progress);
      if (i == 0) {
        path.moveTo(i, y);
      } else {
        path.lineTo(i, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return oldDelegate.position != position ||
        oldDelegate.duration != duration ||
        oldDelegate.animationValue != animationValue ||
        oldDelegate.startColor !=
            startColor || // Başlangıç rengini kontrol edin
        oldDelegate.endColor != endColor; // Bitiş rengini kontrol edin
  }
}
