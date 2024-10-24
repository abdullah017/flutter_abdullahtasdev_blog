import 'package:flutter/material.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/admin/controllers/dashboard_controller.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/admin/widgets/admin_sidebar_widget.dart';
import 'package:get/get.dart';

class DashboardPage extends StatelessWidget {
  final DashboardController controller = Get.put(DashboardController());

  DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sabit sidebar
          const AdminSidebar(),

          // İçerik alanı
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dashboard Overview',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),

                  // Post istatistikleri
                  Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatCard(
                              'Total Posts',
                              controller.totalPosts.value.toString(),
                              Colors.blue),
                          _buildStatCard(
                              'Published',
                              controller.publishedPosts.value.toString(),
                              Colors.green),
                          _buildStatCard(
                              'Drafts',
                              controller.draftPosts.value.toString(),
                              Colors.red),
                        ],
                      )),

                  const SizedBox(height: 30),

                  // Son eklenen postları göster
                  Text(
                    'Latest Posts',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),

                  Obx(() => controller.latestPosts.isEmpty
                      ? const Text('No posts available.')
                      : _buildPostList(controller)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // İstatistik kartları
  Widget _buildStatCard(String title, String count, Color color) {
    return Card(
      color: color,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              count,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Son eklenen postları listeleyen widget
  Widget _buildPostList(DashboardController controller) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.latestPosts.length,
      itemBuilder: (context, index) {
        final post = controller.latestPosts[index];
        return ListTile(
          title: Text(post['title']),
          subtitle: Text(post['created_at']),
          trailing: const Icon(Icons.edit),
          onTap: () {
            Get.toNamed('/admin/posts/edit', arguments: post['id']);
          },
        );
      },
    );
  }
}
