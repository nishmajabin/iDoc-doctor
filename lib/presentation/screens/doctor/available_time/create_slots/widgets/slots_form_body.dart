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
        final hasExistingSlots = formState.rangeStart != null
            ? formState.checkExistingSlotsInRange(
                formState.rangeStart!,
                formState.rangeEnd ?? formState.rangeStart!,
              )
            : false;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Step 1: Select Dates ────────────────────────────────
              _buildStepHeader(
                step: 1,
                icon: Icons.calendar_today_rounded,
                title: 'Select Date Range',
                subtitle: 'Choose the days you\'ll be available',
              ),
              SlotCalendarWidget(
                focusedDay: formState.focusedDay,
                rangeStart: formState.rangeStart,
                rangeEnd: formState.rangeEnd,
                slotsCache: formState.slotsCache,
                onDaySelected: (selectedDay, focusedDay) {
                  context
                      .read<SlotFormBloc>()
                      .add(SelectDay(selectedDay, focusedDay));
                },
                onPageChanged: (focusedDay) {
                  context
                      .read<SlotFormBloc>()
                      .add(UpdatedFocusedDay(focusedDay));
                  SlotCreationHelper.fetchSlotsForMonth(
                    context.read<SlotBloc>(),
                    focusedDay,
                  );
                },
                normalizeDate: (date) =>
                    DateTime(date.year, date.month, date.day),
              ),

              // ── Date range info / error ─────────────────────────────
              if (formState.rangeStart != null) ...[
                const SizedBox(height: 12),
                DateRangeInfoWidget(
                  rangeStart: formState.rangeStart,
                  rangeEnd: formState.rangeEnd,
                  hasExistingSlots: hasExistingSlots,
                  onClear: () =>
                      context.read<SlotFormBloc>().add(ClearDateRange()),
                ),
              ],

              const SizedBox(height: 24),
              const _SectionDivider(),
              const SizedBox(height: 24),

              // ── Step 2: Set Hours ───────────────────────────────────
              _buildStepHeader(
                step: 2,
                icon: Icons.schedule_rounded,
                title: 'Working Hours',
                subtitle: 'Set your start and end time for these days',
              ),
              TimeSelectorWidget(
                startTime: formState.startTime,
                endTime: formState.endTime,
                onSelectTime: ({required bool isStart}) async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: (isStart
                            ? formState.startTime
                            : formState.endTime) ??
                        TimeOfDay.now(),
                    builder: (context, child) => Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Color(0xFF0077B6),
                          onPrimary: Colors.white,
                          surface: Colors.white,
                        ),
                        timePickerTheme: TimePickerThemeData(
                          backgroundColor: Colors.white,
                          hourMinuteShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          dayPeriodShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      child: child!,
                    ),
                  );
                  if (picked != null && context.mounted) {
                    if (isStart) {
                      context
                          .read<SlotFormBloc>()
                          .add(UpdateStartTime(picked));
                    } else {
                      context.read<SlotFormBloc>().add(UpdateEndTime(picked));
                    }
                  }
                },
              ),

              const SizedBox(height: 24),
              const _SectionDivider(),
              const SizedBox(height: 24),

              // ── Step 3: Slot Settings ────────────────────────────────
              _buildStepHeader(
                step: 3,
                icon: Icons.tune_rounded,
                title: 'Slot Settings',
                subtitle: 'Configure duration and break between appointments',
              ),
              IntervalSelectorWidget(
                selectedInterval: formState.selectedInterval,
                onIntervalChanged: (interval) {
                  context
                      .read<SlotFormBloc>()
                      .add(UpdateInterval(interval));
                },
              ),
              const SizedBox(height: 20),
              BreakTimeSelectorWidget(
                selectedBreakTime: formState.selectedBreakTime,
                onBreakTimeChanged: (breakTime) {
                  context
                      .read<SlotFormBloc>()
                      .add(UpdateBreakTime(breakTime));
                },
              ),

              // ── Slot count preview ──────────────────────────────────
              if (formState.rangeStart != null &&
                  formState.startTime != null &&
                  formState.endTime != null)
                _SlotCountPreview(formState: formState),

              const SizedBox(height: 28),
              const _SectionDivider(),
              const SizedBox(height: 24),

              // ── Step 4: Create ──────────────────────────────────────
              _buildStepHeader(
                step: 4,
                icon: Icons.rocket_launch_rounded,
                title: 'Create Slots',
                subtitle: 'Review and confirm your schedule',
              ),
              BlocBuilder<SlotBloc, SlotState>(
                builder: (context, slotState) => ScheduleButtonWidget(
                  state: slotState,
                  rangeStart: formState.rangeStart,
                  rangeEnd: formState.rangeEnd,
                  startTime: formState.startTime,
                  endTime: formState.endTime,
                  hasExistingSlots: hasExistingSlots,
                  onCreateSlots: () => SlotCreationHelper.createSlots(
                    context: context,
                    slotBloc: context.read<SlotBloc>(),
                    rangeStart: formState.rangeStart,
                    rangeEnd: formState.rangeEnd,
                    startTime: formState.startTime,
                    endTime: formState.endTime,
                    selectedInterval: formState.selectedInterval,
                    selectedBreakTime: formState.selectedBreakTime,
                    checkExistingSlots: formState.checkExistingSlotsInRange,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStepHeader({
    required int step,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF052C40), Color(0xFF0077B6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F4FF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Step $step',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0077B6),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A2332),
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7A91),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    const Color(0xFFDDE8F0),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF00B4D8),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    const Color(0xFFDDE8F0),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shows a live preview of how many slots will be generated
class _SlotCountPreview extends StatelessWidget {
  final SlotFormState formState;

  const _SlotCountPreview({required this.formState});

  int _calculateSlotCount() {
    if (formState.startTime == null || formState.endTime == null) return 0;
    final startMin =
        formState.startTime!.hour * 60 + formState.startTime!.minute;
    final endMin = formState.endTime!.hour * 60 + formState.endTime!.minute;
    if (endMin <= startMin) return 0;
    final duration = endMin - startMin;
    final slotSize =
        formState.selectedInterval + formState.selectedBreakTime;
    if (slotSize <= 0) return 0;
    final slotsPerDay = duration ~/ slotSize;

    final endDate = formState.rangeEnd ?? formState.rangeStart!;
    final dayCount =
        endDate.difference(formState.rangeStart!).inDays + 1;
    return slotsPerDay * dayCount;
  }

  @override
  Widget build(BuildContext context) {
    final count = _calculateSlotCount();
    final endDate = formState.rangeEnd ?? formState.rangeStart!;
    final dayCount =
        endDate.difference(formState.rangeStart!).inDays + 1;
    final slotsPerDay = dayCount > 0 ? count ~/ dayCount : 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF052C40), Color(0xFF0077B6)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0077B6).withOpacity(0.30),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Slot Preview',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _PreviewStat(
                  value: '$count',
                  label: 'Total Slots',
                  icon: Icons.event_available_rounded,
                ),
                _buildVerticalDivider(),
                _PreviewStat(
                  value: '$slotsPerDay',
                  label: 'Per Day',
                  icon: Icons.today_rounded,
                ),
                _buildVerticalDivider(),
                _PreviewStat(
                  value: '$dayCount',
                  label: 'Days',
                  icon: Icons.date_range_rounded,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: Colors.white.withOpacity(0.2),
    );
  }
}

class _PreviewStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _PreviewStat({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 11, color: Colors.white.withOpacity(0.65)),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.65),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}