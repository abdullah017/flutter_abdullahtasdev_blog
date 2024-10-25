import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waveform_flutter/waveform_flutter.dart'; // Ensure this package supports both platforms
import 'package:audioplayers/audioplayers.dart'; // Add audioplayers package

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
  State<AudioBlogCard> createState() => _AudioBlogCardState();
}

class _AudioBlogCardState extends State<AudioBlogCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isHovered = false;
  AudioPlayer? _audioPlayer; // Use AudioPlayer from audioplayers package
  bool isPlayingPreview = false;

  @override
  void initState() {
    super.initState();
    // Initialize AnimationController
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Define the animation (0 to pi)
    _animation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Animation status listener
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
      setState(() {
        isPlayingPreview = true;
      });
      if (kDebugMode) {
        print('Playing audio from URL: ${widget.audioUrl}');
      }

      _audioPlayer = AudioPlayer();
      try {
        await _audioPlayer!.play(UrlSource(widget.audioUrl));
        // Listen for completion
        _audioPlayer!.onPlayerComplete.listen((event) {
          if (kDebugMode) {
            print('Audio playback completed.');
          }
          setState(() {
            isPlayingPreview = false;
          });
        });

        // // Handle errors
        // _audioPlayer!.onPlayerError.listen((msg) {
        //   if (kDebugMode) {
        //     print('Error playing audio: $msg');
        //   }
        //   setState(() {
        //     isPlayingPreview = false;
        //   });
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Ses oynatılırken bir hata oluştu.')),
        //   );
        // });

        // Stop after 30 seconds
        Future.delayed(const Duration(seconds: 30), () {
          if (mounted) {
            _stopPreview();
          }
        });
      } catch (e) {
        if (kDebugMode) {
          print('Exception playing audio: $e');
        }
        setState(() {
          isPlayingPreview = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ses oynatılırken bir hata oluştu.')),
        );
      }
    }
  }

  void _stopPreview() {
    if (isPlayingPreview) {
      _audioPlayer?.stop();
      _audioPlayer = null;
      setState(() {
        isPlayingPreview = false;
      });
      if (kDebugMode) {
        print('Audio preview stopped.');
      }
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
          // Determine if front or back is visible
          bool isFront = _animation.value < (pi / 2);
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Add perspective
              ..rotateY(_animation.value),
            child: Stack(
              children: [
                // Front Face
                Visibility(
                  visible: isFront,
                  child: _FrontCardContent(
                    title: widget.title,
                    imageUrl: widget.imageUrl,
                    date: widget.date,
                  ),
                ),
                // Back Face
                Visibility(
                  visible: !isFront,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(pi),
                    child: _BackCardContent(
                      stopPreview: _stopPreview,
                      audioUrl: widget.audioUrl,
                      isPlayingPreview: isPlayingPreview,
                      waveformData: const [], // Update if needed
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
    // Format the date
    final DateTime parsedDate = DateTime.parse(date);
    final String formattedDate = DateFormat('dd.MM.yyyy').format(parsedDate);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Blog image
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

          // Blog title
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

          // Blog date
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
            // Show waveform if audio is playing, else show text
            widget.isPlayingPreview
                ? SizedBox(
                    height: 100,
                    child: AnimatedWaveList(
                      stream: _amplitudeStream, // Use Amplitude stream directly
                    ),
                  )
                : const Text(
                    'Şimdi Dinle',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                widget.stopPreview(); // Stop preview
                // Navigate to detail page
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
