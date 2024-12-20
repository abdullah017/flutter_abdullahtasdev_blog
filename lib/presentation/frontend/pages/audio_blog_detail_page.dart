import 'package:abdullahtasdev/presentation/frontend/widgets/content/audio_blog_detail_content_widget.dart';
import 'package:abdullahtasdev/presentation/frontend/widgets/image/audio_blog_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/audio_blog_detail_controller.dart';


class AudioBlogDetailPage extends GetView<AudioBlogDetailController> {
  const AudioBlogDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.audioBlog.value?.title ?? '')),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.audioBlog.value == null) {
          return const Center(
            child: Text('Audio blog bulunamadı.',
                style: TextStyle(fontSize: 18, color: Colors.grey)),
          );
        }

        final audioBlog = controller.audioBlog.value!;

        return Stack(
          children: [
            AudioBlogBackgroundImage(imageUrl: audioBlog.imageUrl),
            AudioBlogDetailContent(audioBlog: audioBlog),
          ],
        );
      }),
    );
  }
}
