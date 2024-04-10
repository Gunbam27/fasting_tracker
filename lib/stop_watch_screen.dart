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

  int _time = 57600;
  int _currentTime = 100;
  double _progress = 0;
  double remainTime() {
    return _currentTime / _time;
  }

  bool _isRunning = false;

  String timeFormat() {
    int hours = (_currentTime ~/ 3600).toInt();
    int minutes = (_currentTime ~/ 60 % 60).toInt();
    int seconds = (_currentTime % 60).toInt();

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    String timeString = '$hoursStr:$minutesStr:$secondsStr';

    return timeString;
  }

  void _clickButton() {
    _isRunning = !_isRunning;

    if (_isRunning) {
      _start();
    } else {
      _pause();
    }
  }

  void _start() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime++;
      });
    });
  }

  void _pause() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffffbff),
      appBar: AppBar(
        title: const Text('단식 추적기'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            height: 30,
          ),
          CircularProgress(
            progress: _progress,
          ),
          const SizedBox(height: 40),
          Center(
            child: Container(
              width: 260,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _clickButton();
                  });
                },
                child: _isRunning
                    ? const Text(
                        '단식 종료',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      )
                    : const Text(
                        '단식 시작',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ),
          FloatingActionButton(onPressed: () {
            setState(() {
              _progress += 1;
              if (_progress > 57600) {
                _progress = 0;
              }
            });
          }),
          const BackGround(),
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
              height: 250,
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

class CircularProgress extends StatefulWidget {
  final double progress;
  const CircularProgress({super.key, required this.progress});

  @override
  State<CircularProgress> createState() => _CircularProgressState();
}

class _CircularProgressState extends State<CircularProgress>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  Animation<double>? _progressTweenAnimation;
  final double _circularProgressSize = 0.3;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));

    _progressTweenAnimation = Tween<double>(begin: 0, end: widget.progress)
        .animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    _animationController.forward();
  }

  @override
  void didUpdateWidget(covariant CircularProgress oldWidget) {
    _animationController.reset();
    _progressTweenAnimation =
        Tween<double>(begin: oldWidget.progress, end: widget.progress)
            .animate(_animationController)
          ..addListener(() {});

    _animationController.forward();

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return CustomPaint(
      painter: CircularProgressPainter(
          circularProgressSize: size.width * _circularProgressSize,
          progress: _progressTweenAnimation?.value ?? 0),
      child: Container(
        width: size.width * _circularProgressSize,
        height: size.width * _circularProgressSize,
        child: Center(
          child: Text(
              "${(_progressTweenAnimation?.value ?? 0).toStringAsFixed(0)}%"),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class CircularProgressPainter extends CustomPainter {
  final double circularProgressSize;
  final double progress;
  final onePercentageToRadian = 0.06283;

  CircularProgressPainter(
      {required this.circularProgressSize, required this.progress});
  @override
  void paint(Canvas canvas, Size size) {
    final paintBackground = Paint()
      ..strokeWidth = 16
      ..color = Colors.grey
      ..style = PaintingStyle.stroke;

    final paintProgress = Paint()
      ..strokeWidth = 12
      ..color = Colors.green
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      Offset(circularProgressSize / 2, circularProgressSize / 2),
      circularProgressSize / 2,
      paintBackground,
    );

    canvas.drawArc(
        Rect.fromCenter(
            center: Offset(circularProgressSize / 2, circularProgressSize / 2),
            width: circularProgressSize,
            height: circularProgressSize),
        3 * pi / 2,
        _convertPercentageToRadian(),
        false,
        paintProgress);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  double _convertPercentageToRadian() {
    return onePercentageToRadian * progress * 100;
  }
}
