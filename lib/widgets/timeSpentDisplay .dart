import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stop_vapping/main.dart';

class TimeSpentDisplay extends StatelessWidget {
  final int timeSpentInSeconds;

  const TimeSpentDisplay({super.key, required this.timeSpentInSeconds});

  @override
  Widget build(BuildContext context) {
    final time = _convertTime(timeSpentInSeconds);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTimeUnit(time['days'] ?? 0, 'day'),
        _buildTimeUnit(time['hours'] ?? 0, 'hrs'),
        _buildTimeUnit(time['minutes'] ?? 0, 'min'),
        _buildTimeUnit(time['seconds'] ?? 0, 'sec'),
      ],
    );
  }

  Widget _buildTimeUnit(int value, String unit) {
    return SizedBox(
      // height: 60.h,
      width: 60.w,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 24.0.sp,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Text(
              unit,
              style: TextStyle(
                fontSize: 14.0.sp,
                color: Colors.green,
              ),
            ),
            SizedBox(
              height: 5.h,
            )
          ],
        ),
      ),
    );
  }

  Map<String, int> _convertTime(int totalSeconds) {
    int days = totalSeconds ~/ (24 * 3600);
    int hours = (totalSeconds % (24 * 3600)) ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    return {
      'days': days,
      'hours': hours,
      'minutes': minutes,
      'seconds': seconds,
    };
  }
}
