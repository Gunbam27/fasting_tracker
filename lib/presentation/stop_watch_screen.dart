import 'dart:async';
import 'dart:math';

import 'package:fasting_tracker/enum/fasting_timer.dart';
import 'package:fasting_tracker/presentation/complete_screen.dart';
import 'package:fasting_tracker/presentation/component/background.dart';
import 'package:fasting_tracker/presentation/component/chose_time_bottom_sheet.dart';
import 'package:fasting_tracker/presentation/component/end_fasting_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StopWatchScreen extends StatefulWidget {
  final FastingTimer fastingTimer;
  const StopWatchScreen({super.key, required this.fastingTimer});

  @override
  State<StopWatchScreen> createState() => _StopWatchScreenState();
}

class _StopWatchScreenState extends State<StopWatchScreen>
    with WidgetsBindingObserver {
  Timer? _timer;
  int _currentTime = 0;
  double _progress = 0;

  bool _isRunning = false;

  late int _time; //총 단식 시간

  DateTime? _startTime; //단식 시작 시간
  DateTime? _pausedTime; //앱이 중지했을 때 시간
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _time = widget.fastingTimer.fastingDuration;
    _loadTimerState();
    _progress = _currentTime / _time;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _saveTimerState();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _saveTimerState();
    } else if (state == AppLifecycleState.resumed) {
      _loadTimerState();
    }
  }

  String timeFormat() {
    int hours = (_currentTime ~/ 3600).toInt();
    int minutes = (_currentTime ~/ 60 % 60).toInt();
    int seconds = (_currentTime % 60).toInt();

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return '$hoursStr:$minutesStr:$secondsStr';
  }

  Future<void> _clickButton() async {
    setState(() {
      _isRunning = true;
    });

    if (_isRunning) {
      _start();
    }
  }

  void _start() {
    _startTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime++;
        _progress = _currentTime / _time;
        if (_progress >= 1) {
          _pause(); // 단식시간에 따라 타이머를 멈추도록 함
        }
      });
    });
  }

  void _pause() {
    _reset();
    _resetTimerState();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CompleteScreen(),
      ),
    );
  }

  void _reset() {
    setState(() {
      _timer?.cancel();
      _currentTime = 0;
      _progress = 0;
      _isRunning = false;
      _startTime = null;
      _pausedTime = null;
    });
  }

  //SharedPreference 사용 기능들
  void _saveTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentTime', _currentTime);
    await prefs.setBool('isRunning', _isRunning);
    await prefs.setString('startTime', _startTime?.toIso8601String() ?? '');
    await prefs.setString('pausedTime', DateTime.now().toIso8601String());
  }

  void _loadTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    _reset();
    setState(() {
      _currentTime = prefs.getInt('currentTime') ?? 0;
      _isRunning = prefs.getBool('isRunning') ?? false;
      _startTime = DateTime.tryParse(prefs.getString('startTime') ?? '');
      _pausedTime = DateTime.tryParse(prefs.getString('pausedTime') ?? '');
      if (_isRunning) {
        if (_pausedTime != null) {
          final now = DateTime.now();
          //DateTime.now().difference를 사용해서 시간차 구하기
          final elapsed = now.difference(_pausedTime!).inSeconds;
          _currentTime += elapsed;
          _startTime = now;
        }
        _start();
      }
    });
  }

  Future<void> _resetTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentTime');
    await prefs.remove('isRunning');
    await prefs.remove('startTime');
    await prefs.remove('pausedTime');
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
                onPressed: () async {
                  if (_isRunning) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return EndFastingDialog(
                          onPause: (bool isPause) {
                            if (isPause) {
                              _pause();
                            }
                          },
                        ); // 모달을 표시합니다.
                      },
                    );
                  } else {
                    await _clickButton();
                  }
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
  FastingTimer _shownTimer = FastingTimer.fourteenTen;

  FastingTimer get shownTimer => _shownTimer;

  CircularProgress(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return ChoseTimeBottomSheet(
                          onSelect: (FastingTimer selectedTime) {
                        setState(() {
                          widget._shownTimer = selectedTime;
                        });
                      });
                    },
                  );
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 8), // 위아래 10, 좌우 20의 여백 설정
                  ),
                ),
                child: SizedBox(
                  width: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget._shownTimer.label,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Icon(
                        Icons.edit,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                widget.timeFormat,
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 50,
                    fontWeight: FontWeight.w600),
              ),
            ],
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
