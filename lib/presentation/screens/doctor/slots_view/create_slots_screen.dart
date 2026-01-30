import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/data/models/slot_model.dart';
import 'package:idoc_doctor_side/data/services/slot_service.dart';
import 'package:idoc_doctor_side/logic/blocs/auth/auth_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/auth/auth_state.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_event.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_state.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CreateSlotsPage extends StatelessWidget {
  const CreateSlotsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authState = context.read<DoctorAuthBloc>().state;
    
    if (authState is! DoctorAuthSuccess) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Available Times'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Please login to create slots',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    final doctorId = authState.doctor.id;
    if (doctorId == null || doctorId.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Available Times'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
              const SizedBox(height: 16),
              Text(
                'Doctor ID not found',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return BlocProvider(
      create: (context) => SlotBloc(
        slotService: SlotService(FirebaseFirestore.instance),
        doctorId: doctorId,
      )..add(FetchSlotsByDateRangeEvent(
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 90)),
      )),
      child: const _CreateSlotsPageContent(),
    );
  }
}

class _CreateSlotsPageContent extends StatefulWidget {
  const _CreateSlotsPageContent({Key? key}) : super(key: key);

  @override
  State<_CreateSlotsPageContent> createState() => _CreateSlotsPageContentState();
}

class _CreateSlotsPageContentState extends State<_CreateSlotsPageContent> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
  
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  int _selectedInterval = 15;
  int _selectedBreakTime = 0;

  final Map<DateTime, List<SlotModel>> _slotsCache = {};

  @override
  void initState() {
    super.initState();
    _fetchSlotsForMonth();
  }

  void _fetchSlotsForMonth() {
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    
    context.read<SlotBloc>().add(
      FetchSlotsByDateRangeEvent(startDate: firstDay, endDate: lastDay),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Available Times'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: BlocConsumer<SlotBloc, SlotState>(
        listener: (context, state) {
          if (state is SlotsFetchedSuccess) {
            _updateSlotsCache(state.slots);
          } else if (state is SlotsCreatedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.slots.length} slots created successfully!'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
            setState(() {
              _rangeStart = null;
              _rangeEnd = null;
            });
            _fetchSlotsForMonth();
          } else if (state is SlotError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildCalendar(),
                const SizedBox(height: 16),
                _buildDateRangeInfo(),
                const SizedBox(height: 16),
                _buildTimeSelectors(),
                const SizedBox(height: 16),
                _buildIntervalSelector(),
                const SizedBox(height: 16),
                _buildBreakTimeSelector(),
                const SizedBox(height: 24),
                _buildScheduleButton(state),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF00D4FF).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 18, color: Color(0xFF00D4FF)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tap to select start date, tap again to select end date. Orange dots = slots already exist',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 90)),
            focusedDay: _focusedDay,
            rangeSelectionMode: _rangeSelectionMode,
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.black),
              rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.black),
            ),
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              todayDecoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: Color(0xFF00D4FF),
                shape: BoxShape.circle,
              ),
              rangeStartDecoration: const BoxDecoration(
                color: Color(0xFF00D4FF),
                shape: BoxShape.circle,
              ),
              rangeEndDecoration: const BoxDecoration(
                color: Color(0xFF00D4FF),
                shape: BoxShape.circle,
              ),
              rangeHighlightColor: const Color(0xFF00D4FF).withOpacity(0.2),
              withinRangeDecoration: BoxDecoration(
                color: const Color(0xFF00D4FF).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              defaultTextStyle: const TextStyle(color: Colors.black87),
              weekendTextStyle: const TextStyle(color: Colors.black54),
              markerDecoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              if (selectedDay.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
                return;
              }

              setState(() {
                _focusedDay = focusedDay;
                
                if (_rangeStart == null) {
                  _rangeStart = selectedDay;
                  _rangeEnd = null;
                } else if (_rangeEnd != null) {
                  _rangeStart = selectedDay;
                  _rangeEnd = null;
                } else if (selectedDay.isBefore(_rangeStart!)) {
                  _rangeEnd = _rangeStart;
                  _rangeStart = selectedDay;
                } else if (isSameDay(selectedDay, _rangeStart)) {
                  _rangeEnd = null;
                } else {
                  _rangeEnd = selectedDay;
                }
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
              _fetchSlotsForMonth();
            },
            eventLoader: (day) {
              final normalizedDay = _normalizeDate(day);
              final slots = _slotsCache[normalizedDay] ?? [];
              return slots.take(3).toList();
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isEmpty) return null;
                return Positioned(
                  bottom: 1,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeInfo() {
    if (_rangeStart == null) {
      return const SizedBox.shrink();
    }

    final endDate = _rangeEnd ?? _rangeStart!;
    final dayCount = endDate.difference(_rangeStart!).inDays + 1;

    // Check if any date in range has existing slots
    final hasExistingSlots = _checkExistingSlotsInRange(_rangeStart!, endDate);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00D4FF), Color(0xFF0099CC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00D4FF).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.date_range, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Date Range',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${DateFormat('MMM dd').format(_rangeStart!)} - ${DateFormat('MMM dd, yyyy').format(endDate)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$dayCount day${dayCount > 1 ? 's' : ''} selected',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _rangeStart = null;
                      _rangeEnd = null;
                    });
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                  child: const Text('Clear'),
                ),
              ],
            ),
          ),
          if (hasExistingSlots) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.6), width: 2),
              ),
              child: Row(
                children: [
                  Icon(Icons.block, size: 22, color: Colors.red[800]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'ERROR: Some dates already have slots! You cannot create slots for dates that already have slots. Please choose different dates or delete existing slots first.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.red[900],
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeSelectors() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildTimeSelector(
              label: 'Start Time',
              time: _startTime,
              onTap: () => _selectTime(isStart: true),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'to',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildTimeSelector(
              label: 'End Time',
              time: _endTime,
              onTap: () => _selectTime(isStart: false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector({
    required String label,
    required TimeOfDay? time,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time?.format(context) ?? 'Select',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: time != null ? Colors.black : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntervalSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Slot Duration',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [15, 20, 30, 45, 60].map((interval) {
              final isSelected = _selectedInterval == interval;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedInterval = interval),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF00D4FF) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF00D4FF) : Colors.grey[300]!,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF00D4FF).withOpacity(0.3),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        '$interval\nmin',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.black87,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakTimeSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.coffee, size: 18, color: Colors.grey[700]),
              const SizedBox(width: 8),
              Text(
                'Break Time (after each slot)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [0, 5, 10, 15, 20, 30].map((breakTime) {
              final isSelected = _selectedBreakTime == breakTime;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedBreakTime = breakTime),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? const Color(0xFFFF9800) 
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected 
                            ? const Color(0xFFFF9800) 
                            : Colors.grey[300]!,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFFFF9800).withOpacity(0.3),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        breakTime == 0 ? 'None' : '$breakTime\nmin',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.black87,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          if (_selectedBreakTime > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.orange[800]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'A $_selectedBreakTime-minute break will be added after each appointment',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScheduleButton(SlotState state) {
    final isValid = _rangeStart != null && _startTime != null && _endTime != null;
    final endDate = _rangeEnd ?? _rangeStart;
    final dayCount = endDate != null ? endDate.difference(_rangeStart!).inDays + 1 : 0;
    
    bool hasValidTimeRange = false;
    if (_startTime != null && _endTime != null) {
      final start = _startTime!.hour * 60 + _startTime!.minute;
      final end = _endTime!.hour * 60 + _endTime!.minute;
      hasValidTimeRange = end > start;
    }

    final hasExistingSlots = _rangeStart != null && endDate != null 
        ? _checkExistingSlotsInRange(_rangeStart!, endDate)
        : false;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: Column(
        children: [
          if (isValid && !hasValidTimeRange) ...[
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, size: 16, color: Colors.red[800]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'End time must be after start time',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          ElevatedButton(
            onPressed: (isValid && hasValidTimeRange && !hasExistingSlots && state is! SlotLoading) 
                ? _createSlots 
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00D4FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              disabledBackgroundColor: Colors.grey[300],
            ),
            child: state is SlotLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    hasExistingSlots
                        ? 'Cannot Create - Slots Already Exist'
                        : isValid 
                            ? 'Create Slots for $dayCount Day${dayCount > 1 ? 's' : ''}' 
                            : 'Schedule',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _updateSlotsCache(List<SlotModel> slots) {
    setState(() {
      _slotsCache.clear();
      for (final slot in slots) {
        final normalizedDate = _normalizeDate(slot.date);
        _slotsCache.putIfAbsent(normalizedDate, () => []).add(slot);
      }
    });
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  bool _checkExistingSlotsInRange(DateTime start, DateTime end) {
    DateTime current = start;
    while (current.isBefore(end.add(const Duration(days: 1)))) {
      final normalized = _normalizeDate(current);
      if (_slotsCache.containsKey(normalized) && _slotsCache[normalized]!.isNotEmpty) {
        return true;
      }
      current = current.add(const Duration(days: 1));
    }
    return false;
  }

  Future<void> _selectTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: (isStart ? _startTime : _endTime) ?? TimeOfDay.now(),
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

    if (picked != null && mounted) {
      setState(() {
        if (isStart) {
          _startTime = picked;
          if (_endTime != null) {
            final startMinutes = picked.hour * 60 + picked.minute;
            final endMinutes = _endTime!.hour * 60 + _endTime!.minute;
            if (endMinutes <= startMinutes) {
              _endTime = null;
            }
          }
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _createSlots() {
    if (_rangeStart == null || _startTime == null || _endTime == null) return;

    final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
    final endMinutes = _endTime!.hour * 60 + _endTime!.minute;
    
    if (endMinutes <= startMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('End time must be after start time'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check for existing slots
    final endDate = _rangeEnd ?? _rangeStart!;
    final hasExisting = _checkExistingSlotsInRange(_rangeStart!, endDate);
    
    if (hasExisting) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot create slots - some dates already have slots!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    final startTimeStr =
        '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}';
    final endTimeStr =
        '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}';

    context.read<SlotBloc>().add(
      CreateSlotsForDateRangeEvent(
        startDate: _rangeStart!,
        endDate: endDate,
        startTime: startTimeStr,
        endTime: endTimeStr,
        intervalMinutes: _selectedInterval,
        breakTimeMinutes: _selectedBreakTime,
      ),
    );
  }
}