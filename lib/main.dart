import 'package:flutter/material.dart';
import 'package:flutter_abdullahtasdev_blog/firebase_options.dart';
import 'package:flutter_abdullahtasdev_blog/routes/app_routes.dart';
import 'package:get/get.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Firebase servisini initialize etmek için

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Project',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // Light tema
      darkTheme: ThemeData.dark(), // Dark tema
      themeMode: ThemeMode.system, // Sistem temasına göre tema seçimi
      initialRoute: '/blog', // Uygulama açıldığında ilk açılacak sayfa
      getPages: AppRoutes.routes, // Tüm uygulama route'larını yöneten yapı
    );
  }
}
