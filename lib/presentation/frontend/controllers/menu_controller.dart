import 'package:get/get.dart';
import 'package:flutter/material.dart';

class TopMenuController extends GetxController {
  var selectedIndex = 0.obs;
  var isSearchExpanded = false.obs;
  var isMenuExpanded = false.obs;

  final TextEditingController searchController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  final List<String> menuItems = ['Blog', 'Sesli Blog', 'İletişim'];

  @override
  void onClose() {
    searchController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}
