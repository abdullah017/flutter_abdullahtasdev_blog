import 'package:flutter/material.dart';
import 'package:abdullahtasdev/core/utils/slug_navigation.dart';
import 'package:abdullahtasdev/presentation/frontend/controllers/blog_controller.dart';
import 'package:abdullahtasdev/presentation/frontend/widgets/card/blog_card_widget.dart';
import 'package:abdullahtasdev/presentation/frontend/widgets/indicator/loading_indicator.dart';
import 'package:abdullahtasdev/presentation/frontend/widgets/layout/main_layout.dart';
import 'package:get/get.dart';

class BlogPage extends StatelessWidget {
  final BlogController controller = Get.put(BlogController());

  BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.resetBlogs();
        },
        child: CustomScrollView(
          controller: controller.scrollController,
          slivers: [
            // Başlık Sliver
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Blog',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'En son makalelerimizi ve güncellemelerimizi okuyun.',
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
            // Blog GridView Sliver
            Obx(() {
              if (controller.isLoading.value && controller.blogs.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (controller.error.value.isNotEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.error.value,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            controller.fetchBlogs();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (controller.blogs.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      'No blogs available.',
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  ),
                );
              }

              // Blog listesini sıralama (isteğe bağlı)
              final sortedBlogs = controller.blogs.toList()
                ..sort((a, b) => b['created_at'].compareTo(a['created_at']));

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
                      if (index < sortedBlogs.length) {
                        final blog = sortedBlogs[index];
                        return GestureDetector(
                          key: ValueKey(blog['id']),
                          onTap: () {
                            Navigation.toBlogDetail(blog['title'], blog['id']);
                          },
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: 1.0,
                            child: BlogCard(
                              id: blog['id'],
                              title: blog['title'],
                              imageUrl: blog['cover_image'] ??
                                  'https://placekitten.com/400/300',
                              date: blog['created_at'],
                              summary: blog['content'],
                            ),
                          ),
                        );
                      } else {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: GlassmorphicCircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                    childCount: sortedBlogs.length +
                        (controller.isLastPage.value ? 0 : 1),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
