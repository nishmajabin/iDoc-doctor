import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/data/services/slot_service.dart';
import 'package:idoc_doctor_side/logic/blocs/auth/auth_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/auth/auth_state.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_event.dart';
import 'package:idoc_doctor_side/logic/blocs/slot_form/slot_form_bloc.dart';
import 'package:idoc_doctor_side/presentation/screens/doctor/available_time/create_slots/widgets/create_slots_content.dart';
import 'package:idoc_doctor_side/presentation/screens/doctor/available_time/create_slots/widgets/error_scaffold.dart';
import 'package:idoc_doctor_side/presentation/screens/doctor/available_time/create_slots/widgets/slot_creation_helper.dart';

class CreateSlotsPage extends StatelessWidget {
  const CreateSlotsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<DoctorAuthBloc>().state;
    
    if (authState is! DoctorAuthSuccess) {
      return ErrorScaffold(
        title: 'Available Times',
        icon: Icons.lock_outline,
        message: 'Please login to create slots',
        iconColor: Colors.grey[400],
      );
    }

    final doctorId = authState.doctor.id;
    if (doctorId == null || doctorId.isEmpty) {
      return ErrorScaffold(
        title: 'Available Times',
        icon: Icons.error_outline,
        message: 'Doctor ID not found',
        iconColor: Colors.red[400],
        showNotesButton: true,
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SlotBloc(
            slotService: SlotService(FirebaseFirestore.instance),
            doctorId: doctorId,
          )..add(FetchSlotsByDateRangeEvent(
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 90)),
          )),
        ),
        BlocProvider(
          create: (context) {
            final bloc = SlotFormBloc();
            // Fetch initial slots when form is initialized
            SlotCreationHelper.fetchSlotsForMonth(
              context.read<SlotBloc>(),
              DateTime.now(),
            );
            return bloc;
          },
        ),
      ],
      child: const CreateSlotsContent(),
    );
  }
}