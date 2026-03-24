// import 'package:flutter/material.dart';
// import 'package:idoc_doctor_side/data/models/appointment_model.dart';
// import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/patient_avatar.dart';
// import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/prescription_button.dart';

// class AppointmentCard extends StatelessWidget {
//   final DoctorAppointmentModel appointment;
//   final bool isUpcoming;

//   const AppointmentCard({
//     required this.appointment,
//     required this.isUpcoming,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF052C40).withOpacity(isUpcoming ? 0.07 : 0.04),
//             blurRadius: 16,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(18),
//         child: Column(
//           children: [
//             // ── Accent stripe ─────────────────────────────────────────────
//             _AccentStripe(isUpcoming: isUpcoming, appointment: appointment),

//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // ── Patient info row ──────────────────────────────────
//                   _PatientInfoRow(
//                     appointment: appointment,
//                     isUpcoming: isUpcoming,
//                   ),

//                   const SizedBox(height: 12),
//                   Container(height: 1, color: const Color(0xFFF0F5FB)),
//                   const SizedBox(height: 12),

//                   // ── Meta info chips ────────────────────────────────────
//                   _MetaRow(
//                     appointment: appointment,
//                     isUpcoming: isUpcoming,
//                   ),

//                   // ── Action row ─────────────────────────────────────────
//                   if (isUpcoming) ...[
//                     const SizedBox(height: 12),
//                     _UpcomingActions(appointment: appointment),
//                   ] else ...[
//                     const SizedBox(height: 12),
//                     _PastActions(appointment: appointment),
//                   ],
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Accent stripe at top of card
// // ─────────────────────────────────────────────────────────────────────────────

// class _AccentStripe extends StatelessWidget {
//   final bool isUpcoming;
//   final DoctorAppointmentModel appointment;

//   const _AccentStripe({required this.isUpcoming, required this.appointment});

//   @override
//   Widget build(BuildContext context) {
//     List<Color> colors;
//     if (!isUpcoming) {
//       final status = (appointment.status ?? 'completed').toLowerCase();
//       colors = switch (status) {
//         'cancelled' => [
//             const Color(0xFFD13D3D).withOpacity(0.5),
//             const Color(0xFFD13D3D).withOpacity(0.2),
//           ],
//         _ => [
//             const Color(0xFF2D9E6B).withOpacity(0.6),
//             const Color(0xFF2D9E6B).withOpacity(0.2),
//           ],
//       };
//     } else {
//       colors = [const Color(0xFF052C40), const Color(0xFF00B4D8)];
//     }

//     return Container(
//       height: 3,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(colors: colors),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Patient info row: avatar + name + consultation type + status badge
// // ─────────────────────────────────────────────────────────────────────────────

// class _PatientInfoRow extends StatelessWidget {
//   final DoctorAppointmentModel appointment;
//   final bool isUpcoming;

//   const _PatientInfoRow({
//     required this.appointment,
//     required this.isUpcoming,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         PatientAvatar(
//           name: appointment.patientName,
//           imageUrl: appointment.profileImageUrl,
//           isUpcoming: isUpcoming,
//         ),
//         const SizedBox(width: 14),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 appointment.patientName,
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w700,
//                   letterSpacing: -0.2,
//                   color: isUpcoming
//                       ? const Color(0xFF1A2332)
//                       : const Color(0xFF4A5568),
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               const SizedBox(height: 4),
//               _ConsultationTypeBadge(
//                 type: 'Consultation',
//                 isUpcoming: isUpcoming,
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(width: 10),
//         _StatusBadge(
//           status: appointment.status ??
//               (isUpcoming ? 'confirmed' : 'completed'),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Consultation type badge
// // ─────────────────────────────────────────────────────────────────────────────

// class _ConsultationTypeBadge extends StatelessWidget {
//   final String type;
//   final bool isUpcoming;

//   const _ConsultationTypeBadge({required this.type, required this.isUpcoming});

//   @override
//   Widget build(BuildContext context) {
//     final isVideo = type.toLowerCase().contains('video');
//     final Color color;
//     if (!isUpcoming) {
//       color = const Color(0xFF9DAFC2);
//     } else if (isVideo) {
//       color = const Color(0xFF7B2FF7);
//     } else {
//       color = const Color(0xFF0077B6);
//     }

