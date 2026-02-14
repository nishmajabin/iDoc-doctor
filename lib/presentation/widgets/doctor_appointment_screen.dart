import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/constants/color.dart';
import 'package:idoc_doctor_side/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/data/services/appointment_service.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_event.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_state.dart';
import 'package:idoc_doctor_side/logic/blocs/auth/auth_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/auth/auth_state.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class DoctorAppointmentsScreen extends StatelessWidget {
  const DoctorAppointmentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authState = context.read<DoctorAuthBloc>().state;

    if (authState is! DoctorAuthSuccess) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Appointments'), centerTitle: true),
        body: Center(
          child: Text(
            'Please login to view appointments',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ),
      );
    }

    final doctorId = authState.doctor.id;
    if (doctorId == null || doctorId.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Appointments'), centerTitle: true),
        body: Center(
          child: Text(
            'Doctor ID not found',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ),
      );
    }

    return BlocProvider(
      create:
          (context) => DoctorAppointmentBloc(
            DoctorAppointmentService(FirebaseFirestore.instance),
          )..add(FetchDoctorAppointments(doctorId)),
      child: const _DoctorAppointmentsContent(),
    );
  }
}

class _DoctorAppointmentsContent extends StatefulWidget {
  const _DoctorAppointmentsContent();

  @override
  State<_DoctorAppointmentsContent> createState() =>
      _DoctorAppointmentsContentState();
}

class _DoctorAppointmentsContentState
    extends State<_DoctorAppointmentsContent> {
  bool _isUpcomingSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Appointments',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocConsumer<DoctorAppointmentBloc, DoctorAppointmentState>(
        listener: (context, state) {
          if (state is DoctorAppointmentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is DoctorAppointmentLoading) {
            return Column(
              children: [
                const SizedBox(height: 20),
                _buildSegmentedControl(),
                const SizedBox(height: 20),
                Expanded(child: _buildShimmerLoading()),
              ],
            );
          }

          if (state is DoctorAppointmentLoaded) {
            return Column(
              children: [
                const SizedBox(height: 20),
                _buildSegmentedControl(),
                const SizedBox(height: 20),
                Expanded(
                  child:
                      _isUpcomingSelected
                          ? _buildAppointmentsList(
                            state.upcoming,
                            isUpcoming: true,
                          )
                          : _buildAppointmentsList(
                            state.past,
                            isUpcoming: false,
                          ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isUpcomingSelected = true),
              child: Container(
                decoration: BoxDecoration(
                  color:
                      _isUpcomingSelected ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Upcoming',
                  style: TextStyle(
                    color:
                        _isUpcomingSelected
                            ? const Color(0xFF00D4FF)
                            : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isUpcomingSelected = false),
              child: Container(
                decoration: BoxDecoration(
                  color:
                      !_isUpcomingSelected ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Past',
                  style: TextStyle(
                    color:
                        !_isUpcomingSelected
                            ? const Color(0xFF00D4FF)
                            : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 6, // Show 6 shimmer cards
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.shimmerColor,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                // Shimmer profile circle
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),

                // Shimmer text lines
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 120,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: 100,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ],
                  ),
                ),

                // Shimmer icon button
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.person),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppointmentsList(
    List<DoctorAppointmentModel> appointments, {
    required bool isUpcoming,
  }) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUpcoming ? Icons.event_available : Icons.history,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              isUpcoming ? 'No upcoming appointments' : 'No past appointments',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    // Group appointments by date
    final groupedAppointments = _groupAppointmentsByDate(appointments);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: groupedAppointments.length,
      itemBuilder: (context, index) {
        final entry = groupedAppointments.entries.elementAt(index);
        final date = entry.key;
        final dayAppointments = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 12, top: 8),
              child: Text(
                DateFormat('dd MMM, yyyy').format(date),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),

            // Appointments for this date
            ...dayAppointments.map(
              (appointment) => _AppointmentCard(
                appointment: appointment,
                isUpcoming: isUpcoming,
              ),
            ),
          ],
        );
      },
    );
  }

  Map<DateTime, List<DoctorAppointmentModel>> _groupAppointmentsByDate(
    List<DoctorAppointmentModel> appointments,
  ) {
    final Map<DateTime, List<DoctorAppointmentModel>> grouped = {};

    for (final appointment in appointments) {
      final date = DateTime(
        appointment.appointmentDate.year,
        appointment.appointmentDate.month,
        appointment.appointmentDate.day,
      );

      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(appointment);
    }

    // Sort appointments within each date by start time
    for (final appointments in grouped.values) {
      appointments.sort((a, b) => a.startTime.compareTo(b.startTime));
    }

    return grouped;
  }
}

class _AppointmentCard extends StatelessWidget {
  final DoctorAppointmentModel appointment;
  final bool isUpcoming;

  const _AppointmentCard({required this.appointment, required this.isUpcoming});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.appointmentCardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Profile image
          _buildProfileImage(),
          const SizedBox(width: 40),

          // Patient info and action buttons
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  appointment.patientName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

                // Show time for upcoming, buttons for past
                isUpcoming ? _buildTimeBadge() : _buildActionButtons(context),
                const SizedBox(height: 8),
              ],
            ),
          ),

          // Message icon
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 65,
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        image:
            appointment.profileImageUrl != null &&
                    appointment.profileImageUrl!.isNotEmpty
                ? DecorationImage(
                  image: NetworkImage(appointment.profileImageUrl!),
                  fit: BoxFit.cover,
                )
                : null,
      ),
      child:
          appointment.profileImageUrl == null ||
                  appointment.profileImageUrl!.isEmpty
              ? Center(
                child: Text(
                  appointment.patientName.isNotEmpty
                      ? appointment.patientName[0].toUpperCase()
                      : 'P',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9FE2FF),
                  ),
                ),
              )
              : null,
    );
  }

  Widget _buildTimeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.access_time, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(
            appointment.startTime,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'COMPLETED',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: GestureDetector(
            onTap: () => _showAddPrescriptionDialog(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'ADD PRESCRIPTION',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddPrescriptionDialog(BuildContext context) {
    final TextEditingController prescriptionController = TextEditingController(
      text: appointment.prescription ?? '',
    );

    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Add Prescription',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Patient: ${appointment.patientName}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: prescriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Enter prescription details...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (prescriptionController.text.trim().isNotEmpty) {
                    context.read<DoctorAppointmentBloc>().add(
                      AddPrescriptionEvent(
                        appointmentId: appointment.appointmentId,
                        prescription: prescriptionController.text.trim(),
                      ),
                    );
                    Navigator.pop(dialogContext);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Prescription added successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00D4FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }
}
