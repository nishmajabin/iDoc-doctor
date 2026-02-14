import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/data/models/slot_model.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_event.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_state.dart';
import 'package:idoc_doctor_side/logic/cubits/view_slots_ui/view_slots_ui_cubit.dart';
import 'package:idoc_doctor_side/logic/cubits/view_slots_ui/view_slots_ui_state.dart';
import 'action_buttons_widget.dart';
import 'calendar_widget.dart';
import 'slots_list_widget.dart';
import 'statistics_widget.dart';

class ViewSlotsPageBody extends StatelessWidget {
  const ViewSlotsPageBody({super.key});

  void _fetchSlotsForMonth(BuildContext context, DateTime focusedDay) {
    final firstDay = DateTime(focusedDay.year, focusedDay.month, 1);
    final lastDay = DateTime(focusedDay.year, focusedDay.month + 1, 0);
    context.read<SlotBloc>().add(
      FetchSlotsByDateRangeEvent(startDate: firstDay, endDate: lastDay),
    );
  }

  Map<DateTime, List<SlotModel>> _buildSlotsCache(List<SlotModel> slots) {
    final Map<DateTime, List<SlotModel>> cache = {};
    for (final slot in slots) {
      final normalizedDate = DateTime(
        slot.date.year,
        slot.date.month,
        slot.date.day,
      );
      cache.putIfAbsent(normalizedDate, () => []).add(slot);
    }
    return cache;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewSlotsUiCubit, ViewSlotsUiState>(
      builder: (context, uiState) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: Text(
              uiState.isSelectionMode
                  ? '${uiState.selectedSlotIds.length} selected'
                  : 'My Appointment Slots',
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            leading:
                uiState.isSelectionMode
                    ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed:
                          () =>
                              context
                                  .read<ViewSlotsUiCubit>()
                                  .toggleSelectionMode(),
                    )
                    : null,
            actions: [
              if (uiState.isSelectionMode) ...[
                if (uiState.selectedSlotIds.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed:
                        () => _fetchSlotsForMonth(context, uiState.focusedDay),
                    tooltip: 'Delete Selected',
                  ),
              ] else ...[
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed:
                      () => _fetchSlotsForMonth(context, uiState.focusedDay),
                  tooltip: 'Refresh',
                ),
              ],
            ],
          ),
          body: BlocConsumer<SlotBloc, SlotState>(
            listener:
                (context, state) =>
                    _handleSlotStateChanges(context, state, uiState),
            builder: (context, slotState) {
              if (slotState is SlotLoading &&
                  slotState is! SlotsFetchedSuccess) {
                return const Center(child: CircularProgressIndicator());
              }

              final slots =
                  slotState is SlotsFetchedSuccess
                      ? slotState.slots
                      : <SlotModel>[];
              final slotsCache = _buildSlotsCache(slots);

              return SingleChildScrollView(
                child: Column(
                  children: [
                    CalendarWidget(uiState: uiState, slotsCache: slotsCache),
                    const SizedBox(height: 16),
                    StatisticsWidget(uiState: uiState, slotsCache: slotsCache),
                    const SizedBox(height: 16),
                    ActionButtonsWidget(
                      uiState: uiState,
                      slotsCache: slotsCache,
                    ),
                    const SizedBox(height: 16),
                    SlotsListWidget(uiState: uiState, slotsCache: slotsCache),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _handleSlotStateChanges(
    BuildContext context,
    SlotState state,
    ViewSlotsUiState uiState,
  ) {
    if (state is SlotError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } else if (state is SlotDeletedSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Slot deleted successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      _fetchSlotsForMonth(context, uiState.focusedDay);
    } else if (state is MultipleSlotsDeletedSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${state.count} slots deleted successfully'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
      context.read<ViewSlotsUiCubit>().toggleSelectionMode();
      _fetchSlotsForMonth(context, uiState.focusedDay);
    } else if (state is SlotUpdatedSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Slot updated successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      _fetchSlotsForMonth(context, uiState.focusedDay);
    }
  }
}
