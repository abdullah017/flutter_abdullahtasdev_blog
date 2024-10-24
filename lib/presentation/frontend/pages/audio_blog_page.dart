import 'package:flutter/material.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/widgets/card/audio_card_widget.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/widgets/layout/main_layout.dart';
import 'package:get/get.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/controllers/audio_blog_controller.dart';

class AudioBlogPage extends StatelessWidget {
  final AudioBlogController controller = Get.put(AudioBlogController());

  AudioBlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Arama alanı
            TextField(
              decoration: InputDecoration(
                labelText: 'Search Audio Blog',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                // Arama fonksiyonu burada uygulanabilir
              },
            ),
            const SizedBox(height: 16),
            // Sesli Blog GridView
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.audioBlogs.isEmpty) {
                  return const Center(child: Text('No audio blogs available.'));
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 3 / 4,
                  ),
                  itemCount: controller.audioBlogs.length,
                  itemBuilder: (context, index) {
                    final audioBlog = controller.audioBlogs[index];
                    return AudioBlogCard(
                      title: audioBlog['title'],
                      imageUrl: audioBlog['cover_image'] ??
                          'https://placekitten.com/400/300',
                      audioUrl: audioBlog['audio_url'],
                      date: audioBlog['created_at'],
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
