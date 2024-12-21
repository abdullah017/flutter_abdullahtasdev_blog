import 'package:abdullahtasdev/presentation/admin/bindings/dashboard_binding.dart';
import 'package:abdullahtasdev/presentation/admin/bindings/post_add_binding.dart';
import 'package:abdullahtasdev/presentation/admin/bindings/post_list_binding.dart';
import 'package:abdullahtasdev/presentation/admin/middleware/auth_middleware.dart';
import 'package:abdullahtasdev/presentation/admin/pages/dashboard_page.dart';
import 'package:abdullahtasdev/presentation/admin/pages/login_page.dart';
import 'package:abdullahtasdev/presentation/admin/pages/post_add_page.dart';
import 'package:abdullahtasdev/presentation/admin/pages/post_edit_page.dart';
import 'package:abdullahtasdev/presentation/admin/pages/post_lists_page.dart';
import 'package:get/get.dart';

class AdminRoutes {
  static final routes = [
    GetPage(
      name: '/admin-login',
      page: () => const AdminLoginPage(),
    ),
    GetPage(
      name: '/admin',
      page: () => const DashboardPage(),
      binding: AdminDashboardBinding(),
      middlewares: [AuthMiddleware()], // Admin panel ana sayfası
    ),
    GetPage(
      name: '/admin/posts',
      page: () => const PostListsPage(),
      binding: PostListBinding(),
      middlewares: [AuthMiddleware()], // Yazıların listelendiği sayfa
    ),
    GetPage(
      name: '/admin/posts/add',
      page: () => const PostAddPage(),
      binding: PostAddBinding(),
      middlewares: [AuthMiddleware()], // Yeni yazı ekleme sayfası
    ),
    GetPage(
      name: '/admin/posts/edit/:id',
      page: () => PostEditPage(
        postId: int.parse(
          Get.parameters['id']!,
        ),
      ),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
