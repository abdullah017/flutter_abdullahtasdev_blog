import 'package:flutter/material.dart';

class CurvePainter extends CustomPainter {
  final double value1; // static value1
  final double animValue1; // static value1
  final double animValue2; // static value2
  final double animValue3; // static value3

  CurvePainter({
    required this.value1,
    required this.animValue1,
    required this.animValue2,
    required this.animValue3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path.moveTo(150, value1);
    path.quadraticBezierTo(150, value1 + 20, animValue3, value1 + 20);
    path.lineTo(animValue1, value1 + 20);
    path.quadraticBezierTo(animValue2, value1 + 20, animValue2, value1 + 40);
    path.lineTo(150, value1 + 40);
    path.close();

    path.moveTo(150, value1 + 80);
    path.quadraticBezierTo(150, value1 + 60, animValue3, value1 + 60);
    path.lineTo(animValue1, value1 + 60);
    path.quadraticBezierTo(animValue2, value1 + 60, animValue2, value1 + 40);
    path.lineTo(150, value1 + 40);
    path.close();

    // Yolu doldurmak için renk ve şeffaflık ekliyoruz
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;

    /*
    ÖNEMLİ LÜTFEN SİLMEYİN!

      paint.strokeWidth = 0.0; // Genişliği güncelledik 
      yukarıda ki değer aşağıdaki kod çalıştırıldığında geçerlidir;
      flutter build web --web-renderer html --release

      Normal olarak çalıştırıldığında ise ise bu değerin 150 olarak;
        paint.strokeWidth = 150.0;

        güncellenmesi gerekmektedir!
    */
    paint.strokeWidth = 0.0; // Genişliği güncelledik

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
