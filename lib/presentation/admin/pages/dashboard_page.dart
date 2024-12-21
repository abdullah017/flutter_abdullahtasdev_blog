import 'package:abdullahtasdev/presentation/admin/widgets/admin_sidebar_widget.dart';
import 'package:abdullahtasdev/presentation/admin/widgets/card/dashboard_stat_card_widget.dart';
import 'package:abdullahtasdev/presentation/admin/widgets/list/dashboard_post_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const AdminSidebar(),
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
                  Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          DashboardStatCard(
                              title: 'Total Posts',
                              count: controller.totalPosts.value.toString(),
                              color: Colors.blue),
                          DashboardStatCard(
                              title: 'Published',
                              count: controller.publishedPosts.value.toString(),
                              color: Colors.green),
                          DashboardStatCard(
                              title: 'Drafts',
                              count: controller.draftPosts.value.toString(),
                              color: Colors.red),
                        ],
                      )),
                  const SizedBox(height: 30),
                  Text(
                    'Latest Posts',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  Obx(() => controller.latestPosts.isEmpty
                      ? const Text('No posts available.')
                      : DashboardPostList(posts: controller.latestPosts)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
