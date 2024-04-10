import 'dart:async';
import 'dart:math';

import 'package:fasting_tracker/background.dart';
import 'package:flutter/material.dart';

class StopWatchScreen extends StatefulWidget {
  const StopWatchScreen({super.key});

  @override
  State<StopWatchScreen> createState() => _StopWatchScreenState();
}

class _StopWatchScreenState extends State<StopWatchScreen> {
  Timer? _timer;

  int _time = 57600;
  int _currentTime = 57000;
  double _progress = 0;

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
        _progress = _currentTime / _time;
        print(_progress);
        if (_progress >= 1) {
          _pause(); // 57600초가 지나면 타이머를 멈추도록 함
        }
      });
    });
  }

  void _pause() {
    _timer?.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _progress = _currentTime / _time;
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
            timeFormat: timeFormat(),
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
          const BackGround(),
        ],
      ),
    );
  }
}

class CircularProgress extends StatefulWidget {
  const CircularProgress(
      {super.key, required this.progress, required this.timeFormat});
  final double progress;
  final String timeFormat;
  @override
  State<CircularProgress> createState() => _CircularProgressState();
}

class _CircularProgressState extends State<CircularProgress>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  Animation<double>? _progressTweenAnimation;
  final double _circularProgressSize = 0.8;
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
          progress: widget.progress),
      child: Container(
        width: size.width * _circularProgressSize,
        height: size.width * _circularProgressSize,
        child: Center(
          child: Text(
            widget.timeFormat,
            style: TextStyle(
                color: Colors.black87,
                fontSize: 50,
                fontWeight: FontWeight.w600),
          ),
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
      ..strokeWidth = 20
      ..color = Colors.purple.shade50
      ..style = PaintingStyle.stroke;

    final paintProgress = Paint()
      ..strokeWidth = 10
      ..color = Colors.deepPurple.shade200
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
