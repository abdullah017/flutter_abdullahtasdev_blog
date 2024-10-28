// lib/presentation/frontend/layout/main_layout.dart

import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:abdullahtasdev/presentation/frontend/controllers/menu_controller.dart';
import 'package:abdullahtasdev/presentation/frontend/widgets/top_menu/top_menu.dart';
import 'package:get/get.dart';

class MainLayout extends StatelessWidget {
  final Widget body;

  const MainLayout({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    // Menü Kontrolcüsünü Başlat
    final TopMenuController controller = Get.put(TopMenuController());

    return Scaffold(
      body: Stack(
        children: [
          // Arka Plan Resmi veya Gradient
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay: Frosted Glass Sidebar ve Body
          Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              TopMenu(
                onMenuToggle: () {
                  controller.isMenuExpanded.value =
                      !controller.isMenuExpanded.value;
                },
              ),
              Expanded(child: body), // Sayfa içeriği
            ],
          ),
          // Mobil Menü Paneli ve Overlay
          Obx(() {
            bool isMenuOpen = controller.isMenuExpanded.value;
            bool isMobile = MediaQuery.of(context).size.width < 600;

            if (!isMenuOpen || !isMobile) {
              return const SizedBox.shrink();
            }

            return Stack(
              children: [
                // Yarı saydam overlay
                AnimatedOpacity(
                  opacity: isMenuOpen ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: GestureDetector(
                    onTap: () {
                      controller.isMenuExpanded.value = false;
                    },
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
                // Menü paneli
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  top: 0,
                  bottom: 0,
                  left: isMenuOpen ? 0 : -250,
                  child: Container(
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.3), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 30,
                          spreadRadius: 5,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            // Menü Öğeleri
                            ...controller.menuItems.map((item) {
                              int index = controller.menuItems.indexOf(item);
                              return GestureDetector(
                                onTap: () {
                                  controller.selectedIndex.value = index;
                                  controller.isMenuExpanded.value = false;
                                  // Navigasyon işlemi ekleyin
                                  controller.navigateToPage(index);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 14,
                                        color: controller.selectedIndex.value ==
                                                index
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.6),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        item,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                              controller.selectedIndex.value ==
                                                      index
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                          color: controller
                                                      .selectedIndex.value ==
                                                  index
                                              ? Colors.white
                                              : Colors.white.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                            const SizedBox(height: 20),
                            // Arama Alanı
                            Obx(() => GestureDetector(
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
                                    width: controller.isSearchExpanded.value
                                        ? 180
                                        : 150,
                                    height: 40,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 10, sigmaY: 10),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.search,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 5),
                                              if (controller
                                                  .isSearchExpanded.value)
                                                Expanded(
                                                  child: TextField(
                                                    controller: controller
                                                        .searchController,
                                                    focusNode:
                                                        controller.focusNode,
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                    decoration:
                                                        const InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: 'Ara...',
                                                      hintStyle: TextStyle(
                                                          color:
                                                              Colors.white70),
                                                    ),
                                                    onSubmitted: (value) {
                                                      if (kDebugMode) {
                                                        print(
                                                            "Search performed: $value");
                                                      }
                                                      controller
                                                          .isSearchExpanded
                                                          .value = false;
                                                      if (value
                                                          .trim()
                                                          .isNotEmpty) {
                                                        Get.toNamed(
                                                            '/arama-sonuclari',
                                                            arguments: {
                                                              'query':
                                                                  value.trim()
                                                            });
                                                        // Get.to(
                                                        //   () => SearchResults(
                                                        //     query: value.trim(),
                                                        //   ),
                                                        // );
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
                                )),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
