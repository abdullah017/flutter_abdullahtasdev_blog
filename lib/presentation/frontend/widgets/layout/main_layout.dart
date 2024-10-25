import 'package:flutter/material.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/widgets/top_menu.dart';

class MainLayout extends StatelessWidget {
  final Widget body;

  const MainLayout({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arka Plan Resmi veya Gradient
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://kingstudio.ro/demos/glass-ui/assets/images/blur.jpg'),
                fit: BoxFit.cover,
              ),
            
            ),
          ),
          // Overlay: Frosted Glass Sidebar ve Body
          Column(
            children: [
              const TopMenu(), // Frosted glass sidebar
              Expanded(child: body), // Sayfa içeriği
            ],
          ),
        ],
      ),
    );
  }
}
