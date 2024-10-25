import 'dart:convert';
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

  const AudioBlogDetailPage({
    super.key,
    required this.blogId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AudioBlogDetailController());
    controller.loadAudioBlog(blogId);

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.title.value)),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Blog içeriği JSON'dan HTML'e dönüştürülüyor
        List<dynamic> delta;
        try {
          delta = jsonDecode(controller.content.value);
        } catch (e) {
          if (kDebugMode) {
            print("JSON Parse Hatası: $e");
          }
          delta = []; // Eğer hata oluşursa boş bir liste döndürüyoruz
        }

        // `List<Map<String, dynamic>>` formatına dönüştürme
        List<Map<String, dynamic>> convertedDelta = [];
        for (var item in delta) {
          if (item is Map<String, dynamic>) {
            convertedDelta.add(item);
          }
        }

        final converter = QuillDeltaToHtmlConverter(convertedDelta);
        final htmlContent = converter.convert();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık
              Text(
                controller.title.value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Tarih
              Text(
                'Tarih: ${_formatDate(controller.date.value)}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),

              // // Blog görseli (varsa)
              // if (controller.imageUrl.value.isNotEmpty) ...[
              //   Image.network(controller.imageUrl.value),
              //   const SizedBox(height: 16),
              // ],

              // Blog içeriği (HTML formatında gösteriliyor ve seçilebilir)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: HtmlWidget(
                  htmlContent,
                  // Metni seçilebilir hale getirir

                  // Linklerin tıklanabilir olmasını sağlar
                  onTapUrl: (url) {
                    launchUrl(Uri.parse(url));
                    return true;
                  },
                  // onTapUrl: (url) async {
                  //   final uri = Uri.parse(url);
                  //   if (await canLaunchUrl(uri)) {
                  //     await launchUrl(uri,
                  //         mode: LaunchMode.externalApplication);
                  //   } else {
                  //     // Hata durumu için kullanıcıya bildirim gönderebilirsiniz
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       SnackBar(content: Text('Bağlantı açılamadı: $url')),
                  //     );
                  //   }
                  // },
                  // Stil ayarları
                  textStyle: const TextStyle(
                    fontSize: 16.0,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // // Sesli blog oynatıcı
              // const Text(
              //   'Ses Dosyası',
              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 8),

              // AudioPlayerWidget'ı Obx içerisinde dinamik olarak güncelle
              if (controller.audioUrl.value.isNotEmpty)
                JustAudioPlayerWidget(
                  audioUrl: controller.audioUrl.value,
                  albumArtUrl: controller.imageUrl.value,
                )
              else
                const Text('Ses dosyası bulunamadı.'),
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
