import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/data/services/prescription_service.dart';
import 'package:idoc_doctor_side/logic/blocs/prescription/prescription_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/prescription/prescription_event.dart';
import 'package:idoc_doctor_side/logic/blocs/prescription/prescription_state.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/prescription/widgets/counter_row.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/prescription/widgets/medication_card.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/prescription/widgets/section_label.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/prescription/widgets/toggle_option_bar.dart';

class PrescriptionScreen extends StatelessWidget {
  final DoctorAppointmentModel appointment;

  const PrescriptionScreen({required this.appointment, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PrescriptionBloc(
        PrescriptionService(FirebaseFirestore.instance),
      ),
      child: _PrescriptionScreenBody(appointment: appointment),
    );
  }
}

class _PrescriptionScreenBody extends StatefulWidget {
  final DoctorAppointmentModel appointment;
  const _PrescriptionScreenBody({required this.appointment});

  @override
  State<_PrescriptionScreenBody> createState() =>
      _PrescriptionScreenBodyState();
}

class _PrescriptionScreenBodyState extends State<_PrescriptionScreenBody> {
  final _medNameController = TextEditingController();
  final _noteController = TextEditingController();

  static const _repeatOptions = ['Everyday', 'Alternate Days', 'Specific Days'];
  static const _timeOptions = ['Morning', 'Noon', 'Evening', 'Night'];
  static const _takenOptions = ['After Food', 'Before Food'];
  static const _unitOptions = ['Day', 'Week', 'Month'];

  @override
  void dispose() {
    _medNameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PrescriptionBloc, PrescriptionState>(
      listener: (context, state) {
        if (state is PrescriptionSubmitSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(children: [
                Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                SizedBox(width: 10),
                Text('Prescription submitted successfully'),
              ]),
              backgroundColor: const Color(0xFF43A047),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
            ),
          );
          Navigator.pop(context);
        }
        if (state is PrescriptionSubmitError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(0xFFE53935),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FC),
        appBar: _buildAppBar(),
        body: BlocBuilder<PrescriptionBloc, PrescriptionState>(
          builder: (context, state) {
            if (state is! PrescriptionFormState) return const SizedBox.shrink();
            return _buildBody(context, state);
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Color(0xFF0D0D0D)),
      title: const Text(
        'New Prescription',
        style: TextStyle(
          color: Color(0xFF0D0D0D),
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: const Color(0xFFEEEEEE)),
      ),
    );
  }

  Widget _buildBody(BuildContext context, PrescriptionFormState state) {
    final bloc = context.read<PrescriptionBloc>();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // ── Patient info chip ────────────────────────────────────────────────
        _PatientChip(name: widget.appointment.patientName),
        const SizedBox(height: 24),

        // ── Medication form card ─────────────────────────────────────────────
        _SectionCard(
          title: 'Medication',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name field
              TextField(
                controller: _medNameController,
                onChanged: (v) => bloc.add(UpdateMedicationName(v)),
                style: const TextStyle(fontSize: 14, color: Color(0xFF0D0D0D)),
                decoration: _inputDecoration('Medication name'),
              ),
              const SizedBox(height: 20),

              // Dosage
              CounterRow(
                label: 'Dosage',
                valueLabel: '${state.dosage} Tablet',
                onIncrement: () => bloc.add(const IncrementDosage()),
                onDecrement: () => bloc.add(const DecrementDosage()),
              ),
              const SizedBox(height: 16),

              // Duration
              CounterRow(
                label: 'Duration',
                valueLabel: '${state.duration} ${state.durationUnit}',
                onIncrement: () => bloc.add(const IncrementDuration()),
                onDecrement: () => bloc.add(const DecrementDuration()),
              ),
              const SizedBox(height: 10),
              // Duration unit selector
              ToggleOptionBar(
                options: _unitOptions,
                selected: state.durationUnit,
                onSelect: (v) => bloc.add(UpdateDurationUnit(v)),
              ),
              const SizedBox(height: 20),

              // Repeat
              const SectionLabel('Repeat'),
              ToggleOptionBar(
                options: _repeatOptions,
                selected: state.repeat,
                onSelect: (v) => bloc.add(UpdateRepeat(v)),
              ),
              const SizedBox(height: 20),

              // Time of day
              const SectionLabel('Time of Day'),
              ToggleOptionBar(
                options: _timeOptions,
                selected: state.timeOfDay,
                onSelect: (v) => bloc.add(UpdateTimeOfDay(v)),
              ),
              const SizedBox(height: 20),

              // To be taken
              const SectionLabel('To be Taken'),
              ToggleOptionBar(
                options: _takenOptions,
                selected: state.beTaken,
                onSelect: (v) => bloc.add(UpdateBeTaken(v)),
              ),
              const SizedBox(height: 24),

              // Add medication button
              GestureDetector(
                onTap: () {
                  bloc.add(const AddMedicationToList());
                  _medNameController.clear();
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00D4FF).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: const Color(0xFF00D4FF).withValues(alpha: 0.4)),
                  ),
                  alignment: Alignment.center,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_circle_outline_rounded,
                          color: Color(0xFF0099CC), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Add Medication',
                        style: TextStyle(
                          color: Color(0xFF0099CC),
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── Added medications list ───────────────────────────────────────────
        if (state.addedMedications.isNotEmpty) ...[
          _SectionCard(
            title: 'Added Medications (${state.addedMedications.length})',
            child: Column(
              children: state.addedMedications.asMap().entries.map((entry) {
                return MedicationCard(
                  med: entry.value,
                  index: entry.key,
                  onRemove: () =>
                      bloc.add(RemoveMedicationFromList(entry.key)),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // ── Doctor's note ────────────────────────────────────────────────────
        _SectionCard(
          title: "Doctor's Note",
          child: TextField(
            controller: _noteController,
            maxLines: 4,
            onChanged: (v) => bloc.add(UpdateDoctorNote(v)),
            style: const TextStyle(fontSize: 14, color: Color(0xFF0D0D0D)),
            decoration: _inputDecoration('Optional notes for the patient...'),
          ),
        ),
        const SizedBox(height: 28),

        // ── Submit button ────────────────────────────────────────────────────
        GestureDetector(
          onTap: state.isSubmitting || state.addedMedications.isEmpty
              ? null
              : () => context.read<PrescriptionBloc>().add(
                    SubmitPrescription(
                      appointmentId: widget.appointment.appointmentId,
                      userId: widget.appointment.userId,
                      patientName: widget.appointment.patientName,
                    ),
                  ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 56,
            decoration: BoxDecoration(
              color: state.addedMedications.isEmpty
                  ? const Color(0xFFBDBDBD)
                  : const Color(0xFF0D0D0D),
              borderRadius: BorderRadius.circular(16),
              boxShadow: state.addedMedications.isEmpty
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            alignment: Alignment.center,
            child: state.isSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Submit Prescription',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle:
            const TextStyle(color: Color(0xFFBDBDBD), fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF7F8FC),
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: Color(0xFF00D4FF), width: 1.5),
        ),
      );
}

// ── Reusable sub-widgets ─────────────────────────────────────────────────────

class _PatientChip extends StatelessWidget {
  final String name;
  const _PatientChip({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00D4FF), Color(0xFF0099CC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'P',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Patient',
                  style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9E9E9E),
                      fontWeight: FontWeight.w500)),
              Text(name,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0D0D0D),
                      letterSpacing: -0.2)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0D0D0D),
                letterSpacing: -0.2,
              )),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}