import 'package:flutter_abdullahtasdev_blog/presentation/admin/pages/dashboard_page.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/admin/pages/post_add_page.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/admin/pages/post_edit_page.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/admin/pages/post_lists_page.dart';
import 'package:get/get.dart';

class AdminRoutes {
  static final routes = [
    GetPage(
      name: '/admin',
      page: () => DashboardPage(), // Admin panel ana sayfası
    ),
    GetPage(
      name: '/admin/posts',
      page: () => PostListPage(), // Yazıların listelendiği sayfa
    ),
    GetPage(
      name: '/admin/posts/add',
      page: () => PostAddPage(), // Yeni yazı ekleme sayfası
    ),
    GetPage(
      name: '/admin/posts/edit/:id',
      page: () => PostEditPage(
        postId: int.parse(Get.parameters['id']!), // ID'yi URL'den alıyoruz
        // currentTitle: Get.arguments['title'], // Title'ı arguments ile geçiyoruz
        // currentContent:
        //     Get.arguments['content'], // İçeriği arguments ile geçiyoruz
        // currentPublished: Get.arguments[
        //     'isPublished'], // Yayında olup olmadığını arguments ile geçiyoruz
      ),
    ),
  ];
}
