 import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/presentation/screens/home/home_screen.dart';
import 'package:idoc_doctor_side/presentation/screens/notification/notification_screen.dart';
import 'package:idoc_doctor_side/presentation/screens/time/available_time_screen.dart';

  Widget buildBody(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return DoctorHomeScreen();
      case 1:
        return AvailableTimeScreen();
      case 2:
        return NotificationScreen();
      case 3:
        // return AppointmentsScreen();
      default:
        return DoctorHomeScreen();
    }
  }



  // Widget buildNotificationsContent() {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Icon(Icons.notifications_none, size: 80, color: Colors.grey[400]),
  //         const SizedBox(height: 16),
  //         Text(
  //           'Notifications',
  //           style: TextStyle(
  //             fontSize: 24,
  //             fontWeight: FontWeight.w600,
  //             color: Colors.black87,
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         Text(
  //           'No new notifications',
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Colors.grey[600],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // // Profile Tab Content
  // Widget buildProfileContent() {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Icon(Icons.person, size: 80, color: Colors.grey[400]),
  //         const SizedBox(height: 16),
  //         Text(
  //           'Your Profile',
  //           style: TextStyle(
  //             fontSize: 24,
  //             fontWeight: FontWeight.w600,
  //             color: Colors.black87,
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         Text(
  //           'Manage your account settings',
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Colors.grey[600],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }