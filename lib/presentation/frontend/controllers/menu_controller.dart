import 'package:get/get.dart';
import 'package:flutter/material.dart';

class TopMenuController extends GetxController {
  var selectedIndex = 0.obs;
  var isSearchExpanded = false.obs;
  var isMenuExpanded = false.obs;

  final TextEditingController searchController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  final List<String> menuItems = ['Blog', 'Sesli Blog', 'İletişim'];

  // Menü itemleri için rotaları belirliyoruz
  final List<String> menuRoutes = ['/blog', '/sesli-blog', '/iletisim'];

  void navigateToPage(int index) {
    selectedIndex.value = index;
    String route = menuRoutes[index];
    Get.toNamed(route);
    if (isMenuExpanded.value) {
      isMenuExpanded.value = false; // Mobilde menü açık ise kapat
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    searchController.clear();
    focusNode.dispose();
    super.onClose();
  }
}
