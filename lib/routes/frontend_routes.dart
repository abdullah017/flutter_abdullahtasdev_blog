// lib/routes/frontend_routes.dart

import 'package:abdullahtasdev/core/utils/slug_utils.dart';
import 'package:abdullahtasdev/presentation/frontend/pages/404_notfound_page.dart';
import 'package:abdullahtasdev/presentation/frontend/pages/audio_blog_detail_page.dart';
import 'package:abdullahtasdev/presentation/frontend/pages/audio_blog_page.dart';
import 'package:abdullahtasdev/presentation/frontend/pages/blog_detail_page.dart';
import 'package:abdullahtasdev/presentation/frontend/pages/blog_page.dart';
import 'package:abdullahtasdev/presentation/frontend/pages/contact_page.dart';
import 'package:abdullahtasdev/presentation/frontend/pages/searchresult_page.dart';
import 'package:get/get.dart';

class FrontendRoutes {
  static final routes = [
    GetPage(
      name: '/blog',
      page: () => BlogPage(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: '/sesli-blog',
      page: () => AudioBlogPage(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: '/iletisim',
      page: () => const ContactPage(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: '/blog-detay/:slug',
      page: () {
        final slug = Get.parameters['slug']!;
        final id = SlugUtils.extractIdFromSlug(slug);
        return BlogDetailPage(blogId: id);
      },
      //transition: Transition.noTransition,
    ),
    GetPage(
      name: '/sesli-blog-detay/:slug',
      page: () {
        final slug = Get.parameters['slug']!;
        final id = SlugUtils.extractIdFromSlug(slug);
        return AudioBlogDetailPage(blogId: id);
      },
      //transition: Transition.noTransition,
    ),
    GetPage(
      name: '/arama-sonuclari',
      page: () {
        return SearchResults(query: Get.arguments['query']);
      },
      transition: Transition.noTransition,
    ),
    GetPage(
      name: '/404',
      page: () => const NotFoundPage(),
      //transition: Transition.noTransition,
    ),
  ];
  static final unknownRoute = GetPage(
    name: '/404',
    page: () => const NotFoundPage(),
    //transition: Transition.noTransition,
  );
}
