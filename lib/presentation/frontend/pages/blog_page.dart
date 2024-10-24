import 'package:flutter/material.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/widgets/card/blog_card_widget.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/widgets/layout/main_layout.dart';
import 'package:get/get.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/controllers/blog_controller.dart';

class BlogPage extends StatelessWidget {
  final BlogController controller = Get.put(BlogController());

  BlogPage({super.key});

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
                labelText: 'Search Blog',
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
            // Blog GridView
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.blogs.isEmpty) {
                  return const Center(child: Text('No blogs available.'));
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 3 / 3,
                  ),
                  itemCount: controller.blogs.length,
                  itemBuilder: (context, index) {
                    final blog = controller.blogs[index];
                    return GestureDetector(
                      onTap: () {
                        // Detay sayfasına yönlendirme
                        Get.toNamed('/blog_detail/${blog['id']}');
                      },
                      child: SizedBox(
                        width: 300,
                        height: 200,
                        child: BlogCard(
                          title: blog['title'],
                          imageUrl: blog['cover_image'] ??
                              'https://placekitten.com/400/300',
                          date: blog['created_at'],
                          summary: blog['content'],
                        ),
                      ),
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
