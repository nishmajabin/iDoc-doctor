// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:idoc_doctor_side/data/models/slot_model.dart';
// import 'package:idoc_doctor_side/logic/blocs/slot/slot_bloc.dart';
// import 'package:idoc_doctor_side/logic/blocs/slot/slot_event.dart';
// import 'package:idoc_doctor_side/logic/cubits/edit_slot/edit_slot_cubit.dart';
// import 'package:idoc_doctor_side/logic/cubits/edit_slot/edit_slot_state.dart';
// import 'package:idoc_doctor_side/presentation/screens/doctor/slots_view/utils/time_utils.dart';
// import 'package:intl/intl.dart';

// class EditSlotDialog extends StatelessWidget {
//   final SlotModel slot;

//   const EditSlotDialog({required this.slot, super.key});

//   static TimeOfDay _toTimeOfDay(String hhmm) {
//     final parts = hhmm.split(':');
//     return TimeOfDay(
//       hour: int.parse(parts[0]),
//       minute: int.parse(parts[1]),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => EditSlotCubit(
//         initialStart: _toTimeOfDay(slot.startTime),
//         initialEnd: _toTimeOfDay(slot.endTime),
//       ),
//       child: _EditSlotDialogBody(slot: slot),
//     );
//   }
// }

// class _EditSlotDialogBody extends StatelessWidget {
//   final SlotModel slot;

//   const _EditSlotDialogBody({required this.slot});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<EditSlotCubit, EditSlotState>(
//       builder: (context, editState) {
//         return AlertDialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           title: const Row(
//             children: [
//               Icon(Icons.edit_calendar, color: Color(0xFF00D4FF)),
//               SizedBox(width: 12),
//               Expanded(child: Text('Edit Slot Time')),
//             ],
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _buildInfoBox(),
//               const SizedBox(height: 20),
//               _buildTimeFields(context, editState),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () => _saveSlot(context, editState),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF00D4FF),
//                 foregroundColor: Colors.white,
//               ),
//               child: const Text('Update'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildInfoBox() {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.blue.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.blue.withOpacity(0.3)),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               const Icon(Icons.info_outline, size: 18, color: Colors.blue),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   'Date: ${DateFormat('MMM dd, yyyy').format(slot.date)}',
//                   style: const TextStyle(
//                       fontSize: 13, fontWeight: FontWeight.w500),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               const Icon(Icons.access_time, size: 18, color: Colors.blue),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   'Created: ${DateFormat('MMM dd, HH:mm').format(slot.createdAt)}',
//                   style: const TextStyle(fontSize: 12),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               const Icon(Icons.timer, size: 18, color: Colors.green),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   'Time remaining: ${(60 - getHoursSinceCreation(slot.createdAt) * 60).toStringAsFixed(0)} min',
//                   style: const TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.green,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTimeFields(BuildContext context, EditSlotState editState) {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildTimeField(
//             context: context,
//             label: 'Start Time',
//             time: editState.startTime,
//             onTap: () => _pickTime(
//               context: context,
//               initial: editState.startTime,
//               onPicked: (t) =>
//                   context.read<EditSlotCubit>().updateStartTime(t),
//             ),
//           ),
//         ),
//         const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 8),
//           child: Text('to', style: TextStyle(fontWeight: FontWeight.w500)),
//         ),
//         Expanded(
//           child: _buildTimeField(
//             context: context,
//             label: 'End Time',
//             time: editState.endTime,
//             onTap: () => _pickTime(
//               context: context,
//               initial: editState.endTime,
//               onPicked: (t) =>
//                   context.read<EditSlotCubit>().updateEndTime(t),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTimeField({
//     required BuildContext context,
//     required String label,
//     required TimeOfDay time,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: Colors.grey[300]!),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 11,
//                 color: Colors.grey[600],
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               time.format(context), // respects system locale (AM/PM aware)
//               style: const TextStyle(
//                   fontSize: 15, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _pickTime({
//     required BuildContext context,
//     required TimeOfDay initial,
//     required ValueChanged<TimeOfDay> onPicked,
//   }) async {
//     final picked = await showTimePicker(
//       context: context,
//       initialTime: initial,
//       builder: (context, child) => Theme(
//         data: Theme.of(context).copyWith(
//           colorScheme: const ColorScheme.light(primary: Color(0xFF00D4FF)),
//         ),
//         child: child!,
//       ),
//     );
//     if (picked != null) onPicked(picked);
//   }

//   void _saveSlot(BuildContext context, EditSlotState editState) {
//     final startMinutes =
//         editState.startTime.hour * 60 + editState.startTime.minute;
//     final endMinutes =
//         editState.endTime.hour * 60 + editState.endTime.minute;

//     if (endMinutes <= startMinutes) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('End time must be after start time'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     // Always persist as zero-padded 24-hr strings — Firestore format unchanged
//     final newStartTime =
//         '${editState.startTime.hour.toString().padLeft(2, '0')}:${editState.startTime.minute.toString().padLeft(2, '0')}';
//     final newEndTime =
//         '${editState.endTime.hour.toString().padLeft(2, '0')}:${editState.endTime.minute.toString().padLeft(2, '0')}';

//     context.read<SlotBloc>().add(
//           UpdateSlotEvent(
//             slotId: slot.slotId,
//             startTime: newStartTime,
//             endTime: newEndTime,
//           ),
//         );

//     Navigator.pop(context);
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/data/models/slot_model.dart';
import 'package:idoc_doctor_side/logic/cubits/edit_slot/edit_slot_cubit.dart';
import 'package:idoc_doctor_side/core/utils/time_formatter.dart';
import 'package:idoc_doctor_side/presentation/screens/doctor/available_time/slots_view/dialogs/widgets/edit_slot_body.dart';


class EditSlotDialog extends StatelessWidget {
  final SlotModel slot;

  const EditSlotDialog({super.key, required this.slot});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditSlotCubit(
        initialStart: TimeFormatter.toTimeOfDay(slot.startTime),
        initialEnd: TimeFormatter.toTimeOfDay(slot.endTime),
      ),
      child: EditSlotBody(slot: slot),
    );
  }
}

