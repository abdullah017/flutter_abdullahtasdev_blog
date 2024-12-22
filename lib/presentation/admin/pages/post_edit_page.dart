import 'package:abdullahtasdev/presentation/admin/widgets/form/post_edit_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/post_edit_controller.dart';

class PostEditPage extends GetView<PostEditController> {
  final int postId;

  const PostEditPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Post'),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: PostEditForm(),
      ),
    );
  }
}
