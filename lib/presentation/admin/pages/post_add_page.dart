import 'package:abdullahtasdev/presentation/admin/widgets/form/post_add_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/post_add_controller.dart';

class PostAddPage extends GetView<PostAddController> {
  const PostAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Post'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PostAddForm(controller: controller),
      ),
    );
  }
}
