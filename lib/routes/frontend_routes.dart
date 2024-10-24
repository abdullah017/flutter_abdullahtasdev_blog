
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/pages/blog_page.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/pages/audio_blog_page.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/pages/contact_page.dart';
import 'package:get/get.dart';

class FrontendRoutes {
  static final routes = [
    GetPage(
      name: '/blog',
      page: () =>  BlogPage(), // Blog listesi sayfası
    ),
    GetPage(
      name: '/audio_blog',
      page: () =>  AudioBlogPage(), // Sesli blog listesi sayfası
    ),
    GetPage(
      name: '/contact',
      page: () =>  const ContactPage(), // İletişim sayfası
    ),
    // Eğer blog detay sayfasına gideceksek:
    // GetPage(
    //   name: '/blog_detail/:id',
    //   page: () => BlogDetailPage(
    //       postId: int.parse(Get.parameters['id']!)), // Blog detay sayfası
    // ),
    // // Eğer sesli blog detay sayfasına gideceksek:
    // GetPage(
    //   name: '/audio_blog_detail/:id',
    //   page: () => AudioBlogDetailPage(
    //       postId: int.parse(Get.parameters['id']!)), // Sesli blog detay sayfası
    // ),
  ];
}
