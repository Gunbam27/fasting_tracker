import 'package:flutter/material.dart';

class EndFastingDialog extends StatelessWidget {
  final Function(bool isPause) onPause;
  const EndFastingDialog({super.key, required this.onPause});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(30, 28, 30, 18),
      //actionsPadding: EdgeInsets.all(0),
      title: Text(
        '단식을 중단하시겠습니까?',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      content: Container(
        height: 60,
        child: Column(
          children: [
            Text(
              '아직 목표를 달성하지 못했습니다.',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            Text(
              '정말 종료하시겠습니까?',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // 모달을 닫습니다.
            onPause(true);
          },
          style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.symmetric())),
          child: Text('네',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              )),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // 모달을 닫습니다.
          },
          child: Text(
            '아니요',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Colors.deepPurple.shade200)),
        ),
      ],
    );
  }
}
