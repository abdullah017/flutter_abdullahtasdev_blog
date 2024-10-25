import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/widgets/sidebar/sidebar_item.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  _SideMenuState createState() => _SideMenuState();
}

List<bool> selected = [true, false, false, false];

class _SideMenuState extends State<SideMenu> {
  // Menü adları listesi
  final List<String> menuTitles = [
    "Blog",
    "Sesli Blog",
    "İletişim",
  ];

  // Seçili menü öğesini güncelleyen fonksiyon
  void select(int n) {
    setState(() {
      for (int i = 0; i < selected.length; i++) {
        selected[i] = i == n;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // Yuvarlatılmış köşeler
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: 150, // Genişlik
          color: const Color(0xff3D3655),
          // decoration: const BoxDecoration(
          //   gradient: LinearGradient(
          //     colors: [
          //       Color(0xff8764F6),
          //       Color(0xffD76BAB),
          //       Color(0xff8764F6),
          //     ],
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //   ),
          // ),
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header veya Logo
              const Center(
                child: CircleAvatar(
                  child: FlutterLogo(
                    size: 200,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: Center(child: Text('abc@mail.com\n')),
              ),
              const Divider(color: Colors.white54),
              // Navigation Items
              Expanded(
                child: ListView.builder(
                  itemCount: menuTitles.length,
                  itemBuilder: (context, index) {
                    return NavBarItem(
                      title: menuTitles[index],
                      selected: selected[index],
                      onTap: () {
                        select(index);
                        // İlgili sayfaya yönlendirme (örneğin, Get.toNamed('/blog'))
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
