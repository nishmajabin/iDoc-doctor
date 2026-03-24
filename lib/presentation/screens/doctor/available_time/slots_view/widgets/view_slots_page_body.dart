import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/data/models/slot_model.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_event.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_state.dart';
import 'package:idoc_doctor_side/logic/cubits/view_slots_ui/view_slots_ui_cubit.dart';
import 'package:idoc_doctor_side/logic/cubits/view_slots_ui/view_slots_ui_state.dart';
import 'calendar_widget.dart';
import 'statistics_widget.dart';
import 'slots_list_widget.dart';
import 'action_buttons_widget.dart';

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
      final normalizedDate =
          DateTime(slot.date.year, slot.date.month, slot.date.day);
      cache.putIfAbsent(normalizedDate, () => []).add(slot);
    }
    return cache;
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return BlocBuilder<ViewSlotsUiCubit, ViewSlotsUiState>(
      builder: (context, uiState) {
        return Scaffold(
          backgroundColor: const Color(0xFFF2F8FF),
          body: BlocConsumer<SlotBloc, SlotState>(
            listener: (context, state) =>
                _handleStateChanges(context, state, uiState),
            builder: (context, slotState) {
              final isLoading =
                  slotState is SlotLoading && slotState is! SlotsFetchedSuccess;
              final slots = slotState is SlotsFetchedSuccess
                  ? slotState.slots
                  : <SlotModel>[];
              final slotsCache = _buildSlotsCache(slots);

              return Stack(
                children: [
                  // Content
                  CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      // Reserve space for the fixed header
                      SliverToBoxAdapter(
                        child: SizedBox(height: topPadding + 72),
                      ),
                      if (isLoading)
                        const SliverFillRemaining(
                          child: Center(
                            child: _LoadingIndicator(),
                          ),
                        )
                      else ...[
                        SliverToBoxAdapter(
                          child: CalendarWidget(
                            uiState: uiState,
                            slotsCache: slotsCache,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: StatisticsWidget(
                              uiState: uiState,
                              slotsCache: slotsCache,
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: ActionButtonsWidget(
                              uiState: uiState,
                              slotsCache: slotsCache,
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 40),
                            child: SlotsListWidget(
                              uiState: uiState,
                              slotsCache: slotsCache,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  // Fixed gradient header
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: _buildHeader(context, topPadding, uiState),
                  ),

                  // Selection mode bottom bar
                  if (uiState.isSelectionMode &&
                      uiState.selectedSlotIds.isNotEmpty)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: _SelectionBar(
                        selectedCount: uiState.selectedSlotIds.length,
                        onDelete: () => _deleteSelected(context, uiState),
                        onCancel: () =>
                            context.read<ViewSlotsUiCubit>().toggleSelectionMode(),
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    double topPadding,
    ViewSlotsUiState uiState,
  ) {
    final isSelection = uiState.isSelectionMode;

    return Container(
      height: topPadding + 72,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF052C40), Color(0xFF0077B6), Color(0xFF00B4D8)],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Decorative circle
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            top: topPadding + 8,
            left: 12,
            right: 12,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (isSelection) {
                      context.read<ViewSlotsUiCubit>().toggleSelectionMode();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isSelection ? Icons.close_rounded : Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      isSelection
                          ? '${uiState.selectedSlotIds.length} Selected'
                          : 'My Slots',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      isSelection
                          ? 'Tap slots to select / deselect'
                          : 'Manage your availability',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.65),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => _fetchSlotsForMonth(
                    context,
                    uiState.focusedDay,
                  ),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _deleteSelected(BuildContext context, ViewSlotsUiState uiState) {
    showDialog(
      context: context,
      builder: (ctx) => _DeleteDialog(
        count: uiState.selectedSlotIds.length,
        onConfirm: () {
          context.read<SlotBloc>().add(
            DeleteMultipleSlotsEvent(
              uiState.selectedSlotIds.toList(),
            ),
          );
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _handleStateChanges(
    BuildContext context,
    SlotState state,
    ViewSlotsUiState uiState,
  ) {
    if (state is SlotError) {
      _showSnack(context, state.message, isError: true);
    } else if (state is SlotDeletedSuccess) {
      _showSnack(context, 'Slot deleted successfully');
      _fetchSlotsForMonth(context, uiState.focusedDay);
    } else if (state is MultipleSlotsDeletedSuccess) {
      _showSnack(context, '${state.count} slots deleted');
      context.read<ViewSlotsUiCubit>().toggleSelectionMode();
      _fetchSlotsForMonth(context, uiState.focusedDay);
    } else if (state is SlotUpdatedSuccess) {
      _showSnack(context, 'Slot updated successfully');
      _fetchSlotsForMonth(context, uiState.focusedDay);
    }
  }

  void _showSnack(BuildContext context, String message,
      {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message,
                  style: const TextStyle(fontWeight: FontWeight.w500)),
            ),
          ],
        ),
        backgroundColor:
            isError ? const Color(0xFFD13D3D) : const Color(0xFF2D9E6B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

// ── Loading indicator ────────────────────────────────────────────────────────

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 44,
          height: 44,
          child: CircularProgressIndicator(
            color: const Color(0xFF0077B6),
            strokeWidth: 2.5,
            backgroundColor: const Color(0xFF0077B6).withOpacity(0.12),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Loading slots...',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7A91),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ── Selection bottom bar ─────────────────────────────────────────────────────

class _SelectionBar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onDelete;
  final VoidCallback onCancel;

  const _SelectionBar({
    required this.selectedCount,
    required this.onDelete,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 14,
        bottom: MediaQuery.of(context).padding.bottom + 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF052C40).withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F4FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$selectedCount slot${selectedCount > 1 ? 's' : ''} selected',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0077B6),
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onCancel,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F8FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFDDE8F0)),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7A91),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFD13D3D),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD13D3D).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.delete_outline_rounded,
                      color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Delete confirmation dialog ───────────────────────────────────────────────

class _DeleteDialog extends StatelessWidget {
  final int count;
  final VoidCallback onConfirm;

  const _DeleteDialog({required this.count, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFFFEBEB),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete_outline_rounded,
                  color: Color(0xFFD13D3D), size: 28),
            ),
            const SizedBox(height: 18),
            const Text(
              'Delete Slots?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A2332),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'You are about to delete $count slot${count > 1 ? 's' : ''}. This action cannot be undone.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7A91),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F8FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7A91),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: onConfirm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD13D3D),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}