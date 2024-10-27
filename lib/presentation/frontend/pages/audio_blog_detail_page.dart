import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/widgets/audio_player/audioplayer_widget.dart';
import 'package:get/get.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/controllers/audio_blog_detail_controller.dart';

class AudioBlogDetailPage extends StatelessWidget {
  final int blogId;

  const AudioBlogDetailPage({super.key, required this.blogId});

  @override
  Widget build(BuildContext context) {
    // Controller Initialization
    final controller = Get.put(AudioBlogDetailController());
    controller.loadAudioBlog(blogId);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Obx(() => Text(
              controller.title.value,
              style: const TextStyle(color: Colors.white),
            )),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Check if content is empty
        if (controller.content.value.isEmpty) {
          return const Center(
            child: Text(
              'İçerik yüklenemedi. Lütfen tekrar deneyin.',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          );
        }

        // Blog içeriği JSON'dan HTML'e dönüştürülüyor
        List<dynamic> delta;
        try {
          delta = jsonDecode(controller.content.value);
        } catch (e) {
          if (kDebugMode) {
            print("JSON Parse Hatası: $e");
          }
          delta = [];
        }

        // Convert JSON Delta to HTML
        List<Map<String, dynamic>> convertedDelta =
            delta.whereType<Map<String, dynamic>>().toList();
        final converter = QuillDeltaToHtmlConverter(convertedDelta);
        final htmlContent = converter.convert();

        return Stack(
          fit: StackFit.expand, // Stack'in tüm alanı kaplamasını sağlar
          children: [
            // Arka plan görseli (tam ekran kaplama)
            Image.network(
              controller.imageUrl.value.isNotEmpty
                  ? controller.imageUrl.value
                  : 'https://placekitten.com/800/400',
              fit: BoxFit.cover, // Görselin ekranı tamamen kaplamasını sağlar
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  'https://placekitten.com/800/400', // Yedek görsel URL'si
                  fit: BoxFit.cover,
                );
              },
            ),
            // Arka plan karartma efekti
            Container(
              color: Colors.black.withOpacity(0.5),
            ),
            // İçerik
            SingleChildScrollView(
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
                          // Başlık
                          // Text(
                          //   controller.title.value,
                          //   style: const TextStyle(
                          //     fontSize: 24,
                          //     fontWeight: FontWeight.bold,
                          //     color: Colors.white,
                          //   ),
                          //   textAlign: TextAlign.center,
                          // ),
                          const SizedBox(height: 12),
                          // Tarih
                          Text(
                            'Tarih: ${controller.formatDate(controller.date.value)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Blog İçeriği
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
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
                          const SizedBox(height: 16),
                          // Ses Dosyası Başlığı
                          const Text(
                            'Ses Dosyası',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // AudioPlayerWidget
                          if (controller.audioUrl.value.isNotEmpty)
                            JustAudioPlayerWidget(
                              audioUrl: controller.audioUrl.value,
                              albumArtUrl: controller.imageUrl.value,
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
          ],
        );
      }),
    );
  }
}
