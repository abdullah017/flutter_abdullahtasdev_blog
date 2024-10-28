// lib/presentation/frontend/widgets/top_menu/top_menu.dart

import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:abdullahtasdev/presentation/frontend/controllers/menu_controller.dart';

class TopMenu extends StatelessWidget {
  final VoidCallback onMenuToggle;

  TopMenu({super.key, required this.onMenuToggle});

  final TopMenuController controller = Get.find<TopMenuController>();

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: Colors.white.withOpacity(0.3), width: 2),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'abdullahtas.dev',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (!isMobile) ..._buildDesktopMenuItems(),
                if (isMobile) _buildMobileMenuButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDesktopMenuItems() {
    return [
      Row(
        children: controller.menuItems.map((item) {
          int index = controller.menuItems.indexOf(item);
          return Obx(() => GestureDetector(
                onTap: () => controller.navigateToPage(index),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    transform: Matrix4.identity()
                      ..scale(
                        controller.selectedIndex.value == index ? 1.2 : 1.0,
                        controller.selectedIndex.value == index ? 1.2 : 1.0,
                      ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 18,
                              color: controller.selectedIndex.value == index
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.6),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              item,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    controller.selectedIndex.value == index
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                color: controller.selectedIndex.value == index
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                        if (controller.selectedIndex.value == index)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            width: 30,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ));
        }).toList(),
      ),
      const SizedBox(width: 20),
      // Arama Butonu ve Genişleyen Arama Alanı
      Obx(
        () => GestureDetector(
          onTap: () {
            controller.isSearchExpanded.value =
                !controller.isSearchExpanded.value;
            if (controller.isSearchExpanded.value) {
              controller.focusNode.requestFocus();
            } else {
              controller.focusNode.unfocus();
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: controller.isSearchExpanded.value ? 200 : 100,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 5),
                      if (controller.isSearchExpanded.value)
                        Expanded(
                          child: TextField(
                            controller: controller.searchController,
                            focusNode: controller.focusNode,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Ara....',
                              hintStyle: TextStyle(color: Colors.white70),
                            ),
                            onSubmitted: (value) {
                              if (kDebugMode) {
                                print("Search performed: $value");
                              }
                              controller.isSearchExpanded.value = false;
                              if (value.trim().isNotEmpty) {
                                // Get.to(
                                //     () => SearchResults(query: value.trim()));

                                Get.toNamed('/arama-sonuclari',
                                    arguments: {'query': value.trim()});
                              }
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildMobileMenuButton() {
    return Obx(() => IconButton(
          icon: Icon(
            controller.isMenuExpanded.value ? Icons.close : Icons.menu,
            color: Colors.white,
          ),
          onPressed: onMenuToggle,
        ));
  }
}
