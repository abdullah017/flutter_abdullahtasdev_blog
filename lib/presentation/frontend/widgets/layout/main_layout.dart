import 'package:flutter/material.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/widgets/sidebar/sidebar_widget.dart';

class MainLayout extends StatelessWidget {
  final Widget body;

  const MainLayout({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Sidebar(), // Sabit sidebar burada
          Expanded(child: body), // Her sayfanın içeriği
        ],
      ),
    );
  }
}
