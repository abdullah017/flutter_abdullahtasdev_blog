import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:abdullahtasdev/firebase_options.dart';
import 'package:abdullahtasdev/routes/app_routes.dart';
import 'package:abdullahtasdev/routes/frontend_routes.dart';
import 'package:get/get.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:meta_seo/meta_seo.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kIsWeb) {
    // Path tabanlı URL stratejisini kullanarak hash (#) karakterini kaldır
    setPathUrlStrategy();
    MetaSEO().config();
    final MetaSEO meta = MetaSEO();
    meta.author(author: 'abdullah taş');
    meta.description(description: 'Flutter blog');
    meta.ogDescription(ogDescription: 'Flutter blog');
    meta.ogTitle(ogTitle: 'Flutter Blog');
    meta.keywords(
      keywords:
          'Flutter, dart, hasura, flutter web, flutter blog, flutter widget, flutter app, flutter web app, flutter mobile app, abdullahtas, abdullahtasdev,',
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Abdullahtas.dev',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(), // Light tema
        darkTheme: ThemeData.dark(), // Dark tema
        themeMode: ThemeMode.system, // Sistem temasına göre tema seçimi
        initialRoute: '/blog', // Uygulama açıldığında ilk açılacak sayfa
        getPages: AppRoutes.routes, // Tüm uygulama route'larını yöneten yapı
        unknownRoute: FrontendRoutes.unknownRoute);
  }
}
