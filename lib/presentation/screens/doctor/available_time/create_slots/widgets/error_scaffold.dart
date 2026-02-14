import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/presentation/screens/doctor/available_time/slots_view/slots_view_screen.dart';

class ErrorScaffold extends StatelessWidget {
  final String title;
  final IconData icon;
  final String message;
  final Color? iconColor;
  final bool showNotesButton;

  const ErrorScaffold({
    super.key,
    required this.title,
    required this.icon,
    required this.message,
    this.iconColor,
    this.showNotesButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(title),
        centerTitle: true,
        actions: showNotesButton
            ? [
                IconButton(
                  icon: const Icon(Icons.notes),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ViewSlotsPage(),
                    ),
                  ),
                ),
              ]
            : null,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: iconColor),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}