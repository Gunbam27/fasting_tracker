import 'package:fasting_tracker/enum/fasting_timer.dart';
import 'package:flutter/material.dart';

class TimeOption extends StatelessWidget {
  final Function(FastingTimer selectedTime) onSelect;
  final FastingTimer fastingTimer;
  const TimeOption(
      {super.key, required this.onSelect, required this.fastingTimer});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          onSelect.call(fastingTimer);
          Navigator.pop(context);
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.blue.shade100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fastingTimer.label,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                '${24 - fastingTimer.eatingDuration}시간 단식',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                '${fastingTimer.eatingDuration}시간 식사 기간',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
