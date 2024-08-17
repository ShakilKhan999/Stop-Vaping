import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stop_vapping/controller/vapping_controller.dart';

class ProfileScreen extends StatelessWidget {
  final VapingController vapingController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.black54,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Profile Picture with Rounded Border
            Center(
              child: Container(
                width: 100, // Size of the profile picture
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.white, width: 4), // Border color and width
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/profile_picture.png'), // Replace with your image path or use a network image
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildProfileField(
              icon: Icons.person,
              label: 'Name',
              value: vapingController.name.value,
            ),
            _buildProfileField(
              icon: Icons.person_outline,
              label: 'Gender',
              value: vapingController.gender.value,
            ),
            _buildProfileField(
              icon: Icons.calendar_today,
              label: 'Starting Date',
              value: vapingController.startDate.value,
            ),
            _buildProfileField(
              icon: Icons.timelapse,
              label: 'Years of Vaping',
              value: vapingController.yearsVaping.value.toString(),
            ),
            _buildProfileField(
              icon: Icons.money,
              label: 'Average Cost',
              value:
                  '\$${vapingController.averageCost.value.toStringAsFixed(2)}',
            ),
            _buildProfileField(
              icon: Icons.alarm,
              label: 'Daily Puff Limit',
              value: vapingController.dailyPuffs.value.toString(),
            ),
            _buildProfileField(
              icon: Icons.notifications,
              label: 'Remaining Puffs',
              value: vapingController.remainingPuffs.value.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        enabled: false, // Make the TextField read-only
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black54),
          ),
          disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        controller: TextEditingController(text: value),
      ),
    );
  }
}
