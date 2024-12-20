import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Koyu arka plan rengi
      body: Stack(
        children: [
          // Bulanık arka plan efekti
          Positioned.fill(
            child: Image.asset(
              'assets/images/dd.jpg',
              fit: BoxFit.cover,
              color: Colors.black.withValues(
                alpha: (0.7),
              ),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 404 Sayısı
                Text(
                  '404',
                  style: TextStyle(
                    fontSize: 150,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withValues(
                      alpha: (0.15),
                    ),
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.white.withValues(
                          alpha: (0.3),
                        ),
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Page Not Found Metni
                Text(
                  'Page Not Found!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(
                      alpha: (0.9),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Geri Dönüş Butonu
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        backgroundColor: Colors.white.withValues(
                          alpha: (0.2),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: BorderSide(
                            color: Colors.white.withValues(
                              alpha: (0.3),
                            ),
                          ),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Get.offAllNamed('/blog'); // Geri dönüş işlemi
                      },
                      child: const Text(
                        'Back home',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
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
