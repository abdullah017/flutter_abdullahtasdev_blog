// lib/presentation/frontend/pages/blog_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:abdullahtasdev/core/utils/slug_navigation.dart';
import 'package:abdullahtasdev/presentation/frontend/controllers/blog_controller.dart';
import 'package:abdullahtasdev/presentation/frontend/widgets/card/blog_card_widget.dart';
import 'package:abdullahtasdev/presentation/frontend/widgets/indicator/loading_indicator.dart';
import 'package:abdullahtasdev/presentation/frontend/widgets/layout/main_layout.dart';

class BlogPage extends StatelessWidget {
  BlogPage({super.key});

  final BlogController controller = Get.put(
    BlogController(blogRepository: Get.find()),
  );

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: RefreshIndicator(
        onRefresh: controller.resetBlogs,
        child: CustomScrollView(
          controller: controller.scrollController,
          slivers: [
            _buildHeader(),
            Obx(() => _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const SliverToBoxAdapter(
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
    );
  }

  Widget _buildContent() {
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
            style: TextStyle(color: Colors.white70, fontSize: 18),
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
              return GestureDetector(
                key: ValueKey(blog.id),
                onTap: () {
                  Navigation.toBlogDetail(blog.title, blog.id);
                },
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: 1.0,
                  child: BlogCard(
                    id: blog.id,
                    title: blog.title,
                    imageUrl: blog.coverImage.isNotEmpty
                        ? blog.coverImage
                        : 'https://placekitten.com/400/300',
                    date: blog.createdAt.toString(),
                    summary: blog.content,
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
          childCount:
              sortedBlogs.length + (controller.isLastPage.value ? 0 : 1),
        ),
      ),
    );
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
