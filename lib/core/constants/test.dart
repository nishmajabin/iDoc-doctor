// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:idoc_doctor_side/data/services/appointment_service.dart';
// import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_bloc.dart';
// import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_event.dart';
// import 'package:idoc_doctor_side/logic/blocs/auth/auth_bloc.dart';
// import 'package:idoc_doctor_side/logic/blocs/auth/auth_state.dart';
// import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/appoinment_content.dart';
// import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/edge_case_views.dart';
// import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/invalid_doctor_view.dart';

// class DoctorAppointmentsScreen extends StatelessWidget {
//   const DoctorAppointmentsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final authState = context.read<DoctorAuthBloc>().state;

//     if (authState is! DoctorAuthSuccess) {
//       return const UnauthenticatedView();
//     }

//     final doctorId = authState.doctor.id;
//     if (doctorId == null || doctorId.isEmpty) {
//       return const InvalidDoctorView();
//     }

//     return BlocProvider(
//       create:
//           (context) => DoctorAppointmentBloc(
//             DoctorAppointmentService(FirebaseFirestore.instance),
//           )..add(FetchDoctorAppointments(doctorId)),
//       child: const AppointmentsContent(),
//     );
//   }
// }


// import 'package:flutter/material.dart';

// class TimeBadge extends StatelessWidget {
//   final String time;

//   const TimeBadge({required this.time, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
//       decoration: BoxDecoration(
//         color: const Color(0xFF00D4FF).withValues(alpha: 0.12),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: const Color(0xFF00D4FF).withValues(alpha: 0.3),
//           width: 1,
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Icon(
//             Icons.access_time_rounded,
//             color: Color(0xFF0099CC),
//             size: 15,
//           ),
//           const SizedBox(width: 6),
//           Text(
//             time,
//             style: const TextStyle(
//               color: Color(0xFF0099CC),
//               fontSize: 13,
//               fontWeight: FontWeight.w700,
//               letterSpacing: 0.2,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';

// class TabSkeleton extends StatelessWidget {
//   const TabSkeleton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Shimmer.fromColors(
//       baseColor: const Color(0xFFE8E8E8),
//       highlightColor: const Color(0xFFF5F5F5),
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 20),
//         height: 52,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// class TabItem extends StatelessWidget {
//   final String label;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const TabItem({
//     required this.label,
//     required this.isSelected,
//     required this.onTap,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 220),
//           curve: Curves.easeInOut,
//           decoration: BoxDecoration(
//             color: isSelected ? Colors.white : Colors.transparent,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: isSelected
//                 ? [
//                     BoxShadow(
//                       color: Colors.black.withValues(alpha: 0.08),
//                       blurRadius: 10,
//                       offset: const Offset(0, 2),
//                     ),
//                   ]
//                 : null,
//           ),
//           alignment: Alignment.center,
//           child: Text(
//             label,
//             style: TextStyle(
//               color: isSelected
//                   ? const Color(0xFF0D0D0D)
//                   : const Color(0xFF9E9E9E),
//               fontSize: 15,
//               fontWeight:
//                   isSelected ? FontWeight.w700 : FontWeight.w500,
//               letterSpacing: -0.1,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';

// class ShimmerCard extends StatelessWidget {
//   const ShimmerCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Shimmer.fromColors(
//       baseColor: const Color(0xFFE8E8E8),
//       highlightColor: const Color(0xFFF5F5F5),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 14),
//         padding: const EdgeInsets.all(18),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 58,
//               height: 58,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     height: 15,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Container(
//                     height: 13,
//                     width: 130,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                   ),
//                   const SizedBox(height: 14),
//                   Container(
//                     height: 32,
//                     width: 100,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:idoc_doctor_side/data/models/appointment_model.dart';
// import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_bloc.dart';
// import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_event.dart';

// class PrescriptionDialog extends StatelessWidget {
//   final DoctorAppointmentModel appointment;
//   final TextEditingController controller;
//   final BuildContext blocContext;

