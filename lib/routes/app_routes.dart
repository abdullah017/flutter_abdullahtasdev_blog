

import 'package:flutter_abdullahtasdev_blog/routes/admin_routes.dart';
import 'package:flutter_abdullahtasdev_blog/routes/frontend_routes.dart';

class AppRoutes {
  static final routes = [
    ...AdminRoutes.routes, // Admin panel route'ları
    ...FrontendRoutes.routes, // Frontend route'ları
  ];
}
