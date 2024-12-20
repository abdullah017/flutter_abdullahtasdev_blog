import 'package:abdullahtasdev/presentation/frontend/widgets/content/audio_blog_content_widget.dart';
import 'package:abdullahtasdev/presentation/frontend/widgets/header/audio_blog_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/audio_blog_controller.dart';

class AudioBlogPage extends GetView<AudioBlogController> {
  const AudioBlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sesli Bloglar'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: controller.resetAudioBlogs,
        child: CustomScrollView(
          controller: controller.scrollController,
          slivers: const [
            AudioBlogHeader(),
            AudioBlogContent(),
          ],
        ),
      ),
    );
  }
}
