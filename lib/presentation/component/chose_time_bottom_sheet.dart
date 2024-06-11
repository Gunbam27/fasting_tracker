import 'package:flutter/material.dart';

class ChoseTimeBottomSheet extends StatelessWidget {
  const ChoseTimeBottomSheet({super.key});

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
              Expanded(child: Text(textAlign: TextAlign.center, '계획 변경하기')),
              SizedBox(
                width: 40,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
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
                    '14-10',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    '14시간 단식',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '10시간 식사 기간',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text('16-8'),
          Text('18-6'),
          Text('20-4'),
        ],
      ),
    );
  }
}
