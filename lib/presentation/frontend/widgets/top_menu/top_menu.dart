import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TopMenu extends StatefulWidget {
  const TopMenu({super.key});

  @override
  State<TopMenu> createState() => _TopMenuState();
}

class _TopMenuState extends State<TopMenu> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isSearchExpanded = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  // Menüdeki başlıklar
  final List<String> _menuItems = ['Components', 'Sections', 'Templates'];

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          _isSearchExpanded = false;
        });
      }
    });
  }

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 30,
              spreadRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Sol taraftaki logo kısmı
            const Row(
              children: [
                Text(
                  'abdullahtas.dev',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            // Menü öğeleri
            Row(
              children: _menuItems.map((item) {
                int index = _menuItems.indexOf(item);
                return GestureDetector(
                  onTap: () => _onItemTap(index),
                  child: MouseRegion(
                    onEnter: (_) => setState(() {}),
                    onExit: (_) => setState(() {}),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      transform: Matrix4.identity()
                        ..scale(
                          _selectedIndex == index
                              ? 1.2
                              : 1.0, // Büyütme animasyonu
                          _selectedIndex == index ? 1.2 : 1.0,
                        ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Menü İkonu ve Yazı
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 18,
                                color: _selectedIndex == index
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.6),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                item,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: _selectedIndex == index
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: _selectedIndex == index
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          // Seçili olan öğenin alt çizgisi
                          if (_selectedIndex == index)
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              width: 30, // Genişlik arttı
                              height: 4, // Kalınlık arttı
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            // Sağ tarafta arama butonu ve genişleyen arama alanı
            GestureDetector(
              onTap: () {
                setState(() {
                  _isSearchExpanded = !_isSearchExpanded;
                  if (_isSearchExpanded) {
                    _focusNode.requestFocus();
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _isSearchExpanded ? 200 : 100,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Icon(
                      _isSearchExpanded ? Icons.search : Icons.search,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 5),
                    if (_isSearchExpanded)
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search...',
                            hintStyle: TextStyle(color: Colors.white70),
                          ),
                          onSubmitted: (value) {
                            if (kDebugMode) {
                              print("Arama yapıldı: $value");
                            }
                            setState(() {
                              _isSearchExpanded = false;
                            });
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
