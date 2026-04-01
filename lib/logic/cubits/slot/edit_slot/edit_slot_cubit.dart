import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/logic/cubits/slot/edit_slot/edit_slot_state.dart';

class EditSlotCubit extends Cubit<EditSlotState> {
  EditSlotCubit({required TimeOfDay initialStart, required TimeOfDay initialEnd})
      : super(EditSlotState(startTime: initialStart, endTime: initialEnd));

  void updateStartTime(TimeOfDay time) => emit(state.copyWith(startTime: time));
  void updateEndTime(TimeOfDay time) => emit(state.copyWith(endTime: time));
}