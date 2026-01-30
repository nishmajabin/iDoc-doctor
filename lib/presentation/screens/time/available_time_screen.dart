import 'package:flutter/material.dart';

class AvailableTimeScreen extends StatelessWidget {
  const AvailableTimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Time'),
      ),
      body: const Center(
        child: Text('Available Time Screen Content'),
      ),
    );
  }
}