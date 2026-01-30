import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_event.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_state.dart';

class DoctorAppointmentsScreen extends StatefulWidget {
  final String doctorId;
  const DoctorAppointmentsScreen({super.key, required this.doctorId});

  @override
  State<DoctorAppointmentsScreen> createState() =>
      _DoctorAppointmentsScreenState();
}

class _DoctorAppointmentsScreenState
    extends State<DoctorAppointmentsScreen> {
  bool upcoming = true;

  @override
  void initState() {
    super.initState();
    context
        .read<DoctorAppointmentBloc>()
        .add(FetchDoctorAppointments(widget.doctorId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Appointments',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          _tabBar(),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<
                DoctorAppointmentBloc,
                DoctorAppointmentState>(
              builder: (_, state) {
                if (state is DoctorAppointmentLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is DoctorAppointmentLoaded) {
                  final list =
                      upcoming ? state.upcoming : state.past;

                  if (list.isEmpty) {
                    return const Center(
                      child: Text('No appointments'),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16),
                    itemCount: list.length,
                    itemBuilder: (_, i) =>
                        _appointmentCard(list[i]),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================= TAB BAR =================

  Widget _tabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _tabButton('Upcoming', true),
          _tabButton('Past', false),
        ],
      ),
    );
  }

  Widget _tabButton(String text, bool value) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => upcoming = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: upcoming == value
                ? Colors.black
                : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: upcoming == value
                  ? Colors.lightBlueAccent
                  : Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // ================= CARD =================

  Widget _appointmentCard(dynamic a) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFB3E9FF),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: a.profileImageUrl != null
                    ? NetworkImage(a.profileImageUrl)
                    : null,
                backgroundColor: Colors.grey.shade300,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      a.patientName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'heart patient',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chat_bubble_outline),
            ],
          ),

          const SizedBox(height: 14),

          // Bottom section
          upcoming
              ? _timePill(a.startTime)
              : _pastButtons(a),
        ],
      ),
    );
  }

  // ================= UPCOMING =================

  Widget _timePill(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.access_time,
              color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ================= PAST =================

  Widget _pastButtons(dynamic a) {
    return Row(
      children: [
        _actionButton(
          text: 'COMPLETED',
          onTap: () {
            context
                .read<DoctorAppointmentBloc>()
                .add(
                  MarkAppointmentCompleted(
                      a.appointmentId),
                );
          },
        ),
        const SizedBox(width: 12),
        _actionButton(
          text: 'ADD PRISCRIPTION',
          onTap: () {
       
          },
        ),
      ],
    );
  }

  Widget _actionButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding:
              const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
