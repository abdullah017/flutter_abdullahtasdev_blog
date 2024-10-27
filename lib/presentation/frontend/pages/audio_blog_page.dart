import 'package:flutter/material.dart';
import 'package:flutter_abdullahtasdev_blog/core/utils/slug_navigation.dart';
import 'package:get/get.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/controllers/audio_blog_controller.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/widgets/card/audio_card_widget.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/widgets/indicator/loading_indicator.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/widgets/layout/main_layout.dart';

class AudioBlogPage extends StatelessWidget {
  final AudioBlogController controller = Get.put(AudioBlogController());

  AudioBlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.resetAudioBlogs();
        },
        child: CustomScrollView(
          controller: controller.scrollController,
          slivers: [
            // Header Sliver
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sesli Blog',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'En son sesli makalelerimizi ve güncellemelerimizi dinleyin.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            // Content Sliver
            Obx(() {
              // Initial Loading
              if (controller.isLoading.value && controller.audioBlogs.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              // Error State
              if (controller.error.value.isNotEmpty &&
                  controller.audioBlogs.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.error.value,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              controller.fetchAudioBlogs();
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              // Empty State
              if (controller.audioBlogs.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      'Herhangi bir Sesli Makale bulunamadı!',
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  ),
                );
              }

              // Audio Blogs Grid
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
                    (BuildContext context, int index) {
                      if (index < controller.audioBlogs.length) {
                        final audioBlog = controller.audioBlogs[index];
                        return GestureDetector(
                          key: ValueKey(audioBlog['id']),
                          onTap: () {
                            Navigation.toAudioBlogDetail(
                                audioBlog['title'], audioBlog['id']);
                          },
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: 1.0,
                            child: AudioBlogCard(
                              id: audioBlog['id'],
                              title: audioBlog['title'],
                              imageUrl: audioBlog['cover_image'] ??
                                  'https://placekitten.com/400/300',
                              audioUrl: audioBlog['audio_url'],
                              date: audioBlog['created_at'],
                            ),
                          ),
                        );
                      } else {
                        // Loading Indicator for Pagination
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: GlassmorphicCircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                    childCount: controller.audioBlogs.length +
                        (controller.isLastPage.value ? 0 : 1),
                  ),
                ),
              );
            }),
            // Pagination Loading Indicator (Optional)
            Obx(() {
              if (controller.isLoadingMore.value &&
                  controller.audioBlogs.isNotEmpty) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              } else {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }
            }),
          ],
        ),
      ),
    );
  }
}
