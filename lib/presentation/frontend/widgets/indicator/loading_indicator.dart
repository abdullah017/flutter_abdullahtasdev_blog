import 'dart:ui';
import 'package:flutter/material.dart';

class GlassmorphicCircularProgressIndicator extends StatelessWidget {
  const GlassmorphicCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 2,
          ),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.1),
              const Color.fromARGB(255, 255, 255, 255).withOpacity(0.05)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withOpacity(0.8)),
                strokeWidth: 3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
