import 'package:abdullahtasdev/presentation/frontend/widgets/search/mobile_search_widget.dart';
import 'package:abdullahtasdev/presentation/frontend/widgets/search/web_search_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/search_controller.dart';

class SearchResultPage extends GetView<PostSearchController> {
  final String query;

  const SearchResultPage({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    controller.performSearch(query);

    return Scaffold(
      appBar: AppBar(
        title: Text('Arama Sonuçları: "$query"'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return const SearchResultMobile();
          } else {
            return const SearchResultWeb();
          }
        },
      ),
    );
  }
}
