import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_vapping/controller/vapping_controller.dart';
import 'package:stop_vapping/screens/mainScreen.dart';
import 'home_screen.dart';

class InputScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final startDateController = TextEditingController();
  final yearsVapingController = TextEditingController();
  final averageCostController = TextEditingController();
  final puffsController = TextEditingController();
  final VapingController vapingController = Get.find();
  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black87,
        padding: EdgeInsets.all(16.0.sp),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50.h),
                    Text(
                      'Welcome ',
                      style: TextStyle(
                        fontSize: 23.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'To continue Enter Your Info',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    _buildTextField(
                      nameController,
                      'Your Name',
                      const Icon(Icons.person_outlined),
                    ),
                    SizedBox(height: 20.h),
                    _buildDropdownField(
                      vapingController,
                      'Gender',
                      const Icon(Icons.person),
                    ),
                    SizedBox(height: 20.h),
                    _buildDatePickerField(
                      context,
                      startDateController,
                      'Starting Date',
                    ),
                    SizedBox(height: 20.h),
                    _buildTextField(
                      yearsVapingController,
                      'Years of Vaping',
                      const Icon(Icons.vape_free_outlined),
                      isNumber: true,
                    ),
                    SizedBox(height: 20.h),
                    _buildTextField(
                      averageCostController,
                      'Average Cost',
                      const Icon(Icons.price_change),
                      isNumber: true,
                    ),
                    SizedBox(height: 20.h),
                    _buildTextField(
                      puffsController,
                      'Daily Puff Limit',
                      const Icon(Icons.numbers),
                      isNumber: true,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: MediaQuery.of(context).size.width - 50.w,
              child: ElevatedButton(
                onPressed: () async {
                  vapingController.name.value = nameController.text;
                  vapingController.startDate.value = startDateController.text;
                  vapingController.yearsVaping.value =
                      int.parse(yearsVapingController.text);
                  vapingController.averageCost.value =
                      double.parse(averageCostController.text);
                  vapingController.dailyPuffs.value =
                      int.parse(puffsController.text);
                  vapingController.remainingPuffs.value =
                      vapingController.dailyPuffs.value;
                  vapingController.saveUserData();
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool('hasCompletedInput', true);

                  Get.off(() => MainScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Submit'),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    Icon preffixIcon, {
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: preffixIcon,
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
      ),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildDropdownField(
    VapingController controller,
    String label,
    Icon preffixIcon,
  ) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        prefixIcon: preffixIcon,
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
      ),
      style: const TextStyle(color: Colors.white),
      dropdownColor: Colors.black87,
      value: controller.gender.value,
      onChanged: (String? newValue) {
        controller.gender.value = newValue ?? 'Male'; // Default to 'Male'
      },
      items: genderOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildDatePickerField(
    BuildContext context,
    TextEditingController controller,
    String label,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.calendar_month_outlined,
          color: Colors.white,
        ),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
      ),
      style: const TextStyle(color: Colors.white),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          controller.text = formattedDate;
        }
      },
    );
  }
}
