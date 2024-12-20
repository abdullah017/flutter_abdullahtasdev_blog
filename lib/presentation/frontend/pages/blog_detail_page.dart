import 'package:abdullahtasdev/presentation/frontend/widgets/content/blog_detail_content_widget.dart';
import 'package:abdullahtasdev/presentation/frontend/widgets/image/blog_cover_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/blog_detail_controller.dart';

class BlogDetailPage extends GetView<BlogDetailController> {
  const BlogDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final title = controller.blog.value?.title ?? '';
          return Text(title);
        }),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.blog.value == null) {
          return const Center(child: Text('Blog bulunamadı.'));
        }

        return ListView(
          children: [
            BlogCoverImage(imageUrl: controller.blog.value!.coverImage),
            BlogDetailContent(blog: controller.blog.value!),
          ],
        );
      }),
    );
  }
}
