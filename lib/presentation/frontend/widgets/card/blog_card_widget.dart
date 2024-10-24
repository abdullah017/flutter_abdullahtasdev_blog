import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/widgets/card/back_card_content_widget.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/widgets/card/front_card_content_widget.dart';

class BlogCard extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String date;
  final String summary;

  const BlogCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.date,
    required this.summary,
  });

  @override
  _BlogCardState createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isHovered = false;

  @override
  void initState() {
    super.initState();
    // Initialize the AnimationController
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Define the animation from 0 to pi radians
    _animation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Listen to animation status to toggle the hover state
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
    super.dispose();
  }

  void _onHover(bool hovering) {
    if (hovering) {
      _controller.forward();
    } else {
      _controller.reverse();
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
          // Determine if the front or back should be visible
          bool isFront = _animation.value < (pi / 2);
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Add perspective
              ..rotateY(_animation.value),
            child: Stack(
              children: [
                // Front Side
                Visibility(
                  visible: isFront,
                  child: FrontCardContent(
                    widget.title,
                    widget.imageUrl,
                    widget.date,
                  ),
                ),
                // Back Side
                Visibility(
                  visible: !isFront,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(pi),
                    child: BackCardContent(
                      _getLimitedSummary(widget.summary, 30),
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

  // Helper method to limit summary to a specific number of words
  String _getLimitedSummary(String summary, int wordLimit) {
    final words = summary.split(' ');
    if (words.length <= wordLimit) {
      return summary;
    } else {
      return '${words.sublist(0, wordLimit).join(' ')}...';
    }
  }
}