//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(
//           isVideo
//               ? Icons.videocam_outlined
//               : Icons.person_outline_rounded,
//           size: 12,
//           color: color,
//         ),
//         const SizedBox(width: 4),
//         Text(
//           type,
//           style: TextStyle(
//             fontSize: 11,
//             fontWeight: FontWeight.w600,
//             color: color,
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Status badge
// // ─────────────────────────────────────────────────────────────────────────────

// class _StatusBadge extends StatelessWidget {
//   final String status;

//   const _StatusBadge({required this.status});

//   @override
//   Widget build(BuildContext context) {
//     final (Color fg, Color bg, IconData icon, String label) =
//         switch (status.toLowerCase()) {
//       'confirmed' => (
//           const Color(0xFF0096C7),
//           const Color(0xFFE0F4FF),
//           Icons.check_circle_outline_rounded,
//           'Confirmed',
//         ),
//       'pending' => (
//           const Color(0xFFE07B00),
//           const Color(0xFFFFF3E0),
//           Icons.access_time_rounded,
//           'Pending',
//         ),
//       'completed' => (
//           const Color(0xFF2D9E6B),
//           const Color(0xFFE8F8F1),
//           Icons.task_alt_rounded,
//           'Done',
//         ),
//       'cancelled' => (
//           const Color(0xFFD13D3D),
//           const Color(0xFFFFEBEB),
//           Icons.cancel_outlined,
//           'Cancelled',
//         ),
//       _ => (
//           const Color(0xFF6B7A91),
//           const Color(0xFFEEF2F7),
//           Icons.info_outline_rounded,
//           status,
//         ),
//     };

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 11, color: fg),
//           const SizedBox(width: 4),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.w700,
//               color: fg,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Meta row: time + date chips
// // ─────────────────────────────────────────────────────────────────────────────

// class _MetaRow extends StatelessWidget {
//   final DoctorAppointmentModel appointment;
//   final bool isUpcoming;

//   const _MetaRow({required this.appointment, required this.isUpcoming});

//   String _formatTime(String raw) {
//     try {
//       final parts = raw.split(':');
//       int h = int.parse(parts[0]);
//       final m = int.parse(parts[1]);
//       final period = h >= 12 ? 'PM' : 'AM';
//       if (h > 12) h -= 12;
//       if (h == 0) h = 12;
//       return '$h:${m.toString().padLeft(2, '0')} $period';
//     } catch (_) {
//       return raw;
//     }
//   }

//   String _formatDate(DateTime d) {
//     const months = [
//       'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
//       'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
//     ];
//     final now = DateTime.now();
//     if (d.year == now.year && d.month == now.month && d.day == now.day) {
//       return 'Today';
//     }
//     return '${months[d.month - 1]} ${d.day}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final timeColor =
//         isUpcoming ? const Color(0xFF0077B6) : const Color(0xFF6B7A91);
//     final timeBg =
//         isUpcoming ? const Color(0xFFE0F4FF) : const Color(0xFFF0F5FB);

//     return Row(
//       children: [
//         _InfoChip(
//           icon: Icons.schedule_rounded,
//           label: _formatTime(appointment.startTime),
//           color: timeColor,
//           bgColor: timeBg,
//         ),
//         const SizedBox(width: 8),
//         _InfoChip(
//           icon: Icons.calendar_today_rounded,
//           label: _formatDate(appointment.appointmentDate),
//           color: const Color(0xFF6B7A91),
//           bgColor: const Color(0xFFF0F5FB),
//         ),
//       ],
//     );
//   }
// }

// class _InfoChip extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final Color color;
//   final Color bgColor;

//   const _InfoChip({
//     required this.icon,
//     required this.label,
//     required this.color,
//     required this.bgColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 13, color: color),
//           const SizedBox(width: 5),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Upcoming: Start Consultation CTA + icon buttons
// // ─────────────────────────────────────────────────────────────────────────────

// class _UpcomingActions extends StatelessWidget {
//   final DoctorAppointmentModel appointment;

