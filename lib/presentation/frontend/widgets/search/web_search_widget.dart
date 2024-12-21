import 'package:abdullahtasdev/presentation/frontend/controllers/search_controller.dart';
import 'package:abdullahtasdev/presentation/frontend/widgets/card/search_result_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchResultWeb extends GetView<PostSearchController> {
  const SearchResultWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.error.value.isNotEmpty) {
        return Center(
          child: Text(
            'Hata: ${controller.error.value}',
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
        );
      }

      if (controller.blogs.isEmpty && controller.audioBlogs.isEmpty) {
        return const Center(
          child: Text('Hiç sonuç bulunamadı.',
              style: TextStyle(fontSize: 16, color: Colors.grey)),
        );
      }

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.blogs.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildSectionTitle('Bloglar'),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: controller.blogs.length,
                itemBuilder: (context, index) {
                  final blog = controller.blogs[index];
                  return SearchResultCard(item: blog, isAudio: false);
                },
              ),
            ],
            if (controller.audioBlogs.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildSectionTitle('Sesli Bloglar'),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: controller.audioBlogs.length,
                itemBuilder: (context, index) {
                  final audioBlog = controller.audioBlogs[index];
                  return SearchResultCard(item: audioBlog, isAudio: true);
                },
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
