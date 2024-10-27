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
    final PostSearchController controller = Get.put(PostSearchController());
    controller.performSearch(query);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Arama Sonuçları: "$query"'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return _buildMobileLayout(controller);
          } else {
            return _buildWebLayout(controller);
          }
        },
      ),
    );
  }

  Widget _buildMobileLayout(PostSearchController controller) {
    return Stack(
      children: [
        _buildBackground(),
        _buildOverlay(),
        _buildContent(controller, isMobile: true, context: null),
      ],
    );
  }

  Widget _buildWebLayout(PostSearchController controller) {
    return Stack(
      children: [
        _buildBackground(),
        _buildOverlay(),
        _buildContent(controller, isMobile: false, context: null),
      ],
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/s_bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.3),
    );
  }

  Widget _buildContent(PostSearchController controller,
      {required bool isMobile, BuildContext? context}) {
    return BackdropFilter(
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
            child: isMobile
                ? _buildMobileResults(controller)
                : _buildWebResults(controller),
          );
        }),
      ),
    );
  }

  Widget _buildMobileResults(PostSearchController controller) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.blogs.isNotEmpty) ...[
            const SizedBox(height: 50),
            _buildSectionTitle('Bloglar'),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.blogs.length,
              itemBuilder: (context, index) {
                final blog = controller.blogs[index];
                return _buildResultCard(blog, false);
              },
            ),
          ],
          if (controller.audioBlogs.isNotEmpty) ...[
            const SizedBox(height: 30),
            _buildSectionTitle('Sesli Bloglar'),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.audioBlogs.length,
              itemBuilder: (context, index) {
                final audioBlog = controller.audioBlogs[index];
                return _buildResultCard(audioBlog, true);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWebResults(PostSearchController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.blogs.isNotEmpty) ...[
            const SizedBox(height: 40),
            _buildSectionTitle('Bloglar'),
            Flexible(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // İki sütun
                  childAspectRatio: 3, // Elemanların genişlik-yükseklik oranı
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: controller.blogs.length,
                itemBuilder: (context, index) {
                  final blog = controller.blogs[index];
                  return _buildResultCard(blog, false);
                },
              ),
            ),
          ],
          if (controller.audioBlogs.isNotEmpty) ...[
            const SizedBox(height: 10),
            _buildSectionTitle('Sesli Bloglar'),
            Flexible(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
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
  }

  Widget _buildSectionTitle(String title) {
    // Eğer context gerekli ise ekleyebilirsiniz
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildResultCard(Map<String, dynamic> item, bool isAudio) {
    String formattedDate = '';
    try {
      DateTime parsedDate = DateTime.parse(item['created_at']);
      formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      formattedDate = item['created_at'];
    }

    final String? id = item['id']?.toString();
    if (id == null) {
      if (kDebugMode) {
        print('Blog ID bulunamadı: $item');
      }
      return const SizedBox.shrink();
    }

    return Card(
      color: Colors.white.withOpacity(0.1),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          if (isAudio) {
            Navigation.toAudioBlogDetail(item['title'], int.tryParse(id)!);
          } else {
            Navigation.toBlogDetail(item['title'], int.tryParse(id)!);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              _buildCoverImage(item),
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
                      formattedDate,
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

  Widget _buildCoverImage(Map<String, dynamic> item) {
    return item['cover_image'] != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item['cover_image'],
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildPlaceholderImage();
              },
            ),
          )
        : _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
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
  }
}
