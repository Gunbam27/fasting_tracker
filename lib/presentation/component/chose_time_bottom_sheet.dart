import 'package:fasting_tracker/enum/fasting_timer.dart';
import 'package:fasting_tracker/presentation/component/time_option.dart';
import 'package:flutter/material.dart';

class ChoseTimeBottomSheet extends StatelessWidget {
  final Function(FastingTimer selectedTime) onSelect;
  const ChoseTimeBottomSheet({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 58, 16, 16),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.clear,
                  size: 32,
                  color: Colors.grey,
                ),
              ),
              Expanded(
                child: Text(
                  textAlign: TextAlign.center,
                  '계획 변경하기',
                  style: TextStyle(fontSize: 22),
                ),
              ),
              SizedBox(
                width: 40,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          ...FastingTimer.values
              .map((e) => TimeOption(onSelect: onSelect, fastingTimer: e)),
        ],
      ),
    );
  }
}
