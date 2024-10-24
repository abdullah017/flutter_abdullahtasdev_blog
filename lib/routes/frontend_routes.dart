import 'package:flutter_abdullahtasdev_blog/presentation/frontend/pages/blog_page.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/pages/audio_blog_page.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/pages/contact_page.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/pages/blog_detail_page.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/pages/audio_blog_detail_page.dart';
import 'package:get/get.dart';

class FrontendRoutes {
  static final routes = [
    GetPage(
      name: '/blog',
      page: () => BlogPage(), // Blog listesi sayfası
    ),
    GetPage(
      name: '/audio_blog',
      page: () => AudioBlogPage(), // Sesli blog listesi sayfası
    ),
    GetPage(
      name: '/contact',
      page: () => const ContactPage(), // İletişim sayfası
    ),
    GetPage(
      name: '/blog_detail/:id',
      page: () => BlogDetailPage(
        // blogId: int.parse(Get.parameters['id']!), // Blog ID'yi URL'den alıyoruz
      ),
    ),
    GetPage(
      name: '/audio_blog_detail/:id',
      page: () => AudioBlogDetailPage(
        blogId: int.parse(
            Get.parameters['id']!), // Sesli Blog ID'yi URL'den alıyoruz
      ),
    ),
  ];
}
