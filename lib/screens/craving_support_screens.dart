import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stop_vapping/controller/vapping_controller.dart';
import 'package:stop_vapping/models/tip_model.dart';
import 'package:url_launcher/url_launcher.dart';

class CravingSupportScreen extends StatelessWidget {
  final VapingController vapingController = Get.find();

  @override
  Widget build(BuildContext context) {
    final TipModel tip = vapingController.getRandomTip();

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text(
          'Craving Support',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black45,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (tip.type == 'mcq')
              Text(tip.content,
                  style: const TextStyle(fontSize: 18, color: Colors.white)),
            if (tip.type == 'tip')
              Text(tip.content,
                  style: const TextStyle(fontSize: 18, color: Colors.white)),
            if (tip.type == 'youtube')
              InkWell(
                onTap: () async {
                  if (await canLaunch(tip.content)) {
                    await launch(tip.content);
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
                  child: const Center(
                    child: Text('Watch Video',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
