// lib/presentation/frontend/pages/search_results.dart

import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abdullahtasdev_blog/core/utils/slug_navigation.dart';
import 'package:get/get.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/controllers/search_controller.dart';
import 'package:intl/intl.dart';

class SearchResults extends StatelessWidget {
  final String query;

  const SearchResults({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    // SearchController'ı bul veya oluştur
    final PostSearchController controller = Get.put(PostSearchController());

    // Aramayı başlat
    controller.performSearch(query);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Arama Sonuçları: "$query"'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Arka Plan Resmi veya Gradient
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/s_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Yarı Saydam Siyah Overlay
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          // Glassmorphism İçeriği
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.white.withOpacity(0.2),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.error.isNotEmpty) {
                  return Center(
                    child: Text(
                      'Hata: ${controller.error.value}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }

                if (controller.blogs.isEmpty && controller.audioBlogs.isEmpty) {
                  return const Center(
                    child: Text(
                      'Hiç sonuç bulunamadı.',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (controller.blogs.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.0),
                          child: Text(
                            'Bloglar',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.blogs.length,
                            itemBuilder: (context, index) {
                              final blog = controller.blogs[index];
                              return _buildResultCard(blog, false);
                            },
                          ),
                        ),
                      ],
                      if (controller.audioBlogs.isNotEmpty) ...[
                        const SizedBox(height: 30),
                        const Text(
                          'Sesli Bloglar',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.audioBlogs.length,
                            itemBuilder: (context, index) {
                              final audioBlog = controller.audioBlogs[index];
                              return _buildResultCard(audioBlog, true);
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(Map<String, dynamic> item, bool isAudio) {
    // Tarih formatını güncelleyin
    String formattedDate = '';
    try {
      DateTime parsedDate = DateTime.parse(item['created_at']);
      formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      formattedDate = item[
          'created_at']; // Eğer tarih parse edilemezse orijinal değeri kullanın
    }

    // 'id' kontrolü ekleyerek güvenliği artırın
    final String? id = item['id']?.toString();
    if (id == null) {
      if (kDebugMode) {
        print('Blog ID bulunamadı: $item');
      }
      return const SizedBox
          .shrink(); // Boş bir widget döndürerek hatayı önleyin
    }

    return Card(
      color: Colors.white.withOpacity(0.1),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          // Detay sayfasına navigasyon
          if (isAudio) {
            Navigation.toAudioBlogDetail(
                item['title'], int.tryParse(id.toString())!);
            //Get.toNamed('/audio_blog_detail/$id');
          } else {
            //Get.toNamed('/blog_detail/$id');
            Navigation.toBlogDetail(
                item['title'], int.tryParse(id.toString())!);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              if (item['cover_image'] != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    item['cover_image'],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.white70,
                        ),
                      );
                    },
                  ),
                )
              else
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.white70,
                  ),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] ?? 'Başlık Yok',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formattedDate, // Formatlanmış tarihi gösterin
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              if (isAudio)
                const Icon(
                  Icons.audiotrack,
                  color: Colors.white70,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
