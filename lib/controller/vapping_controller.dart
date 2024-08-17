import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tip_model.dart';

class VapingController extends GetxController {
  var name = ''.obs;
  var gender = 'Male'.obs;
  var startDate = ''.obs;
  var yearsVaping = 0.obs;
  var averageCost = 0.0.obs;
  var dailyPuffs = 0.obs;
  var remainingPuffs = 0.obs;
  var currentPhase = 1.obs;
  var weeklyPuffData = <int>[].obs;
  var vapingStartTime = Rxn<DateTime>();
  var timeSpentVaping = 0.obs;
  var lastVapeTime = Rxn<DateTime>();
  var timeSpentWithoutVaping = 0.obs;

  // Tips, MCQs, and YouTube videos
  final List<TipModel> tips = [
    TipModel(
        type: 'tip', content: 'Drink water when you feel the urge to vape.'),
    TipModel(type: 'youtube', content: 'https://www.youtube.com/watch?v=abcde'),
    TipModel(type: 'mcq', content: 'What are the benefits of quitting vaping?')
  ];

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    startTracking();
  }

  void startTracking() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (vapingStartTime.value != null) {
        timeSpentVaping.value =
            DateTime.now().difference(vapingStartTime.value!).inSeconds;
      }

      if (lastVapeTime.value != null) {
        timeSpentWithoutVaping.value =
            DateTime.now().difference(lastVapeTime.value!).inSeconds;
      }
    });
  }

  void logPuff() {
    if (remainingPuffs.value > 0) {
      remainingPuffs.value--;
      vapingStartTime.value = DateTime.now();
      saveUserData();
    }
  }

  void stopVaping() {
    lastVapeTime.value = DateTime.now();
    saveUserData();
  }

  void loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    timeSpentVaping.value = prefs.getInt('timeSpentVaping') ?? 0;
    timeSpentWithoutVaping.value = prefs.getInt('timeSpentWithoutVaping') ?? 0;
    name.value = prefs.getString('name') ?? '';
    gender.value = prefs.getString('gender') ?? 'Male'; // Load gender
    startDate.value = prefs.getString('startDate') ?? '';
    yearsVaping.value = prefs.getInt('yearsVaping') ?? 0;
    averageCost.value = prefs.getDouble('averageCost') ?? 0.0;
    dailyPuffs.value = prefs.getInt('dailyPuffs') ?? 0;
    remainingPuffs.value = prefs.getInt('remainingPuffs') ?? dailyPuffs.value;
    currentPhase.value = prefs.getInt('currentPhase') ?? 1;
    weeklyPuffData.value = prefs
            .getStringList('weeklyPuffData')
            ?.map((e) => int.parse(e))
            .toList() ??
        List.filled(7, 0);

    // Load and parse the vapingStartTime
    String? vapingStartTimeString = prefs.getString('vapingStartTime');
    if (vapingStartTimeString != null) {
      vapingStartTime.value = DateTime.parse(vapingStartTimeString);
    }

    // Load and parse the lastVapeTime
    String? lastVapeTimeString = prefs.getString('lastVapeTime');
    if (lastVapeTimeString != null) {
      lastVapeTime.value = DateTime.parse(lastVapeTimeString);
    }
  }

  void saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('timeSpentVaping', timeSpentVaping.value);
    await prefs.setInt('timeSpentWithoutVaping', timeSpentWithoutVaping.value);
    await prefs.setString('name', name.value);
    await prefs.setString('gender', gender.value);
    await prefs.setString('startDate', startDate.value);
    await prefs.setInt('yearsVaping', yearsVaping.value);
    await prefs.setDouble('averageCost', averageCost.value);
    await prefs.setInt('dailyPuffs', dailyPuffs.value);
    await prefs.setInt('remainingPuffs', remainingPuffs.value);
    await prefs.setInt('currentPhase', currentPhase.value);
    await prefs.setStringList('weeklyPuffData',
        weeklyPuffData.value.map((e) => e.toString()).toList());

    // Save the vapingStartTime as a string
    if (vapingStartTime.value != null) {
      await prefs.setString(
          'vapingStartTime', vapingStartTime.value!.toIso8601String());
    }

    // Save the lastVapeTime as a string
    if (lastVapeTime.value != null) {
      await prefs.setString(
          'lastVapeTime', lastVapeTime.value!.toIso8601String());
    }
  }

  TipModel getRandomTip() {
    tips.shuffle();
    return tips.first;
  }

  void resetDailyPuffs() {
    remainingPuffs.value = dailyPuffs.value;
    saveUserData();
  }

  void nextPhase() {
    currentPhase.value++;
    saveUserData();
  }
}
