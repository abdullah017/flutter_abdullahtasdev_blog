import 'dart:math';
import 'dart:ui'; // Blur efekti için gerekli
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abdullahtasdev_blog/core/utils/slug_navigation.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/widgets/button/glassmorphic_button_widget.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/widgets/indicator/loading_indicator.dart';

import 'package:intl/intl.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

class BlogCard extends StatefulWidget {
  final int id;
  final String title;
  final String imageUrl;
  final String date;
  final String summary; // Quill Delta verisi

  const BlogCard({
    super.key,
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.date,
    required this.summary,
  });

  @override
  State<BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    if (_controller.isCompleted ||
        _controller.status == AnimationStatus.forward) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  String _convertDeltaToPlainText(String deltaJson) {
    try {
      final List<Map<String, dynamic>> delta =
          List<Map<String, dynamic>>.from(jsonDecode(deltaJson));
      final converter = QuillDeltaToHtmlConverter(delta);
      final htmlContent = converter.convert();
      final plainText = _stripHtmlTags(htmlContent);
      return plainText;
    } catch (e) {
      return "İçerik görüntülenemiyor";
    }
  }

  String _stripHtmlTags(String htmlContent) {
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlContent.replaceAll(exp, '');
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: MouseRegion(
        onEnter: (_) => _controller.forward(),
        onExit: (_) => _controller.reverse(),
        child: GestureDetector(
          onTap: _onTap,
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
                      child: FrontCardContent(
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
                        child: BackCardContent(
                          summary: _convertDeltaToPlainText(widget.summary),
                          blogId: widget.id,
                          title: widget.title,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class FrontCardContent extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String date;

  const FrontCardContent({
    required this.title,
    required this.imageUrl,
    required this.date,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime parsedDate = DateTime.parse(date);
    final String formattedDate = DateFormat('dd.MM.yyyy').format(parsedDate);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(255, 255, 255, 0.1),
            Color.fromRGBO(255, 255, 255, 0.05)
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
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const GlassmorphicCircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Center(
                    child:
                        Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 8),
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

class BackCardContent extends StatelessWidget {
  final String summary;
  final int blogId;
  final String title;

  const BackCardContent({
    required this.summary,
    required this.blogId,
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(255, 255, 255, 0.1),
            Color.fromRGBO(255, 255, 255, 0.05)
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    summary,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      //Get.toNamed('/blog_detail/$blogId');
                      Navigation.toBlogDetail(title, blogId);
                    },
                    child: const GlassmorphicButton(
                      text: 'Devamını Oku',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
