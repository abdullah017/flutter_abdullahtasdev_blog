// lib/presentation/frontend/pages/blog_detail_page.dart

import 'dart:convert';
import 'package:abdullahtasdev/data/models/blog_model.dart';
import 'package:abdullahtasdev/data/repositories/front_repositories/blog_repositories.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:abdullahtasdev/presentation/frontend/controllers/blog_detail_controller.dart';

class BlogDetailPage extends StatelessWidget {
  final int blogId;

  const BlogDetailPage({super.key, required this.blogId});

  @override
  Widget build(BuildContext context) {
    // BlogRepository'yi GetX ile inject ettiğinizi varsayıyoruz
    final blogRepository = Get.find<BlogRepository>();
    final controller = Get.put(
      BlogDetailController(
        blogRepository: blogRepository,
        blogId: blogId,
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Obx(() {
          final title = controller.blog.value?.title ?? '';
          return Text(
            title,
            style: const TextStyle(
              color: kIsWeb ? Colors.black : Colors.white,
            ),
          );
        }),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final blog = controller.blog.value;

        if (blog == null) {
          return const Center(child: Text('Blog bulunamadı.'));
        }

        final htmlContent = _convertDeltaToHtml(blog.content);

        return ListView(
          children: [
            _buildCoverImage(blog.coverImage),
            _buildContent(blog, htmlContent),
          ],
        );
      }),
    );
  }

  Widget _buildCoverImage(String imageUrl) {
    return Stack(
      children: [
        if (imageUrl.isNotEmpty)
          CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => Container(
              width: double.infinity,
              height: 300,
              color: Colors.grey,
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              width: double.infinity,
              height: 300,
              color: Colors.grey,
              child: const Icon(
                Icons.broken_image,
                color: Colors.white,
                size: 50,
              ),
            ),
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
          ),
        Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.5),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(Blog blog, String htmlContent) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              blog.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: kIsWeb ? Colors.black : Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Tarih: ${_formatDate(blog.createdAt)}',
              style: const TextStyle(
                fontSize: 14,
                color: kIsWeb ? Colors.black : Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: Get.size.width > 600
                      ? Get.size.width * 0.6
                      : double.infinity,
                ),
                child: SelectionArea(
                  child: HtmlWidget(
                    htmlContent,
                    onTapUrl: (url) {
                      launchUrl(Uri.parse(url));
                      return true;
                    },
                    textStyle: const TextStyle(
                      fontSize: 16.0,
                      color: kIsWeb ? Colors.black : Colors.white,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _convertDeltaToHtml(String content) {
    try {
      final delta = jsonDecode(content) as List<dynamic>;
      final convertedDelta = List<Map<String, dynamic>>.from(delta);
      final converter = QuillDeltaToHtmlConverter(convertedDelta);
      return converter.convert();
    } catch (e) {
      if (kDebugMode) {
        print('Content JSON Parse Hatası: $e');
      }
      return '';
    }
  }

  String _formatDate(DateTime date) {
    try {
      return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
    } catch (e) {
      return 'Geçersiz Tarih';
    }
  }
}
