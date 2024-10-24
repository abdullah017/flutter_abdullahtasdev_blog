import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/controllers/blog_detail_controller.dart';

class BlogDetailPage extends StatelessWidget {
  const BlogDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // BlogDetailController'ı alıyoruz
    final BlogDetailController controller = Get.put(BlogDetailController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Detayları'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Blog verisi var mı kontrol ediyoruz
        if (controller.blog.isEmpty) {
          return const Center(child: Text('Blog bulunamadı.'));
        }

        // Blog verisini alıyoruz
        final blog = controller.blog;
        final String title = blog['title'] ?? 'Başlık Yok';
        final String imageUrl = blog['cover_image'] ?? '';
        final String content = blog['content'] ?? '';
        final String date = blog['created_at'] ?? '';

        // Quill Delta içeriğini JSON'dan HTML'e dönüştürmek
        List<dynamic> delta;
        try {
          delta = jsonDecode(content); // Quill Delta içeriğini çözüyoruz
        } catch (e) {
          delta = []; // Eğer JSON parse hatası varsa boş bir delta kullan
          print('Content JSON Parse Hatası: $e');
        }

        // Delta verisini Map<String, dynamic> tipine dönüştürme
        List<Map<String, dynamic>> convertedDelta =
            List<Map<String, dynamic>>.from(delta);

        final converter = QuillDeltaToHtmlConverter(convertedDelta);
        final htmlContent = converter.convert(); // Delta'dan HTML'e çevirme

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Başlık
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Tarih
              Text(
                'Tarih: ${_formatDate(date)}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),

              // Blog görseli (varsa)
              if (imageUrl.isNotEmpty) ...[
                Image.network(imageUrl),
                const SizedBox(height: 16),
              ],

              // Blog içeriği (HTML formatında gösteriliyor ve seçilebilir)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 200.0),
                child: SelectionArea(
                  child: HtmlWidget(
                    htmlContent,
                    // Linklerin tıklanabilir olmasını sağlar
                    onTapUrl: (url) {
                      launchUrl(Uri.parse(url));
                      return true;
                    },
                    // Stil ayarları
                    textStyle: const TextStyle(
                      fontSize: 16.0,
                      height: 1.5,
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

  // Tarih formatlama fonksiyonu (gün/ay/yıl)
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
