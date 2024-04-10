import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class StopWatchScreen extends StatefulWidget {
  const StopWatchScreen({super.key});

  @override
  State<StopWatchScreen> createState() => _StopWatchScreenState();
}

class _StopWatchScreenState extends State<StopWatchScreen> {
  Timer? _timer;

  int _time = 5800;
  bool _isRunning = false;

  List<int> _lapTimes = [];

  //var _lapTimes2 = List.generate(_lapTimes.length, (i) => Text(i));

  void _clickButton() {
    _isRunning = !_isRunning;

    if (_isRunning) {
      _start();
    } else {
      _pause();
    }
  }

  void _start() {
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        _time++;
      });
    });
  }

  void _pause() {
    _timer?.cancel();
  }

  void _reset() {
    _isRunning = false;
    _timer?.cancel();
    _lapTimes.clear();
    _time = 0;
  }

  void _recordLapTime(int _time) {
    _lapTimes.insert(0, _time);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget formatting() {
    return ListView(
      children: _lapTimes
          .map(
            (e) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                    '${List.from(_lapTimes.reversed).indexOf(e) + 1}'
                        .padLeft(2, '0'),
                    style: TextStyle(fontSize: 17)),
                Text('${toMin(e)}:${toSec(e)}.${toMillisec(e)}',
                    style: TextStyle(fontSize: 17))
              ],
            ),
          )
          .toList(),
    );
  }

  String toMin(int time) {
    return '${(time ~/ 6000).remainder(60)}'.padLeft(2, '0');
  }

  String toSec(int time) {
    return '${(time ~/ 100).remainder(60)}'.padLeft(2, '0');
  }

  String toMillisec(int time) {
    return '${time % 100}'.padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    String min = '${(_time ~/ 6000).remainder(60)}'.padLeft(2, '0');
    String sec = '${(_time ~/ 100).remainder(60)}'.padLeft(2, '0');
    String millisec = '${(_time % 100)}'.padLeft(2, '0');
    return Scaffold(
      backgroundColor: Color(0xfffffbff),
      appBar: AppBar(
        title: const Text('StopWatch'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                min,
                style: TextStyle(fontSize: 50),
              ),
              const Text(
                ':',
                style: TextStyle(fontSize: 50),
              ),
              Text(
                sec,
                style: TextStyle(fontSize: 50),
              ),
              const Text(
                '.',
                style: TextStyle(fontSize: 50),
              ),
              Text(
                millisec,
                style: TextStyle(fontSize: 50),
              ),
            ],
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _clickButton();
                  });
                },
                child: _isRunning
                    ? const Icon(Icons.pause)
                    : const Icon(Icons.play_arrow),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          BackGround(),
        ],
      ),
    );
  }
}

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
      duration: Duration(seconds: 4),
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
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff8a55e1), Color(0xfff4c6ca)],
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
      ..color = Color(0xfffffbff)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

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
