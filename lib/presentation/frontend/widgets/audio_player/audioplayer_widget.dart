import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'dart:math' as math;

class JustAudioPlayerWidget extends StatefulWidget {
  final String audioUrl;
  final String? albumArtUrl; // Album sanatı için opsiyonel URL

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

  late StreamSubscription<PlayerState> _playerStateSubscription;
  late StreamSubscription<Duration> _positionSubscription;
  late StreamSubscription<Duration?> _durationSubscription;

  // İki ayrı Animasyon Kontrolcüsü
  late AnimationController _iconAnimationController;
  late AnimationController _waveAnimationController;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initializeAudioPlayer();

    // Icon Animation Controller (Play/Pause)
    _iconAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.0,
      upperBound: 1.0,
    );

    // Wave Animation Controller (Dalga)
    _waveAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Başlangıçta duruma göre animasyon değerini ayarlayın
    _audioPlayer.playerStateStream.first.then((state) {
      if (mounted) {
        setState(() {
          isPlaying = state.playing;
          if (isPlaying) {
            _iconAnimationController.value = 1.0;
            _waveAnimationController.repeat();
          } else {
            _iconAnimationController.value = 0.0;
            _waveAnimationController.stop();
          }
        });
      }
    });
  }

  void _initializeAudioPlayer() {
    // Oynatıcı durumunu dinleme
    _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
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

    // Pozisyon değişikliklerini dinleme
    _positionSubscription = _audioPlayer.positionStream.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });

    // Toplam süre değişikliklerini dinleme
    _durationSubscription = _audioPlayer.durationStream.listen((newDuration) {
      setState(() {
        duration = newDuration ?? Duration.zero;
      });
    });

    // Ses kaynağını ayarlama
    _setAudioSource();
  }

  Future<void> _setAudioSource() async {
    try {
      await _audioPlayer.setUrl(widget.audioUrl);
    } catch (e) {
      if (kDebugMode) {
        print('Ses kaynağı ayarlanırken hata oluştu: $e');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ses kaynağı yüklenemedi: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _playerStateSubscription.cancel();
    _positionSubscription.cancel();
    _durationSubscription.cancel();
    _audioPlayer.dispose();
    _iconAnimationController.dispose();
    _waveAnimationController.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    try {
      await _audioPlayer.setSpeed(playbackSpeed);
      await _audioPlayer.play();
    } catch (e) {
      if (kDebugMode) {
        print('Ses oynatılırken hata oluştu: $e');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ses oynatılamadı: $e')),
        );
      }
    }
  }

  Future<void> _pauseAudio() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      if (kDebugMode) {
        print('Ses durdurulurken hata oluştu: $e');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ses durdurulamadı: $e')),
        );
      }
    }
  }

  Future<void> _seekAudio(Duration newPosition) async {
    try {
      await _audioPlayer.seek(newPosition);
    } catch (e) {
      if (kDebugMode) {
        print('Ses arası pozisyona gidilirken hata oluştu: $e');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ses konumuna gidilemedi: $e')),
        );
      }
    }
  }

  void _changeSpeed(double speed) {
    setState(() {
      playbackSpeed = speed;
    });
    _audioPlayer.setSpeed(speed);
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Album Sanatı
            if (widget.albumArtUrl != null && widget.albumArtUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: widget.albumArtUrl!,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Container(
                    height: 200,
                    width: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.music_note,
                        size: 100, color: Colors.white),
                  ),
                ),
              )
            else
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.music_note,
                    size: 100, color: Colors.white),
              ),
            const SizedBox(height: 24),

            // Oynatma Kontrolleri
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 15 Saniye Geri
                IconButton(
                  icon: const Icon(Icons.fast_rewind,
                      color: Colors.blueAccent, size: 30),
                  onPressed: () {
                    _seekAudio(position - const Duration(seconds: 15));
                  },
                ),

                // Play/Pause Butonu
                GestureDetector(
                  onTap: isPlaying ? _pauseAudio : _playAudio,
                  child: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    progress: _iconAnimationController,
                    size: 64,
                    color: Colors.blueAccent,
                  ),
                ),

                // 15 Saniye İleri
                IconButton(
                  icon: const Icon(Icons.fast_forward,
                      color: Colors.blueAccent, size: 30),
                  onPressed: () {
                    _seekAudio(position + const Duration(seconds: 15));
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
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.blueAccent,
                      inactiveTrackColor: Colors.grey[300],
                      thumbColor: Colors.blueAccent,
                      overlayColor: Colors.blueAccent.withAlpha(32),
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 16.0),
                    ),
                    child: Slider(
                      min: 0,
                      max: duration.inSeconds.toDouble(),
                      value: position.inSeconds
                          .clamp(0, duration.inSeconds)
                          .toDouble(),
                      onChanged: (value) {
                        _seekAudio(Duration(seconds: value.toInt()));
                      },
                    ),
                  ),
                ),
                Text(
                  _formatDuration(duration),
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Hız Ayarları
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSpeedButton(0.5, '0.5x'),
                const SizedBox(width: 8),
                _buildSpeedButton(1.0, '1.0x'),
                const SizedBox(width: 8),
                _buildSpeedButton(1.5, '1.5x'),
                const SizedBox(width: 8),
                _buildSpeedButton(2.0, '2.0x'),
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
                    gradient: LinearGradient(
                      colors: [Colors.blueAccent, Colors.blue[100]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: CustomPaint(
                    painter: WavePainter(
                        position, duration, _waveAnimationController.value),
                    child: Container(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeedButton(double speed, String label) {
    return ElevatedButton(
      onPressed: () => _changeSpeed(speed),
      style: ElevatedButton.styleFrom(
        foregroundColor: playbackSpeed == speed ? Colors.white : Colors.black,
        backgroundColor:
            playbackSpeed == speed ? Colors.blueAccent : Colors.grey[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: const Size(60, 40),
      ),
      child: Text(label),
    );
  }
}

// Dalga Formu Painter
class WavePainter extends CustomPainter {
  final Duration position;
  final Duration duration;
  final double animationValue;

  WavePainter(this.position, this.duration, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    if (duration.inSeconds == 0) return;

    double progress = position.inSeconds / duration.inSeconds;

    Paint paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
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
        oldDelegate.animationValue != animationValue;
  }
}

// Tam Ekran Oynatıcı
