import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/data/services/slot_service.dart';
import 'package:idoc_doctor_side/logic/blocs/auth/auth_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/auth/auth_state.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_event.dart';

import 'widgets/view_slots_page_content.dart';

class ViewSlotsPage extends StatelessWidget {
  const ViewSlotsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<DoctorAuthBloc>().state;

    if (authState is! DoctorAuthSuccess) {
      return _buildErrorScaffold(
        'Please login to view slots',
        Icons.lock_outline,
        Colors.grey,
        '',
      );
    }

    final doctorId = authState.doctor.id;
    if (doctorId == null || doctorId.isEmpty) {
      return _buildErrorScaffold(
        'Doctor ID not found',
        Icons.error_outline,
        Colors.red[400],
        'Please contact support',
      );
    }

    return BlocProvider(
      create:
          (context) => SlotBloc(
            slotService: SlotService(FirebaseFirestore.instance),
            doctorId: doctorId,
          )..add(
            FetchSlotsByDateRangeEvent(
              startDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
              endDate: DateTime(
                DateTime.now().year,
                DateTime.now().month + 1,
                0,
              ),
            ),
          ),
      child: const ViewSlotsPageContent(),
    );
  }

  Widget _buildErrorScaffold(
    String message,
    IconData icon,
    Color? iconColor,
    String? subtitle,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointment Slots'),
        centerTitle: true,
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
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
