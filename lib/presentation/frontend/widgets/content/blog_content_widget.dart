import 'package:abdullahtasdev/presentation/frontend/controllers/blog_controller.dart';
import 'package:abdullahtasdev/presentation/frontend/widgets/card/blog_card_widget.dart';
import 'package:abdullahtasdev/presentation/frontend/widgets/indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlogContent extends GetView<BlogController> {
  const BlogContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.blogs.isEmpty) {
        return const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.error.value.isNotEmpty) {
        return _buildError();
      }

      if (controller.blogs.isEmpty) {
        return const SliverToBoxAdapter(
          child: Center(
            child: Text(
              'No blogs available.',
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
          ),
        );
      }

      final sortedBlogs = controller.blogs.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

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
                return BlogCard(
                  id: blog.id,
                  title: blog.title,
                  imageUrl: blog.coverImage,
                  date: blog.createdAt.toString(),
                  summary: blog.content,
                );
              } else {
                return const GlassmorphicCircularProgressIndicator();
              }
            },
            childCount:
                sortedBlogs.length + (controller.isLastPage.value ? 0 : 1),
          ),
        ),
      );
    });
  }

  Widget _buildError() {
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
              onPressed: controller.fetchBlogs,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
