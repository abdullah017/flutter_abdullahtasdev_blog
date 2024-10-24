import 'package:flutter/material.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/admin/widgets/admin_sidebar_widget.dart';

class AdminLayout extends StatelessWidget {
  final Widget child; // Her admin sayfası bu child olacak

  const AdminLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const AdminSidebar(), // Sabit sidebar
          Expanded(
            child: Column(
              children: [
                // Üst bar (AppBar)
                AppBar(
                  title: const Text('Admin Panel'),
                  backgroundColor: Colors.blueGrey,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: child, // İçeriği değiştirilebilen kısım
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
