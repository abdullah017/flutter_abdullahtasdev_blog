

import 'package:abdullahtasdev/routes/admin_routes.dart';
import 'package:abdullahtasdev/routes/frontend_routes.dart';

class AppRoutes {
  static final routes = [
    ...AdminRoutes.routes, // Admin panel route'ları
    ...FrontendRoutes.routes, // Frontend route'ları
  ];
}
