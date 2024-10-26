import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_abdullahtasdev_blog/core/utils/slug_navigation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:waveform_flutter/waveform_flutter.dart';

class AudioBlogCard extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String date;
  final String audioUrl;
  final int id;

  const AudioBlogCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.date,
    required this.audioUrl,
    required this.id,
  });

  @override
  State<AudioBlogCard> createState() => _AudioBlogCardState();
}

class _AudioBlogCardState extends State<AudioBlogCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  AudioPlayer? _audioPlayer;
  bool isPlayingPreview = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer?.dispose();
    _audioPlayer = null;
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

  Future<void> _playPreview() async {
    if (!isPlayingPreview && widget.audioUrl.isNotEmpty) {
      setState(() => isPlayingPreview = true);
      _audioPlayer = AudioPlayer();
      try {
        await _audioPlayer!.setUrl(widget.audioUrl);
        await _audioPlayer!.play();
        _audioPlayer!.playerStateStream.listen((state) {
          if (state.processingState == ProcessingState.completed) {
            setState(() => isPlayingPreview = false);
          }
        });
      } catch (e) {
        setState(() => isPlayingPreview = false);
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Ses oynatılırken bir hata oluştu.')),
        );
      }
    }
  }

  void _stopPreview() {
    if (isPlayingPreview) {
      _audioPlayer?.stop();
      setState(() => isPlayingPreview = false);
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
          bool isFront = _animation.value < (pi / 2);
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_animation.value),
            child: Stack(
              children: [
                Visibility(
                  visible: isFront,
                  child: _FrontCardContent(
                    title: widget.title,
                    imageUrl: widget.imageUrl,
                    date: widget.date,
                  ),
                ),
                Visibility(
                  visible: !isFront,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(pi),
                    child: _BackCardContent(
                      stopPreview: _stopPreview,
                      audioUrl: widget.audioUrl,
                      isPlayingPreview: isPlayingPreview,
                      title: widget.title,
                      id: widget.id,
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
  });

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        DateFormat('dd.MM.yyyy').format(DateTime.parse(date));

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(255, 255, 255, 0.1),
            Color.fromRGBO(255, 255, 255, 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.broken_image,
                          size: 50, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackCardContent extends StatefulWidget {
  final VoidCallback stopPreview;
  final String audioUrl;
  final bool isPlayingPreview;
  final String title;
  final int id;

  const _BackCardContent({
    required this.stopPreview,
    required this.audioUrl,
    required this.isPlayingPreview,
    required this.title,
    required this.id,
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(255, 255, 255, 0.1),
            Color.fromRGBO(255, 255, 255, 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.isPlayingPreview
                    ? SizedBox(
                        height: 100,
                        child: AnimatedWaveList(stream: _amplitudeStream),
                      )
                    : const Text(
                        'Şimdi Dinle',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    widget.stopPreview();
                    // Navigator.pushNamed(context, '/audio_blog_detail',
                    //     arguments: widget.audioUrl);

                    Navigation.toAudioBlogDetail(widget.title, widget.id);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: const Text('Devamını Dinle'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
