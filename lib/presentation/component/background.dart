import 'dart:math';

import 'package:flutter/material.dart';

class BackGround extends StatefulWidget {
  const BackGround({super.key});

  @override
  State<BackGround> createState() => _BackGroundState();
}

class _BackGroundState extends State<BackGround>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomALignmentAnimaition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _topAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem(
          tween: Tween(begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: Alignment.topRight, end: Alignment.bottomRight),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: Alignment.bottomRight, end: Alignment.bottomLeft),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: Alignment.bottomLeft, end: Alignment.topLeft),
          weight: 1),
    ]).animate(_controller);

    _bottomALignmentAnimaition = TweenSequence<Alignment>([
      TweenSequenceItem(
          tween: Tween(begin: Alignment.bottomRight, end: Alignment.bottomLeft),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: Alignment.bottomLeft, end: Alignment.topLeft),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: Alignment.topRight, end: Alignment.bottomRight),
          weight: 1),
    ]).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Container(
              width: 500,
              height: 240,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xff8a55e1), const Color(0xfff4c6ca)],
                  begin: _topAlignmentAnimation.value,
                  end: _bottomALignmentAnimaition.value,
                ),
              ),
              child: CustomPaint(
                painter: _painter(animationValue: _controller.value),
              ),
            );
          }),
    );
  }
}

class _painter extends CustomPainter {
  final animationValue;

  _painter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    double heightParameter = 30;
    double periodParameter = 0.5;

    Paint paint = Paint()
      ..color = const Color(0xfffffbff)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    Path path = Path();
    // TODO: do operations here

    for (double i = 0; i < 500; i++) {
      path.lineTo(
          i,
          125 +
              heightParameter *
                  sin(animationValue * pi * 2 +
                      periodParameter * i * (pi / 180)));
      path.moveTo(i, 0);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
