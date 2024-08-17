import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:stop_vapping/controller/vapping_controller.dart';

class ChartScreen extends StatelessWidget {
  final VapingController vapingController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weekly Progress')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return BarChart(BarChartData(
            barGroups: vapingController.weeklyPuffData.value
                .asMap()
                .entries
                .map((entry) => BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          // y:
                          // colors: [Colors.blue],
                          toY: entry.value.toDouble(),
                        )
                      ],
                    ))
                .toList(),
          ));
        }),
      ),
    );
  }
}
