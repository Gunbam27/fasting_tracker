import 'package:fasting_tracker/enum/fasting_timer.dart';
import 'package:fasting_tracker/presentation/stop_watch_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '단식 추적기',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StopWatchScreen(
        fastingTimer: FastingTimer.fourteenTen,
      ),
    );
  }
}
