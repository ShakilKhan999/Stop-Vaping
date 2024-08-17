import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:stop_vapping/controller/vapping_controller.dart';
import 'package:stop_vapping/screens/complete_phases_screen.dart';
import 'package:stop_vapping/screens/craving_support_screens.dart';
import 'package:stop_vapping/screens/profile_screen.dart';
import 'package:stop_vapping/widgets/timeSpentDisplay%20.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final VapingController vapingController = Get.find();
  Timer? _timer;
  int _timeRemaining = 0;

  void startTimer() {
    setState(() {
      _timeRemaining = 5 * 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String formatDuration(int seconds) {
    final days = (seconds / (24 * 3600)).floor();
    final hours = ((seconds % (24 * 3600)) / 3600).floor();
    final minutes = ((seconds % 3600) / 60).floor();
    return '${days}d ${hours}h ${minutes}m';
  }

  void showInputDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController puffsController = TextEditingController();
        return AlertDialog(
          title: Text('Set New Goal'),
          content: TextField(
            controller: puffsController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Enter number of puffs',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                int? newPuffs = int.tryParse(puffsController.text);
                if (newPuffs != null && newPuffs > 0) {
                  vapingController.dailyPuffs.value = newPuffs;
                  vapingController.resetDailyPuffs();
                  Navigator.of(context).pop();
                } else {
                  Get.snackbar(
                      'Invalid Input', 'Please enter a valid number of puffs.');
                }
              },
              child: Text('Set'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Stop Vaping',
          style: TextStyle(
              fontSize: 24.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black54,
      ),
      body: Container(
        color: Colors.black87,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildUserNameView(),
              SizedBox(height: 15.h),
              _buildTimerCountView(),
              const SizedBox(height: 20),
              Obx(() {
                final remainingPuffs = vapingController.remainingPuffs.value;
                return Column(
                  children: [
                    Text(
                      'Puffs Remaining Today: $remainingPuffs',
                      style: TextStyle(
                          fontSize: 25.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    if (remainingPuffs <= 0)
                      Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: ElevatedButton(
                          onPressed: () {
                            showInputDialog();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Set New Puff Goal'),
                        ),
                      ),
                  ],
                );
              }),
              SizedBox(height: 20.h),
              if (_timeRemaining > 0)
                CircularCountDownTimer(
                  duration: _timeRemaining,
                  initialDuration: 0,
                  controller: CountDownController(),
                  width: MediaQuery.of(context).size.width / 2,
                  height: 200.h,
                  ringColor: Colors.grey[800]!,
                  fillColor: Colors.redAccent,
                  backgroundColor: Colors.black54,
                  strokeWidth: 10.0,
                  strokeCap: StrokeCap.round,
                  textStyle: const TextStyle(
                    fontSize: 33.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  isReverse: true,
                  isTimerTextShown: true,
                  autoStart: true,
                )
              else
                InkWell(
                  onTap: () {
                    if (vapingController.remainingPuffs.value > 0) {
                      vapingController.logPuff();

                      if (vapingController.remainingPuffs.value <= 0) {
                        // Show dialog to set new goal
                        showInputDialog();
                      } else if (vapingController.remainingPuffs.value % 10 ==
                          0) {
                        startTimer();
                      }
                    }
                  },
                  child: Container(
                    height: 30.h,
                    width: 130.w,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.green,
                        ),
                        borderRadius: BorderRadius.circular(100.r)),
                    child: Center(
                      child: Text(
                        'Log a Puff',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 20.h),
              InkWell(
                onTap: () => Get.to(() => CravingSupportScreen()),
                child: Container(
                  height: 30.h,
                  width: 130.w,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green,
                      ),
                      borderRadius: BorderRadius.circular(100.r)),
                  child: Center(
                    child: Text(
                      'I\'m Craving',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              _buildSetGoalView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimerCountView() {
    return Column(
      children: [
        Text(
          'Time Spent Without Vaping',
          style: TextStyle(
            fontSize: 25.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15.h),
        Obx(() {
          return TimeSpentDisplay(
            timeSpentInSeconds: vapingController.timeSpentVaping.value,
          );
        }),
      ],
    );
  }

  Widget _buildUserNameView() {
    return Obx(() => Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Hello, ${vapingController.name.value} 👋',
            style: TextStyle(
              fontSize: 22.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
  }

  Widget _buildSetGoalView() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set Your target',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  'To complete next phase',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20.h),
                InkWell(
                  onTap: () {
                    Get.to(() => CompletePhaseScreen());
                  },
                  child: Container(
                    height: 30.h,
                    width: 130.w,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.green,
                        ),
                        borderRadius: BorderRadius.circular(100.r)),
                    child: Center(
                      child: Text(
                        'Complete Phase',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Image.asset(
              'assets/images/stop.png',
              height: 150.h,
              width: 170.w,
            ),
          ),
        ],
      ),
    );
  }
}
