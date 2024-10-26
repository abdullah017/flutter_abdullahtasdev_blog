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
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.audioBlogs.isEmpty) {
            return const Center(child: Text('No audio blogs available.'));
          }

          return CustomScrollView(
            controller: controller.scrollController,
            slivers: [
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final audioBlog = controller.audioBlogs[index];
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed('/audio_blog_detail/${audioBlog['id']}');
                      },
                      child: AudioBlogCard(
                        title: audioBlog['title'],
                        imageUrl: audioBlog['cover_image'] ??
                            'https://placekitten.com/400/300',
                        audioUrl: audioBlog['audio_url'],
                        date: audioBlog['created_at'],
                      ),
                    );
                  },
                  childCount: controller.audioBlogs.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
              ),
              if (controller.isLoadingMore.value)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
