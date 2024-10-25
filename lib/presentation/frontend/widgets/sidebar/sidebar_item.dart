import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/widgets/sidebar/indicator.dart';

class NavBarItem extends StatefulWidget {
  final String title;
  final Function onTap;
  final bool selected;

  const NavBarItem({
    super.key,
    required this.title,
    required this.onTap,
    required this.selected,
  });

  @override
  _NavBarItemState createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;

  late Animation<double> _anim1;
  late Animation<double> _anim2;
  late Animation<double> _anim3;
  late Animation<Color?> _color;

  bool hovered = false;

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 275),
    );

    _anim1 = Tween(begin: 150.0, end: 125.0).animate(_controller1);
    _anim2 = Tween(begin: 150.0, end: 25.0).animate(_controller2);
    _anim3 = Tween(begin: 150.0, end: 50.0).animate(_controller2);
    _color = ColorTween(begin: Colors.white, end: const Color(0xff332a7c))
        .animate(_controller2);

    _controller1.addListener(() {
      setState(() {});
    });
    _controller2.addListener(() {
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(NavBarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.selected) {
      _controller1.reverse();
      _controller2.reverse();
    } else {
      _controller1.forward();
      _controller2.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: MouseRegion(
        onEnter: (value) {
          setState(() {
            hovered = true;
          });
        },
        onExit: (value) {
          setState(() {
            hovered = false;
          });
        },
        child: Container(
          width: double.infinity, // Genişliği konteynırın tamamına yaymak için
          color:
              hovered && !widget.selected ? Colors.white12 : Colors.transparent,
          child: Stack(
            children: [
              CustomPaint(
                painter: CurvePainter(
                  value1: 0,
                  animValue1: _anim3.value,
                  animValue2: _anim2.value,
                  animValue3: _anim1.value,
                ),
                child: Container(
                  height: 80.0, // Yüksekliği belirledik
                ),
              ),
              SizedBox(
                height: 80.0,
                width: double.infinity,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: _color.value,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }
}