//   const PrescriptionDialog({
//     required this.appointment,
//     required this.controller,
//     required this.blocContext,
//     super.key
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//       titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
//       contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
//       actionsPadding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
//       title: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF00D4FF).withValues(alpha: 0.12),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Icon(
//                   Icons.medical_services_rounded,
//                   color: Color(0xFF0099CC),
//                   size: 20,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               const Text(
//                 'Add Prescription',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w800,
//                   color: Color(0xFF0D0D0D),
//                   letterSpacing: -0.3,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             decoration: BoxDecoration(
//               color: const Color(0xFFF7F8FC),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Row(
//               children: [
//                 const Icon(Icons.person_outline,
//                     size: 16, color: Color(0xFF9E9E9E)),
//                 const SizedBox(width: 6),
//                 Text(
//                   appointment.patientName,
//                   style: const TextStyle(
//                     fontSize: 13,
//                     color: Color(0xFF616161),
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       content: TextField(
//         controller: controller,
//         maxLines: 5,
//         style: const TextStyle(
//           fontSize: 14,
//           color: Color(0xFF0D0D0D),
//           height: 1.6,
//         ),
//         decoration: InputDecoration(
//           hintText: 'Enter prescription details...',
//           hintStyle: const TextStyle(
//             color: Color(0xFFBDBDBD),
//             fontSize: 14,
//           ),
//           filled: true,
//           fillColor: const Color(0xFFF7F8FC),
//           contentPadding: const EdgeInsets.all(16),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: BorderSide.none,
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: const BorderSide(
//               color: Color(0xFF00D4FF),
//               width: 1.5,
//             ),
//           ),
//         ),
//       ),
//       actions: [
//         Row(
//           children: [
//             Expanded(
//               child: GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   height: 48,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF0F0F5),
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   alignment: Alignment.center,
//                   child: const Text(
//                     'Cancel',
//                     style: TextStyle(
//                       color: Color(0xFF616161),
//                       fontWeight: FontWeight.w700,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: GestureDetector(
//                 onTap: () {
//                   final text = controller.text.trim();
//                   if (text.isNotEmpty) {
//                     blocContext.read<DoctorAppointmentBloc>().add(
//                           AddPrescriptionEvent(
//                             appointmentId: appointment.appointmentId,
//                             prescription: text,
//                           ),
//                         );
//                     Navigator.pop(context);
//                     ScaffoldMessenger.of(blocContext).showSnackBar(
//                       SnackBar(
//                         content: const Row(
//                           children: [
//                             Icon(Icons.check_circle_outline,
//                                 color: Colors.white, size: 18),
//                             SizedBox(width: 10),
//                             Text('Prescription saved'),
//                           ],
//                         ),
//                         backgroundColor: const Color(0xFF43A047),
//                         behavior: SnackBarBehavior.floating,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         margin: const EdgeInsets.all(16),
//                         duration: const Duration(seconds: 2),
//                       ),
//                     );
//                   }
//                 },
//                 child: Container(
//                   height: 48,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF0D0D0D),
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   alignment: Alignment.center,
//                   child: const Text(
//                     'Save',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:idoc_doctor_side/data/models/appointment_model.dart';
// import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/prescription_dialog.dart';

// class PrescriptionButton extends StatelessWidget {
//   final DoctorAppointmentModel appointment;

//   const PrescriptionButton({required this.appointment, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _showPrescriptionDialog(context),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
//         decoration: BoxDecoration(
//           color: const Color(0xFF0D0D0D),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: const Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.edit_note_rounded, color: Color(0xFF00D4FF), size: 15),
//             SizedBox(width: 5),
//             Text(
//               'Prescribe',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w700,
//                 letterSpacing: 0.1,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showPrescriptionDialog(BuildContext context) {
//     final TextEditingController prescriptionController = TextEditingController(
//       text: appointment.prescription ?? '',
//     );

//     showDialog(
//       context: context,
//       builder:
//           (dialogContext) => PrescriptionDialog(
//             appointment: appointment,
//             controller: prescriptionController,
//             blocContext: context,
//           ),
//     );
//   }
// }
// import 'package:flutter/material.dart';

// class PatientAvatar extends StatelessWidget {
//   final String name;
//   final String? imageUrl;

//   const PatientAvatar({required this.name, this.imageUrl, super.key});

//   @override
//   Widget build(BuildContext context) {
//     final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
//     final initial = name.isNotEmpty ? name[0].toUpperCase() : 'P';

//     return Container(
//       width: 58,
//       height: 58,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         gradient:
//             hasImage
//                 ? null
//                 : const LinearGradient(
//                   colors: [Color(0xFF00D4FF), Color(0xFF0099CC)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//         image:
//             hasImage
//                 ? DecorationImage(
//                   image: NetworkImage(imageUrl!),
//                   fit: BoxFit.cover,
//                 )
//                 : null,
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF00D4FF).withValues(alpha: 0.25),
//             blurRadius: 10,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child:
//           hasImage
//               ? null
//               : Center(
//                 child: Text(
//                   initial,
//                   style: const TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.w800,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/shimmer_card.dart';
// import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/tab_skeleton.dart';

// class LoadingView extends StatelessWidget {
//   const LoadingView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(height: 24),
//         const TabSkeleton(),
//         const SizedBox(height: 24),
//         Expanded(
//           child: ListView.builder(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             itemCount: 5,
//             itemBuilder: (_, __) => const ShimmerCard(),
//           ),
//         ),
//       ],
//     );
//   }
// }

// import 'package:flutter/material.dart';

// class MessageButton extends StatelessWidget {
//   const MessageButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 40,
//       height: 40,
//       decoration: BoxDecoration(
//         color: const Color(0xFF0D0D0D),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: const Icon(
//         Icons.chat_bubble_outline_rounded,
//         color: Color(0xFF00D4FF),
//         size: 18,
//       ),
//     );
//   }
// }import 'package:flutter/material.dart';

// class InvalidDoctorView extends StatelessWidget {
//   const InvalidDoctorView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text('Appointments'),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       backgroundColor: const Color(0xFFF7F8FC),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.error_outline_rounded,
//                 size: 60, color: Colors.grey[300]),
//             const SizedBox(height: 16),
//             Text(
//               'Doctor profile not found',
//               style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';

// class UnauthenticatedView extends StatelessWidget {
//   const UnauthenticatedView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text('Appointments'),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       backgroundColor: const Color(0xFFF7F8FC),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.lock_outline_rounded,
//                 size: 60, color: Colors.grey[300]),
//             const SizedBox(height: 16),
//             Text(
//               'Please login to view appointments',
//               style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class DateHeader extends StatelessWidget {
//   final DateTime date;

//   const DateHeader({required this.date, super.key});

//   String _formatDate(DateTime date) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final tomorrow = today.add(const Duration(days: 1));

//     if (date == today) return 'Today';
//     if (date == tomorrow) return 'Tomorrow';
//     return DateFormat('dd MMM, yyyy').format(date);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 8, bottom: 12),
//       child: Row(
//         children: [
//           Container(
//             width: 3,
//             height: 16,
//             decoration: BoxDecoration(
//               color: const Color(0xFF00D4FF),
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Text(
//             _formatDate(date),
//             style: const TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w700,
//               color: Color(0xFF0D0D0D),
//               letterSpacing: -0.2,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// class CompletedBadge extends StatelessWidget {
//   const CompletedBadge({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
//       decoration: BoxDecoration(
//         color: const Color(0xFFE8F5E9),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: const Color(0xFF81C784).withValues(alpha: 0.5),
//           width: 1,
//         ),
//       ),
//       child: const Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.check_circle_rounded, color: Color(0xFF43A047), size: 14),
//           SizedBox(width: 5),
//           Text(
//             'Done',
//             style: TextStyle(
//               color: Color(0xFF2E7D32),
//               fontSize: 12,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_state.dart';
// import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/appoinment_tab_bar.dart';
// import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/appointment_list_view.dart';

// class AppointmentLoadingView extends StatelessWidget {
//   final DoctorAppointmentLoaded state;

//   const AppointmentLoadingView({required this.state, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(height: 24),
//         AppointmentTabBar(isUpcomingSelected: state.isUpcomingSelected),
//         const SizedBox(height: 20),
//         Expanded(
//           child: AppointmentListView(
//             appointments:
//                 state.isUpcomingSelected ? state.upcoming : state.past,
//             isUpcoming: state.isUpcomingSelected,
//           ),
//         ),
//       ],
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/appoinment_empty_state.dart';
// import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/date_header.dart';
// import 'package:idoc_doctor_side/data/models/appointment_model.dart';
// import 'appointment_card.dart';

// class AppointmentListView extends StatelessWidget {
//   final List<DoctorAppointmentModel> appointments;
//   final bool isUpcoming;

//   const AppointmentListView({
//     required this.appointments,
//     required this.isUpcoming,
//     super.key
//   });

//   Map<DateTime, List<DoctorAppointmentModel>> _groupByDate(
//       List<DoctorAppointmentModel> items) {
//     final Map<DateTime, List<DoctorAppointmentModel>> grouped = {};

//     for (final a in items) {
//       final date = DateTime(
//         a.appointmentDate.year,
//         a.appointmentDate.month,
//         a.appointmentDate.day,
//       );
//       grouped.putIfAbsent(date, () => []).add(a);
//     }

//     for (final list in grouped.values) {
//       list.sort((a, b) => a.startTime.compareTo(b.startTime));
//     }

//     return grouped;
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (appointments.isEmpty) {
//       return EmptyState(isUpcoming: isUpcoming);
//     }

//     final grouped = _groupByDate(appointments);

//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       itemCount: grouped.length,
//       itemBuilder: (context, index) {
//         final date = grouped.keys.elementAt(index);
//         final dayAppointments = grouped[date]!;

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             DateHeader(date: date),
//             ...dayAppointments.map(
//               (a) => AppointmentCard(
//                 appointment: a,
//                 isUpcoming: isUpcoming,
//               ),
//             ),
//             const SizedBox(height: 8),
//           ],
//         );
//       },
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:idoc_doctor_side/data/models/appointment_model.dart';
// import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/action_row.dart';
// import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/message_button.dart';
// import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/patient_avatar.dart';
// import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/time_badge.dart';

// class AppointmentCard extends StatelessWidget {
//   final DoctorAppointmentModel appointment;
//   final bool isUpcoming;


//   const AppointmentCard({required this.appointment, required this.isUpcoming, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
      
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.05),
//             blurRadius: 16,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             PatientAvatar(
//               name: appointment.patientName,
//               imageUrl: appointment.profileImageUrl,
//             ),
//             const SizedBox(width: 14),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     appointment.patientName,
//                     style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                       color: Color(0xFF0D0D0D),
//                       letterSpacing: -0.2,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 10),
//                   isUpcoming
//                       ? TimeBadge(time: appointment.startTime)
//                       : ActionRow(appointment: appointment),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 10),
//             const MessageButton(),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_bloc.dart';
// import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_event.dart';
// import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/tab_item.dart';

// class AppointmentTabBar extends StatelessWidget {
//   final bool isUpcomingSelected;

//   const AppointmentTabBar({required this.isUpcomingSelected, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       height: 52,
//       padding: const EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF0F0F5),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Row(
//         children: [
//           TabItem(
//             label: 'Upcoming',
//             isSelected: isUpcomingSelected,
//             onTap: () => context
//                 .read<DoctorAppointmentBloc>()
//                 .add(const SwitchAppointmentTab(true)),
//           ),
//           TabItem(
//             label: 'Past',
//             isSelected: !isUpcomingSelected,
//             onTap: () => context
//                 .read<DoctorAppointmentBloc>()
//                 .add(const SwitchAppointmentTab(false)),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_bloc.dart';
// import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_state.dart';
// import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/appointment_loading_view.dart';
// import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/loading_view.dart';

// class AppointmentsContent extends StatelessWidget {
//   const AppointmentsContent({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F8FC),
//       appBar: _buildAppBar(),
//       body: BlocConsumer<DoctorAppointmentBloc, DoctorAppointmentState>(
//         listener: (context, state) {
//           if (state is DoctorAppointmentError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Row(
//                   children: [
//                     const Icon(
//                       Icons.error_outline,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(child: Text(state.message)),
//                   ],
//                 ),
//                 backgroundColor: const Color(0xFFE53935),
//                 behavior: SnackBarBehavior.floating,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 margin: const EdgeInsets.all(16),
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is DoctorAppointmentLoading) {
//             return const LoadingView();
//           }

//           if (state is DoctorAppointmentLoaded) {
//             return AppointmentLoadingView(state: state);
//           }

//           return const SizedBox.shrink();
//         },
//       ),
//     );
//   }

//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       automaticallyImplyLeading: false,
//       backgroundColor: Colors.white,
//       elevation: 0,
//       surfaceTintColor: Colors.transparent,
//       centerTitle: true,
//       title: const Text(
//         'Appointments',
//         style: TextStyle(
//           color: Color(0xFF0D0D0D),
//           fontSize: 20,
//           fontWeight: FontWeight.w700,
//           letterSpacing: -0.3,
//         ),
//       ),
//       bottom: PreferredSize(
//         preferredSize: const Size.fromHeight(1),
//         child: Container(height: 1, color: const Color(0xFFEEEEEE)),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:idoc_doctor_side/data/models/appointment_model.dart';
// import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/completed_badge.dart';
// import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/prescription_button.dart';

// class ActionRow extends StatelessWidget {
//   final DoctorAppointmentModel appointment;

//   const ActionRow({required this.appointment, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         const CompletedBadge(),
//         const SizedBox(width: 8),
//         PrescriptionButton(appointment: appointment),
//       ],
//     );
//   }
// }

// import 'package:flutter/material.dart';

// class EmptyState extends StatelessWidget {
//   final bool isUpcoming;

//   const EmptyState({required this.isUpcoming, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 40),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 100,
//               height: 100,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF0F0F5),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 isUpcoming
//                     ? Icons.calendar_month_outlined
//                     : Icons.history_rounded,
//                 size: 48,
//                 color: const Color(0xFFBDBDBD),
//               ),
//             ),
//             const SizedBox(height: 24),
//             Text(
//               isUpcoming
//                   ? 'No Upcoming Appointments'
//                   : 'No Past Appointments',
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 color: Color(0xFF0D0D0D),
//                 letterSpacing: -0.3,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 10),
//             Text(
//               isUpcoming
//                   ? 'Your upcoming scheduled appointments will appear here.'
//                   : 'Completed appointments will be shown here.',
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: Color(0xFF9E9E9E),
//                 height: 1.5,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }









