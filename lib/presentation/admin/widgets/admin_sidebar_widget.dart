import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250, // Sidebar genişliği
      color: Colors.blueGrey,
      child: Column(
        children: [
          // Sidebar üst kısmı
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.blue,
            width: double.infinity,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  child: FlutterLogo(),
                ),
                SizedBox(height: 10),
                Text(
                  'Admin Panel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Menü öğeleri
          ListTile(
            leading: const Icon(Icons.dashboard, color: Colors.white),
            title:
                const Text('Dashboard', style: TextStyle(color: Colors.white)),
            onTap: () {
              Get.toNamed('/admin');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add, color: Colors.white),
            title:
                const Text('Add Post', style: TextStyle(color: Colors.white)),
            onTap: () {
              Get.toNamed('/admin/posts/add');
            },
          ),
          ListTile(
            leading: const Icon(Icons.list, color: Colors.white),
            title:
                const Text('Post List', style: TextStyle(color: Colors.white)),
            onTap: () {
              Get.toNamed('/admin/posts');
            },
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.white),
            title: const Text('Logout', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Logout işlemi
            },
          ),
        ],
      ),
    );
  }
}
