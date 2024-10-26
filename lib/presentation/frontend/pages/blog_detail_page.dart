// lib/presentation/frontend/pages/blog_detail_page.dart

import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/controllers/blog_detail_controller.dart';

class BlogDetailPage extends StatelessWidget {
  final int blogId; // blogId parametresi ekleniyor

  const BlogDetailPage({super.key, required this.blogId});

  @override
  Widget build(BuildContext context) {
    // Controller'ı blogId ile birlikte oluşturuyoruz
    final BlogDetailController controller =
        Get.put(BlogDetailController(blogId));

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Obx(() => Text(
              controller.title.value,
              style: const TextStyle(color: Colors.white),
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.blog.isEmpty) {
          return const Center(child: Text('Blog bulunamadı.'));
        }

        final blog = controller.blog;
        final String title = blog['title'] ?? 'Başlık Yok';
        final String imageUrl = blog['cover_image'] ?? '';
        final String content = blog['content'] ?? '';
        final String date = blog['created_at'] ?? '';

        List<dynamic> delta;
        try {
          delta = jsonDecode(content);
        } catch (e) {
          delta = [];
          if (kDebugMode) {
            print('Content JSON Parse Hatası: $e');
          }
        }

        List<Map<String, dynamic>> convertedDelta =
            List<Map<String, dynamic>>.from(delta);
        final converter = QuillDeltaToHtmlConverter(convertedDelta);
        final htmlContent = converter.convert();

        return SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  if (imageUrl.isNotEmpty)
                    Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 300,
                          color: Colors.grey,
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.white,
                            size: 50,
                          ),
                        );
                      },
                    ),
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.5),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: 15, sigmaY: 15), // Blur efektini ayarladık
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color:
                            Colors.white.withOpacity(0.2), // Opaklığı artırdık
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.white.withOpacity(
                                0.3)), // Border opaklığını artırdık
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors
                                    .black, // Yazı rengi siyah olarak ayarlandı
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Text(
                              'Tarih: ${_formatDate(date)}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors
                                    .black, // Yazı rengi siyah olarak ayarlandı
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: SelectionArea(
                              child: HtmlWidget(
                                htmlContent,
                                onTapUrl: (url) {
                                  launchUrl(Uri.parse(url));
                                  return true;
                                },
                                textStyle: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors
                                      .black, // Yazı rengi siyah olarak ayarlandı
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  String _formatDate(String date) {
    if (date.isEmpty) return 'Tarih Yok';
    try {
      final parsedDate = DateTime.parse(date);
      return '${parsedDate.day.toString().padLeft(2, '0')}.${parsedDate.month.toString().padLeft(2, '0')}.${parsedDate.year}';
    } catch (e) {
      return 'Geçersiz Tarih';
    }
  }
}
