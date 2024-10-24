import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.blueGrey[900],
      child: Column(
        children: [
          ListTile(
            title: const Text('Blog', style: TextStyle(color: Colors.white)),
            onTap: () => Get.toNamed('/blog'),
          ),
          ListTile(
            title:
                const Text('Sesli Blog', style: TextStyle(color: Colors.white)),
            onTap: () => Get.toNamed('/audio_blog'),
          ),
          ListTile(
            title:
                const Text('İletişim', style: TextStyle(color: Colors.white)),
            onTap: () => Get.toNamed('/contact'),
          ),
        ],
      ),
    );
  }
}
