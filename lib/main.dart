import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stop_vapping/controller/vapping_controller.dart';
import 'package:stop_vapping/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final hasCompletedInput = prefs.getBool('hasCompletedInput') ?? false;

  runApp(MyApp(hasCompletedInput: hasCompletedInput));
}

class MyApp extends StatelessWidget {
  final bool hasCompletedInput;

  MyApp({required this.hasCompletedInput});

  @override
  Widget build(BuildContext context) {
    Get.put(VapingController());

    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Stop Vaping',
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.black87,
          scaffoldBackgroundColor: Colors.black87,
        ),
        home: SplashScreen(hasCompletedInput: hasCompletedInput),
      ),
    );
  }
}
