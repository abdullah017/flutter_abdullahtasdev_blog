import 'package:abdullahtasdev/presentation/frontend/controllers/audio_blog_controller.dart';
import 'package:abdullahtasdev/presentation/frontend/widgets/card/audio_card_widget.dart';
import 'package:abdullahtasdev/presentation/frontend/widgets/indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioBlogContent extends GetView<AudioBlogController> {
  const AudioBlogContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.audioBlogs.isEmpty) {
        return const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.error.value.isNotEmpty && controller.audioBlogs.isEmpty) {
        return SliverToBoxAdapter(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.error.value,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: controller.fetchAudioBlogs,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }

      if (controller.audioBlogs.isEmpty) {
        return const SliverToBoxAdapter(
          child: Center(
            child: Text(
              'Herhangi bir Sesli Makale bulunamadı!',
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
          ),
        );
      }

      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index < controller.audioBlogs.length) {
                final audioBlog = controller.audioBlogs[index];
                return AudioBlogCard(
                  id: audioBlog['id'],
                  title: audioBlog['title'],
                  imageUrl: audioBlog['cover_image'],
                  audioUrl: audioBlog['audio_url'],
                  date: audioBlog['created_at'],
                );
              } else {
                return const GlassmorphicCircularProgressIndicator();
              }
            },
            childCount: controller.audioBlogs.length +
                (controller.isLastPage.value ? 0 : 1),
          ),
        ),
      );
    });
  }
}
