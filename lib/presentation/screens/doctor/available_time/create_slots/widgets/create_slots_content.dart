import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_state.dart';
import 'package:idoc_doctor_side/logic/blocs/slot_form/slot_form_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/slot_form/slot_form_event.dart';
import 'package:idoc_doctor_side/presentation/screens/doctor/available_time/create_slots/widgets/slot_creation_helper.dart';
import 'package:idoc_doctor_side/presentation/screens/doctor/available_time/create_slots/widgets/slots_form_body.dart';
import 'package:idoc_doctor_side/presentation/screens/doctor/available_time/slots_view/slots_view_screen.dart';

class CreateSlotsContent extends StatelessWidget {
  const CreateSlotsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Available Times'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notes),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ViewSlotsPage()),
            ),
          )
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: BlocListener<SlotBloc, SlotState>(
        listener: (context, state) {
          if (state is SlotsFetchedSuccess) {
            context.read<SlotFormBloc>().add(UpdateSlotsCache(state.slots));
          } else if (state is SlotsCreatedSuccess) {
            SlotCreationHelper.showSuccessSnackbar(context, state.slots.length);
            context.read<SlotFormBloc>().add(ClearDateRange());
            final formState = context.read<SlotFormBloc>().state;
            SlotCreationHelper.fetchSlotsForMonth(
              context.read<SlotBloc>(),
              formState.focusedDay,
            );
          } else if (state is SlotError) {
            SlotCreationHelper.showErrorSnackbar(context, state.message);
          }
        },
        child: const SlotsFormBody(),
      ),
    );
  }
}