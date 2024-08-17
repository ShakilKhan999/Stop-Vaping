import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_vapping/main.dart';
import 'package:stop_vapping/screens/mainScreen.dart';
import 'home_screen.dart';
import 'input_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool hasCompletedInput;

  SplashScreen({required this.hasCompletedInput});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));

    if (widget.hasCompletedInput) {
      Get.off(() => MainScreen());
    } else {
      Get.off(() => InputScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 150.h,
              width: 150.w,
            ),
            SizedBox(
              height: 15.h,
            ),
            const Text('The goal is Stop smoking'),
            SizedBox(
              height: 15.h,
            ),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