//   const _UpcomingActions({required this.appointment});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         // ── Primary CTA ─────────────────────────────────────────────────
//         Expanded(
//           flex: 3,
//           child: GestureDetector(
//             onTap: () {
//               // TODO: navigate to consultation session
//             },
//             child: Container(
//               padding: const EdgeInsets.symmetric(vertical: 11),
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF052C40), Color(0xFF0077B6)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0xFF0077B6).withOpacity(0.28),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: GestureDetector(
//   onTap: () {
//     // Navigator.push(context, MaterialPageRoute(builder: (context)))
//   },
//   child: const Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       Icon(Icons.videocam_rounded, color: Colors.white, size: 15),
//       SizedBox(width: 7),
//       Text(
//         'Start Consultation',
//         style: TextStyle(
//           fontSize: 13,
//           fontWeight: FontWeight.w700,
//           color: Colors.white,
//           letterSpacing: 0.1,
//         ),
//       ),
//     ],
//   ),
// )
//             ),
//           ),
//         ),
//         const SizedBox(width: 8),

//         // ── Message ──────────────────────────────────────────────────────
//         _IconBtn(
//           icon: Icons.chat_bubble_outline_rounded,
//           color: const Color(0xFF0077B6),
//           bgColor: const Color(0xFFE0F4FF),
//           onTap: () {
//             // TODO: open chat
//           },
//         ),
//         const SizedBox(width: 8),

//         // ── View details ─────────────────────────────────────────────────
//         _IconBtn(
//           icon: Icons.info_outline_rounded,
//           color: const Color(0xFF6B7A91),
//           bgColor: const Color(0xFFF0F5FB),
//           onTap: () {
//             // TODO: view appointment details
//           },
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Past: muted completed badge + prescription buttons
// // ─────────────────────────────────────────────────────────────────────────────

// class _PastActions extends StatelessWidget {
//   final DoctorAppointmentModel appointment;

//   const _PastActions({required this.appointment});

//   @override
//   Widget build(BuildContext context) {
//     final isCancelled =
//         (appointment.status ?? '').toLowerCase() == 'cancelled';

//     return Row(
//       children: [
//         // Outcome badge
//         Container(
//           padding:
//               const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
//           decoration: BoxDecoration(
//             color: isCancelled
//                 ? const Color(0xFFFFEBEB)
//                 : const Color(0xFFE8F8F1),
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(
//               color: isCancelled
//                   ? const Color(0xFFD13D3D).withOpacity(0.25)
//                   : const Color(0xFF2D9E6B).withOpacity(0.25),
//             ),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 isCancelled
//                     ? Icons.cancel_outlined
//                     : Icons.task_alt_rounded,
//                 size: 13,
//                 color: isCancelled
//                     ? const Color(0xFFD13D3D)
//                     : const Color(0xFF2D9E6B),
//               ),
//               const SizedBox(width: 5),
//               Text(
//                 isCancelled ? 'Cancelled' : 'Completed',
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w700,
//                   color: isCancelled
//                       ? const Color(0xFFD13D3D)
//                       : const Color(0xFF2D9E6B),
//                 ),
//               ),
//             ],
//           ),
//         ),

//         const Spacer(),

//         // Prescription actions (only for completed)
//         if (!isCancelled)
//           PrescriptionButton(appointment: appointment),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Small square icon button
// // ─────────────────────────────────────────────────────────────────────────────

// class _IconBtn extends StatelessWidget {
//   final IconData icon;
//   final Color color;
//   final Color bgColor;
//   final VoidCallback onTap;

//   const _IconBtn({
//     required this.icon,
//     required this.color,
//     required this.bgColor,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           color: bgColor,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Icon(icon, color: color, size: 18),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:idoc_doctor_side/core/constants/app_const.dart';
import 'package:idoc_doctor_side/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/data/repositories/call_repository.dart';
import 'package:idoc_doctor_side/logic/blocs/call/call_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/call/call_event.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/patient_avatar.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/prescription_button.dart';
import 'package:idoc_doctor_side/presentation/screens/call/video_call_screen.dart';

class AppointmentCard extends StatelessWidget {
  final DoctorAppointmentModel appointment;
  final bool isUpcoming;

  const AppointmentCard({
    required this.appointment,
    required this.isUpcoming,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF052C40).withOpacity(isUpcoming ? 0.07 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          children: [
            _AccentStripe(isUpcoming: isUpcoming, appointment: appointment),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PatientInfoRow(
                    appointment: appointment,
                    isUpcoming: isUpcoming,
                  ),
                  const SizedBox(height: 12),
                  Container(height: 1, color: const Color(0xFFF0F5FB)),
                  const SizedBox(height: 12),
                  _MetaRow(
                    appointment: appointment,
                    isUpcoming: isUpcoming,
                  ),
                  if (isUpcoming) ...[
                    const SizedBox(height: 12),
                    _UpcomingActions(appointment: appointment),
                  ] else ...[
                    const SizedBox(height: 12),
                    _PastActions(appointment: appointment),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Accent stripe
// ─────────────────────────────────────────────────────────────────────────────

class _AccentStripe extends StatelessWidget {
  final bool isUpcoming;
  final DoctorAppointmentModel appointment;

  const _AccentStripe({required this.isUpcoming, required this.appointment});

  @override
  Widget build(BuildContext context) {
    List<Color> colors;
    if (!isUpcoming) {
      final status = (appointment.status ?? 'completed').toLowerCase();
      colors = switch (status) {
        'cancelled' => [
            const Color(0xFFD13D3D).withOpacity(0.5),
            const Color(0xFFD13D3D).withOpacity(0.2),
          ],
        _ => [
            const Color(0xFF2D9E6B).withOpacity(0.6),
            const Color(0xFF2D9E6B).withOpacity(0.2),
          ],
      };
    } else {
      colors = [const Color(0xFF052C40), const Color(0xFF00B4D8)];
    }

    return Container(
      height: 3,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Patient info row
// ─────────────────────────────────────────────────────────────────────────────

class _PatientInfoRow extends StatelessWidget {
  final DoctorAppointmentModel appointment;
  final bool isUpcoming;

  const _PatientInfoRow({
    required this.appointment,
    required this.isUpcoming,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PatientAvatar(
          name: appointment.patientName,
          imageUrl: appointment.profileImageUrl,
          isUpcoming: isUpcoming,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appointment.patientName,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                  color: isUpcoming
                      ? const Color(0xFF1A2332)
                      : const Color(0xFF4A5568),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              _ConsultationTypeBadge(
                type: 'Consultation',
                isUpcoming: isUpcoming,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        _StatusBadge(
          status: appointment.status ??
              (isUpcoming ? 'confirmed' : 'completed'),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Consultation type badge
// ─────────────────────────────────────────────────────────────────────────────

class _ConsultationTypeBadge extends StatelessWidget {
  final String type;
  final bool isUpcoming;

  const _ConsultationTypeBadge({required this.type, required this.isUpcoming});

  @override
  Widget build(BuildContext context) {
    final isVideo = type.toLowerCase().contains('video');
    final Color color;
    if (!isUpcoming) {
      color = const Color(0xFF9DAFC2);
    } else if (isVideo) {
      color = const Color(0xFF7B2FF7);
    } else {
      color = const Color(0xFF0077B6);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isVideo
              ? Icons.videocam_outlined
              : Icons.person_outline_rounded,
          size: 12,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          type,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Status badge
// ─────────────────────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (Color fg, Color bg, IconData icon, String label) =
        switch (status.toLowerCase()) {
      'confirmed' => (
          const Color(0xFF0096C7),
          const Color(0xFFE0F4FF),
          Icons.check_circle_outline_rounded,
          'Confirmed',
        ),
      'pending' => (
          const Color(0xFFE07B00),
          const Color(0xFFFFF3E0),
          Icons.access_time_rounded,
          'Pending',
        ),
      'completed' => (
          const Color(0xFF2D9E6B),
          const Color(0xFFE8F8F1),
          Icons.task_alt_rounded,
          'Done',
        ),
      'cancelled' => (
          const Color(0xFFD13D3D),
          const Color(0xFFFFEBEB),
          Icons.cancel_outlined,
          'Cancelled',
        ),
      _ => (
          const Color(0xFF6B7A91),
          const Color(0xFFEEF2F7),
          Icons.info_outline_rounded,
          status,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Meta row: time + date chips
// ─────────────────────────────────────────────────────────────────────────────

class _MetaRow extends StatelessWidget {
  final DoctorAppointmentModel appointment;
  final bool isUpcoming;

  const _MetaRow({required this.appointment, required this.isUpcoming});

  String _formatTime(String raw) {
    try {
      final parts = raw.split(':');
      int h = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final period = h >= 12 ? 'PM' : 'AM';
      if (h > 12) h -= 12;
      if (h == 0) h = 12;
      return '$h:${m.toString().padLeft(2, '0')} $period';
    } catch (_) {
      return raw;
    }
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final now = DateTime.now();
    if (d.year == now.year && d.month == now.month && d.day == now.day) {
      return 'Today';
    }
    return '${months[d.month - 1]} ${d.day}';
  }

  @override
  Widget build(BuildContext context) {
    final timeColor =
        isUpcoming ? const Color(0xFF0077B6) : const Color(0xFF6B7A91);
    final timeBg =
        isUpcoming ? const Color(0xFFE0F4FF) : const Color(0xFFF0F5FB);

    return Row(
      children: [
        _InfoChip(
          icon: Icons.schedule_rounded,
          label: _formatTime(appointment.startTime),
          color: timeColor,
          bgColor: timeBg,
        ),
        const SizedBox(width: 8),
        _InfoChip(
          icon: Icons.calendar_today_rounded,
          label: _formatDate(appointment.appointmentDate),
          color: const Color(0xFF6B7A91),
          bgColor: const Color(0xFFF0F5FB),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Upcoming: Start Consultation CTA + icon buttons
// ─────────────────────────────────────────────────────────────────────────────

class _UpcomingActions extends StatelessWidget {
  final DoctorAppointmentModel appointment;

  const _UpcomingActions({required this.appointment});

  Future<void> _startVideoCall(BuildContext context) async {
    // 1. Request camera + mic permissions
    final statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    final granted = statuses.values.every((s) => s.isGranted);

    // 2. Guard against widget unmount during async gap
    if (!context.mounted) return;

    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera and microphone permissions are required.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // 3. Navigate to video call screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => CallBloc(
            repository: CallRepository(),
            channelName: appointment.appointmentId,
            doctorId: appointment.doctorId,
            patientUserId: appointment.userId, // patient's Firebase Auth UID
            doctorName: appointment.doctorName ?? 'Doctor',
            patientName: appointment.patientName,
            doctorProfileImageUrl: appointment.doctorProfileImageUrl,
          )..add(
              CallJoinRequested(
                channelName: appointment.appointmentId,
                appId: AppConstants.agoraAppId,
              ),
            ),
          child: VideoCallScreen(
            channelName: appointment.appointmentId,
            patientName: appointment.patientName,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ── Primary CTA ──────────────────────────────────────────────────
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: () => _startVideoCall(context),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF052C40), Color(0xFF0077B6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0077B6).withOpacity(0.28),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.videocam_rounded, color: Colors.white, size: 15),
                  SizedBox(width: 7),
                  Text(
                    'Start Consultation',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // ── Message ───────────────────────────────────────────────────────
        _IconBtn(
          icon: Icons.chat_bubble_outline_rounded,
          color: const Color(0xFF0077B6),
          bgColor: const Color(0xFFE0F4FF),
          onTap: () {
            // TODO: open chat
          },
        ),
        const SizedBox(width: 8),

        // ── View details ──────────────────────────────────────────────────
        _IconBtn(
          icon: Icons.info_outline_rounded,
          color: const Color(0xFF6B7A91),
          bgColor: const Color(0xFFF0F5FB),
          onTap: () {
            // TODO: view appointment details
          },
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Past: outcome badge + prescription button
// ─────────────────────────────────────────────────────────────────────────────

class _PastActions extends StatelessWidget {
  final DoctorAppointmentModel appointment;

  const _PastActions({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final isCancelled =
        (appointment.status ?? '').toLowerCase() == 'cancelled';

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          decoration: BoxDecoration(
            color: isCancelled
                ? const Color(0xFFFFEBEB)
                : const Color(0xFFE8F8F1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isCancelled
                  ? const Color(0xFFD13D3D).withOpacity(0.25)
                  : const Color(0xFF2D9E6B).withOpacity(0.25),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isCancelled
                    ? Icons.cancel_outlined
                    : Icons.task_alt_rounded,
                size: 13,
                color: isCancelled
                    ? const Color(0xFFD13D3D)
                    : const Color(0xFF2D9E6B),
              ),
              const SizedBox(width: 5),
              Text(
                isCancelled ? 'Cancelled' : 'Completed',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isCancelled
                      ? const Color(0xFFD13D3D)
                      : const Color(0xFF2D9E6B),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        if (!isCancelled) PrescriptionButton(appointment: appointment),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Small square icon button
// ─────────────────────────────────────────────────────────────────────────────

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _IconBtn({
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}