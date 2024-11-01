// lib/presentation/frontend/pages/audio_blog_detail_page.dart

import 'dart:convert';
import 'dart:ui';
import 'package:abdullahtasdev/data/models/audio_blog_model.dart';
import 'package:abdullahtasdev/data/repositories/front_repositories/blog_repositories.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:abdullahtasdev/presentation/frontend/controllers/audio_blog_detail_controller.dart';
import 'package:abdullahtasdev/presentation/frontend/widgets/audio_player/audioplayer_widget.dart';

class AudioBlogDetailPage extends StatelessWidget {
  final int blogId;

  const AudioBlogDetailPage({super.key, required this.blogId});

  @override
  Widget build(BuildContext context) {
    // Bağımlılıkları inject ediyoruz
    final blogRepository = Get.find<BlogRepository>();
    final controller = Get.put(
      AudioBlogDetailController(
        blogRepository: blogRepository,
        blogId: blogId,
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Obx(() {
          final title = controller.audioBlog.value?.title ?? '';
          return Text(
            title,
            style: const TextStyle(color: Colors.white),
          );
        }),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final audioBlog = controller.audioBlog.value;

        if (audioBlog == null) {
          return const Center(
            child: Text(
              'İçerik yüklenemedi. Lütfen tekrar deneyin.',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          );
        }

        final htmlContent = _convertDeltaToHtml(audioBlog.content);

        return Stack(
          fit: StackFit.expand,
          children: [
            _buildBackgroundImage(audioBlog.imageUrl),
            _buildContent(audioBlog, htmlContent),
          ],
        );
      }),
    );
  }

  Widget _buildBackgroundImage(String imageUrl) {
    return CachedNetworkImage(
      imageUrl:
          imageUrl.isNotEmpty ? imageUrl : 'https://placekitten.com/800/400',
      fit: BoxFit.cover,
      errorWidget: (context, url, error) => Image.network(
        'https://placekitten.com/800/400',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildContent(AudioBlog audioBlog, String htmlContent) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                  ),
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
                        htmlContent,
                        onTapUrl: (url) {
                          launchUrl(Uri.parse(url));
                          return true;
                        },
                        textStyle: const TextStyle(
                          fontSize: 16.0,
                          height: 1.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (audioBlog.audioUrl.isNotEmpty)
                      JustAudioPlayerWidget(
                        audioUrl: audioBlog.audioUrl,
                        albumArtUrl: audioBlog.imageUrl,
                      )
                    else
                      const Text(
                        'Ses dosyası bulunamadı.',
                        style: TextStyle(color: Colors.white70),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _convertDeltaToHtml(String content) {
    try {
      final delta = jsonDecode(content) as List<dynamic>;
      final convertedDelta = List<Map<String, dynamic>>.from(delta);
      final converter = QuillDeltaToHtmlConverter(convertedDelta);
      return converter.convert();
    } catch (e) {
      if (kDebugMode) {
        print("Content JSON Parse Hatası: $e");
      }
      return '';
    }
  }

  String _formatDate(DateTime date) {
    try {
      return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
    } catch (e) {
      return 'Geçersiz Tarih';
    }
  }
}
