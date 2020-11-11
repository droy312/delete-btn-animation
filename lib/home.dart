import 'dart:async';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final Color bgColor = Color.fromRGBO(235, 238, 253, 1);
  final Color btnBgColor = Color.fromRGBO(27, 30, 47, 1);
  final Color blue = Color.fromRGBO(85, 124, 255, 1);
  static final Color white = Colors.white.withOpacity(.9);
  final Color shadowColor = Colors.black12;

  final double width = 240;
  final double height = 80;
  final double topContainerHeight = 160;
  double size = 1.0;

  final double borderRadius = 10;
  final double shadowPosY = 4;
  final double iconSize = 50;
  final double fileIconSize = 30;

  final String text = 'Delete Item';

  AnimationController a1, a2, a3;

  TextStyle _style(double fontSize) => TextStyle(
        color: white,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      );

  void deleteTextAnimation() {
    a1.forward();
  }

  void deleteIconAnimation() {
    a2.forward();
  }

  void fileIconAnimation() {
    a3.forward();
  }

  double changeOpacity(double value) {
    if (value > 0 && value <= .3) {
      return 3.33 * value;
    } else if (value == null || value == 0) {
      return 0;
    } else {
      return 1;
    }
  }

  double changePosY(double value) {
    if (value > .3) {
      return 180 * (value - .3);
    } else {
      return 0;
    }
  }

  Widget changeIcon(double posY) {
    if (posY >= 50 && posY <= 70) {
      return Container();
    } else if (posY > 70) {
      return Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: blue,
        ),
        child: Icon(Icons.done_rounded, color: white, size: 22),
      );
    } else {
      return Icon(Icons.file_copy, color: blue, size: 30);
    }
  }

  void startAnimation() {
    deleteTextAnimation();
    deleteIconAnimation();
    Timer(Duration(milliseconds: 300), () {
      a3.forward();
    });

    Timer(Duration(milliseconds: 2400), resetAnimation);
  }

  void resetAnimation() {
    a1.reverse();
    a2.reverse();
    a3.reset();
  }

  @override
  void initState() {
    super.initState();

    a1 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    a2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    a3 = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1400));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: GestureDetector(
          onTapDown: (d) {
            setState(() {
              size = .95;
            });
          },
          onTapUp: (d) {
            setState(() {
              size = 1;
            });
            startAnimation();
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: topContainerHeight,
                width: 0,
              ),
              Container(
                width: width * size,
                height: height * size,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      offset: Offset(0, shadowPosY),
                      blurRadius: shadowPosY * 2,
                    ),
                  ],
                  color: btnBgColor,
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 40 * size),
                  child: AnimatedBuilder(
                    animation: a1,
                    builder: (context, child) {
                      return Opacity(
                        opacity: 1 * (1 - a1.value),
                        child: Transform.translate(
                          offset: Offset(10 * a1.value, 0),
                          child: child,
                        ),
                      );
                    },
                    child: Text(text, style: _style(24 * size)),
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: a3,
                builder: (BuildContext context, Widget child) {
                  final posY = changePosY(a3.value);
                  return Positioned(
                    top: posY,
                    child: Opacity(
                      opacity: changeOpacity(a3.value),
                      child: changeIcon(posY),
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                animation: a2,
                builder: (context, child) {
                  return Positioned(
                    left: 26 * size + ((width - iconSize) / 2 - 26) * a2.value,
                    top: (((height - iconSize) / 2) * size) + 40,
                    child: Icon(
                      Icons.delete,
                      size: iconSize * size,
                      color: white,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
