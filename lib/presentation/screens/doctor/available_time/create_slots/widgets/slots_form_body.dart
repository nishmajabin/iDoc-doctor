import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_state.dart';
import 'package:idoc_doctor_side/logic/blocs/slot_form/slot_form_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/slot_form/slot_form_event.dart';
import 'package:idoc_doctor_side/logic/blocs/slot_form/slot_form_state.dart';
import 'package:idoc_doctor_side/presentation/screens/doctor/available_time/create_slots/widgets/break_time_selector.dart';
import 'package:idoc_doctor_side/presentation/screens/doctor/available_time/create_slots/widgets/date_range_info.dart';
import 'package:idoc_doctor_side/presentation/screens/doctor/available_time/create_slots/widgets/interval_selector.dart';
import 'package:idoc_doctor_side/presentation/screens/doctor/available_time/create_slots/widgets/schedule_button.dart';
import 'package:idoc_doctor_side/presentation/screens/doctor/available_time/create_slots/widgets/slot_calendar.dart';
import 'package:idoc_doctor_side/presentation/screens/doctor/available_time/create_slots/widgets/slot_creation_helper.dart';
import 'package:idoc_doctor_side/presentation/screens/doctor/available_time/create_slots/widgets/time_selector_widget.dart';

class SlotsFormBody extends StatelessWidget {
  const SlotsFormBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SlotFormBloc, SlotFormState>(
      builder: (context, formState) {
        return SingleChildScrollView(
          child: Column(
            children: [
              SlotCalendarWidget(
                focusedDay: formState.focusedDay,
                rangeStart: formState.rangeStart,
                rangeEnd: formState.rangeEnd,
                slotsCache: formState.slotsCache,
                onDaySelected: (selectedDay, focusedDay) {
                  context.read<SlotFormBloc>().add(
                        SelectDay(selectedDay, focusedDay),
                      );
                },
                onPageChanged: (focusedDay) {
                  context.read<SlotFormBloc>().add(UpdatedFocusedDay(focusedDay));
                  SlotCreationHelper.fetchSlotsForMonth(
                    context.read<SlotBloc>(),
                    focusedDay,
                  );
                },
                normalizeDate: (date) => DateTime(date.year, date.month, date.day),
              ),
              const SizedBox(height: 16),
              DateRangeInfoWidget(
                rangeStart: formState.rangeStart,
                rangeEnd: formState.rangeEnd,
                hasExistingSlots: formState.rangeStart != null
                    ? formState.checkExistingSlotsInRange(
                        formState.rangeStart!,
                        formState.rangeEnd ?? formState.rangeStart!,
                      )
                    : false,
                onClear: () {
                  context.read<SlotFormBloc>().add(ClearDateRange());
                },
              ),
              const SizedBox(height: 16),
              TimeSelectorWidget(
                startTime: formState.startTime,
                endTime: formState.endTime,
                onSelectTime: ({required bool isStart}) async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: (isStart ? formState.startTime : formState.endTime) ??
                        TimeOfDay.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color(0xFF00D4FF),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (picked != null && context.mounted) {
                    if (isStart) {
                      context.read<SlotFormBloc>().add(UpdateStartTime(picked));
                    } else {
                      context.read<SlotFormBloc>().add(UpdateEndTime(picked));
                    }
                  }
                },
              ),
              const SizedBox(height: 16),
              IntervalSelectorWidget(
                selectedInterval: formState.selectedInterval,
                onIntervalChanged: (interval) {
                  context.read<SlotFormBloc>().add(UpdateInterval(interval));
                },
              ),
              const SizedBox(height: 16),
              BreakTimeSelectorWidget(
                selectedBreakTime: formState.selectedBreakTime,
                onBreakTimeChanged: (breakTime) {
                  context.read<SlotFormBloc>().add(UpdateBreakTime(breakTime));
                },
              ),
              const SizedBox(height: 24),
              BlocBuilder<SlotBloc, SlotState>(
                builder: (context, slotState) {
                  return ScheduleButtonWidget(
                    state: slotState,
                    rangeStart: formState.rangeStart,
                    rangeEnd: formState.rangeEnd,
                    startTime: formState.startTime,
                    endTime: formState.endTime,
                    hasExistingSlots: formState.rangeStart != null
                        ? formState.checkExistingSlotsInRange(
                            formState.rangeStart!,
                            formState.rangeEnd ?? formState.rangeStart!,
                          )
                        : false,
                    onCreateSlots: () {
                      SlotCreationHelper.createSlots(
                        context: context,
                        slotBloc: context.read<SlotBloc>(),
                        rangeStart: formState.rangeStart,
                        rangeEnd: formState.rangeEnd,
                        startTime: formState.startTime,
                        endTime: formState.endTime,
                        selectedInterval: formState.selectedInterval,
                        selectedBreakTime: formState.selectedBreakTime,
                        checkExistingSlots: formState.checkExistingSlotsInRange,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}