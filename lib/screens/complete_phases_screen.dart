import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stop_vapping/controller/vapping_controller.dart';

class CompletePhaseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final VapingController vapingController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Phases'),
        backgroundColor: Colors.black54,
      ),
      body: Obx(() {
        final timeSpent = vapingController.timeSpentVaping.value;

        final List<Map<String, dynamic>> phases = [
          {'name': 'Phase 1', 'duration': 2 * 60}, // 30 minutes
          {'name': 'Phase 2', 'duration': 3 * 60}, // 1 hour
          {'name': 'Phase 3', 'duration': 4 * 60}, // 1.5 hours
        ];

        // Find the index of the current phase based on the elapsed time
        int currentPhaseIndex = 0;
        int accumulatedTime = 0;

        for (int i = 0; i < phases.length; i++) {
          final duration = phases[i]['duration'] as int;
          if (timeSpent >= accumulatedTime + duration) {
            accumulatedTime += duration;
            currentPhaseIndex = i + 1;
          } else {
            break;
          }
        }

        return ListView.builder(
          itemCount: phases.length,
          itemBuilder: (context, index) {
            final phase = phases[index];
            final duration = phase['duration'] as int;
            final isCompleted = index < currentPhaseIndex;
            final isCurrentPhase = index == currentPhaseIndex;
            final timeLeft =
                isCurrentPhase ? (duration - (timeSpent - accumulatedTime)) : 0;

            return Padding(
              padding: EdgeInsets.fromLTRB(16.0.w, 16.h, 16.w, 0.h),
              child: Card(
                color: isCompleted
                    ? Colors.green
                    : (isCurrentPhase ? Colors.yellow : Colors.white),
                child: ListTile(
                  title: Text(
                    phase['name'],
                    style: TextStyle(
                      fontSize: 18,
                      color: isCompleted ? Colors.white : Colors.grey,
                    ),
                  ),
                  subtitle: isCompleted
                      ? null
                      : isCurrentPhase
                          ? Text(
                              'Time Left: ${formatDuration(timeLeft)}',
                              style: const TextStyle(color: Colors.grey),
                            )
                          : Text(
                              'Locked',
                              style: const TextStyle(color: Colors.grey),
                            ),
                  enabled: isCompleted || isCurrentPhase,
                  trailing: isCompleted
                      ? const Icon(Icons.check, color: Colors.white)
                      : null,
                  onTap: isCompleted
                      ? () {
                          Get.snackbar('Phase Completed',
                              'You have completed ${phase['name']}!');
                        }
                      : null,
                ),
              ),
            );
          },
        );
      }),
    );
  }

  String formatDuration(int seconds) {
    final days = (seconds / (24 * 3600)).floor();
    final hours = ((seconds % (24 * 3600)) / 3600).floor();
    final minutes = ((seconds % 3600) / 60).floor();
    return '${days}d ${hours}h ${minutes}m';
  }
}
