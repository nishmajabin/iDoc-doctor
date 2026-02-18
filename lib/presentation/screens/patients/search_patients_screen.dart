// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:idoc_doctor_side/data/models/appointment_model.dart';
// import 'package:idoc_doctor_side/data/models/doctor_model.dart';
// import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_bloc.dart';
// import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_state.dart';
// import 'package:idoc_doctor_side/presentation/screens/patients/patient_detail_screen.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // Design tokens — shared with PatientDetailScreen for cohesive palette
// // ─────────────────────────────────────────────────────────────────────────────

// class _C {
//   static const primary = Color(0xFF0077B6);
//   static const primaryLight = Color(0xFF90E0EF);
//   static const primarySurface = Color(0xFFE8F4FD);
//   static const accent = Color(0xFF00B4D8);
//   static const confirmed = Color(0xFF0096C7);
//   static const pending = Color(0xFFE07B00);
//   static const pendingSurface = Color(0xFFFFF3E0);
//   static const completed = Color(0xFF2D9E6B);
//   static const completedSurface = Color(0xFFE8F8F1);
//   static const cancelled = Color(0xFFD13D3D);
//   static const cancelledSurface = Color(0xFFFFEBEB);
//   static const bgTop = Color(0xFFE0F4FF); // soft sky gradient top
//   static const bgBase = Color(0xFFF2F8FF); // very light cool base
//   static const cardBg = Colors.white;
//   static const divider = Color(0xFFEEF2F7);
//   static const textPrimary = Color(0xFF1A2332);
//   static const textSecondary = Color(0xFF6B7A91);
//   static const textMuted = Color(0xFFADB8C9);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Status helper — reusable across screens
// // ─────────────────────────────────────────────────────────────────────────────

// class _StatusConfig {
//   final String label;
//   final Color color;
//   final Color surface;

//   const _StatusConfig(this.label, this.color, this.surface);

//   factory _StatusConfig.from(String status) {
//     switch (status.toLowerCase()) {
//       case 'confirmed':
//         return const _StatusConfig(
//           'Confirmed',
//           _C.confirmed,
//           _C.primarySurface,
//         );
//       case 'pending':
//         return const _StatusConfig('Pending', _C.pending, _C.pendingSurface);
//       case 'completed':
//         return const _StatusConfig(
//           'Completed',
//           _C.completed,
//           _C.completedSurface,
//         );
//       case 'cancelled':
//         return const _StatusConfig(
//           'Cancelled',
//           _C.cancelled,
//           _C.cancelledSurface,
//         );
//       default:
//         return _StatusConfig(
//           status.isEmpty
//               ? 'Unknown'
//               : status[0].toUpperCase() + status.substring(1).toLowerCase(),
//           _C.textMuted,
//           _C.bgBase,
//         );
//     }
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Business logic helpers (unchanged)
// // ─────────────────────────────────────────────────────────────────────────────

// String _resolveStatus(DoctorAppointmentModel a) {
//   if (a.status.toLowerCase() == 'completed') return 'completed';
//   if (a.status.toLowerCase() == 'cancelled') return 'cancelled';
//   try {
//     final parts = a.endTime.split(':');
//     final end = DateTime(
//       a.appointmentDate.year,
//       a.appointmentDate.month,
//       a.appointmentDate.day,
//       int.parse(parts[0]),
//       int.parse(parts[1]),
//     );
//     if (end.isBefore(DateTime.now())) return 'completed';
//   } catch (_) {}
//   return a.status.toLowerCase();
// }

// String _formatTime(String t) {
//   try {
//     final p = t.split(':');
//     int h = int.parse(p[0]);
//     final m = int.parse(p[1]);
//     final ampm = h >= 12 ? 'PM' : 'AM';
//     h = h % 12;
//     if (h == 0) h = 12;
//     return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} $ampm';
//   } catch (_) {
//     return t;
//   }
// }

// String _formatDate(DateTime d) {
//   const months = [
//     'Jan',
//     'Feb',
//     'Mar',
//     'Apr',
//     'May',
//     'Jun',
//     'Jul',
//     'Aug',
//     'Sep',
//     'Oct',
//     'Nov',
//     'Dec',
//   ];
//   return '${months[d.month - 1]} ${d.day}, ${d.year}';
// }

// String _initials(String name) {
//   final parts = name.trim().split(' ');
//   if (parts.isEmpty) return '?';
//   if (parts.length == 1) return parts[0][0].toUpperCase();
//   return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Screen
// // ─────────────────────────────────────────────────────────────────────────────

// class SearchPatientsScreen extends StatefulWidget {
//   const SearchPatientsScreen({super.key});

//   @override
//   State<SearchPatientsScreen> createState() => _SearchPatientsScreenState();
// }

// class _SearchPatientsScreenState extends State<SearchPatientsScreen>
//     with SingleTickerProviderStateMixin {
//   final TextEditingController _searchController = TextEditingController();
//   final FocusNode _searchFocusNode = FocusNode();
//   List<DoctorAppointmentModel> _searchResults = [];
//   List<DoctorAppointmentModel> _allAppointments = [];
//   bool _isSearching = false;


//   late final AnimationController _fadeCtrl;
//   late final Animation<double> _fadeAnim;

//   @override
//   void initState() {
//     super.initState();
//     _fadeCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//     _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);

//     _searchController.addListener(_onSearchChanged);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _searchFocusNode.requestFocus();
//     });
//   }

//   @override
//   void dispose() {
//     _fadeCtrl.dispose();
//     _searchController.dispose();
//     _searchFocusNode.dispose();
//     super.dispose();
//   }

//   void _onSearchChanged() {
//     final query = _searchController.text.trim().toLowerCase();

//     if (query.isEmpty) {
//       _fadeCtrl.reverse();
//       setState(() {
//         _searchResults = [];
//         _isSearching = false;
//       });
//       return;
//     }

//     setState(() {
//       _isSearching = true;
//       _searchResults =
//           _allAppointments.where((a) {
//             return a.patientName.toLowerCase().contains(query);
//           }).toList();
//     });
//     _fadeCtrl.forward(from: 0);
//   }

//   void _navigateToPatientDetail(DoctorAppointmentModel appointment) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder:
//             (_) => PatientDetailScreen(
//               appointment: appointment,
//               currentDoctor: doctir, // your DoctorModel from auth/BLoC
//             ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.dark.copyWith(
//         statusBarColor: Colors.transparent,
//       ),
//       child: Scaffold(
//         backgroundColor: _C.bgTop,
//         body: Column(
//           children: [
//             _SearchHeader(
//               controller: _searchController,
//               focusNode: _searchFocusNode,
//             ),
//             Expanded(
//               child: Container(
//                 width: double.infinity,
//                 decoration: const BoxDecoration(
//                   color: _C.bgBase,
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: const BorderRadius.vertical(
//                     top: Radius.circular(28),
//                   ),
//                   child: BlocBuilder<
//                     DoctorAppointmentBloc,
//                     DoctorAppointmentState
//                   >(
//                     builder: (context, state) {
//                       if (state is DoctorAppointmentLoaded) {
//                         _allAppointments = [...state.upcoming, ...state.past];

//                         if (!_isSearching && _searchController.text.isEmpty) {
//                           return _buildIdleState();
//                         }

//                         if (_isSearching && _searchResults.isEmpty) {
//                           return _buildNoResultsState();
//                         }

//                         return _buildResultsList();
//                       }

//                       if (state is DoctorAppointmentLoading) {
//                         return const _LoadingState();
//                       }

//                       return _buildIdleState();
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ── Idle (pre-search) state ─────────────────────────────────────────
//   Widget _buildIdleState() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 40),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 88,
//               height: 88,
//               decoration: BoxDecoration(
//                 color: _C.primarySurface,
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.person_search_rounded,
//                 size: 42,
//                 color: _C.primary,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'Find a Patient',
//               style: GoogleFonts.poppins(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w700,
//                 color: _C.textPrimary,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Search by patient name to find their appointment details',
//               textAlign: TextAlign.center,
//               style: GoogleFonts.poppins(
//                 fontSize: 14,
//                 color: _C.textSecondary,
//                 height: 1.6,
//               ),
//             ),
//             const SizedBox(height: 24),
//             // Search tip
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               alignment: WrapAlignment.center,
//               children: const [
//                 _TipChip(icon: Icons.person_outline, label: 'First name'),
//                 _TipChip(icon: Icons.person_outline, label: 'Last name'),
//                 _TipChip(icon: Icons.person_outline, label: 'Full name'),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ── No results state ────────────────────────────────────────────────
//   Widget _buildNoResultsState() {
//     final query = _searchController.text.trim();
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 40),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 88,
//               height: 88,
//               decoration: const BoxDecoration(
//                 color: Color(0xFFFFF3E0),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.search_off_rounded,
//                 size: 42,
//                 color: _C.pending,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'No Results Found',
//               style: GoogleFonts.poppins(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w700,
//                 color: _C.textPrimary,
//               ),
//             ),
//             const SizedBox(height: 8),
//             RichText(
//               textAlign: TextAlign.center,
//               text: TextSpan(
//                 style: GoogleFonts.poppins(
//                   fontSize: 14,
//                   color: _C.textSecondary,
//                   height: 1.6,
//                 ),
//                 children: [
//                   const TextSpan(text: 'No patient found matching '),
//                   TextSpan(
//                     text: '"$query"',
//                     style: GoogleFonts.poppins(
//                       fontWeight: FontWeight.w600,
//                       color: _C.textPrimary,
//                     ),
//                   ),
//                   const TextSpan(
//                     text: '.\nTry searching with a different name.',
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ── Results list ────────────────────────────────────────────────────
//   Widget _buildResultsList() {
//     return FadeTransition(
//       opacity: _fadeAnim,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
//             child: Row(
//               children: [
//                 Text(
//                   '${_searchResults.length} result${_searchResults.length == 1 ? '' : 's'}',
//                   style: GoogleFonts.poppins(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                     color: _C.textSecondary,
//                   ),
//                 ),
//                 const Spacer(),
//                 Text(
//                   'Tap a card to view details',
//                   style: GoogleFonts.poppins(fontSize: 12, color: _C.textMuted),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
//               physics: const BouncingScrollPhysics(),
//               itemCount: _searchResults.length,
//               itemBuilder: (context, index) {
//                 return _PatientCard(
//                   appointment: _searchResults[index],
//                   onTap: () => _navigateToPatientDetail(_searchResults[index]),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Search header — gradient background with glass search bar
// // ─────────────────────────────────────────────────────────────────────────────

// class _SearchHeader extends StatelessWidget {
//   final TextEditingController controller;
//   final FocusNode focusNode;

//   const _SearchHeader({required this.controller, required this.focusNode});

//   @override
//   Widget build(BuildContext context) {
//     final topPad = MediaQuery.of(context).padding.top;
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.fromLTRB(16, topPad + 12, 16, 20),
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFF0077B6), Color(0xFF00B4D8)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Back + title row
//           Row(
//             children: [
//               GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   width: 38,
//                   height: 38,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.18),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: Colors.white.withOpacity(0.25),
//                       width: 1,
//                     ),
//                   ),
//                   child: const Icon(
//                     Icons.arrow_back_ios_new_rounded,
//                     color: Colors.white,
//                     size: 17,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 14),
//               Text(
//                 'Search Patients',
//                 style: GoogleFonts.poppins(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.white,
//                   letterSpacing: -0.3,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           // Search bar
//           ValueListenableBuilder<TextEditingValue>(
//             valueListenable: controller,
//             builder: (_, value, __) {
//               return Container(
//                 height: 52,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.12),
//                       blurRadius: 16,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: TextField(
//                   controller: controller,
//                   focusNode: focusNode,
//                   style: GoogleFonts.poppins(
//                     fontSize: 14,
//                     color: _C.textPrimary,
//                   ),
//                   decoration: InputDecoration(
//                     hintText: 'Search by patient name…',
//                     hintStyle: GoogleFonts.poppins(
//                       fontSize: 13,
//                       color: _C.textMuted,
//                     ),
//                     prefixIcon: Padding(
//                       padding: const EdgeInsets.only(left: 14, right: 8),
//                       child: Icon(
//                         Icons.search_rounded,
//                         color:
//                             value.text.isNotEmpty ? _C.primary : _C.textMuted,
//                         size: 22,
//                       ),
//                     ),
//                     prefixIconConstraints: const BoxConstraints(
//                       minWidth: 48,
//                       minHeight: 48,
//                     ),
//                     suffixIcon:
//                         value.text.isNotEmpty
//                             ? IconButton(
//                               icon: const Icon(
//                                 Icons.cancel_rounded,
//                                 color: _C.textMuted,
//                                 size: 20,
//                               ),
//                               onPressed: controller.clear,
//                               splashRadius: 18,
//                             )
//                             : null,
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 4,
//                       vertical: 15,
//                     ),
//                   ),
//                   textInputAction: TextInputAction.search,
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Patient result card — premium design with rich shadows
// // ─────────────────────────────────────────────────────────────────────────────

// class _PatientCard extends StatelessWidget {
//   final DoctorAppointmentModel appointment;
//   final VoidCallback onTap;

//   const _PatientCard({required this.appointment, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     final status = _resolveStatus(appointment);
//     final statusConfig = _StatusConfig.from(status);
//     final isPast = status == 'completed' || status == 'cancelled';

//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 14),
//         decoration: BoxDecoration(
//           color: _C.cardBg,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: _C.divider, width: 1),
//           boxShadow: [
//             // Ambient shadow
//             BoxShadow(
//               color: const Color(0xFF0077B6).withOpacity(0.07),
//               blurRadius: 20,
//               offset: const Offset(0, 6),
//             ),
//             // Key shadow — gives the "lifted card" feel
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 6,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // ── Top: avatar + info + status badge ───────────────────
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Avatar
//                   _Avatar(
//                     name: appointment.patientName,
//                     imageUrl: appointment.profileImageUrl,
//                     isPast: isPast,
//                   ),
//                   const SizedBox(width: 14),
//                   // Name + phone
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           appointment.patientName,
//                           style: GoogleFonts.poppins(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w700,
//                             color: _C.textPrimary,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         if (appointment.contactNumber.isNotEmpty) ...[
//                           const SizedBox(height: 3),
//                           Row(
//                             children: [
//                               const Icon(
//                                 Icons.phone_outlined,
//                                 size: 13,
//                                 color: _C.textMuted,
//                               ),
//                               const SizedBox(width: 4),
//                               Flexible(
//                                 child: Text(
//                                   appointment.contactNumber,
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 12,
//                                     color: _C.textSecondary,
//                                   ),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   // Status badge
//                   _StatusBadge(config: statusConfig),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 12),

//             // ── Bottom: date/time strip ──────────────────────────────
//             Container(
//               margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//               decoration: BoxDecoration(
//                 color: isPast ? const Color(0xFFF5F7FA) : _C.primarySurface,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.calendar_month_rounded,
//                     size: 15,
//                     color: isPast ? _C.textMuted : _C.primary,
//                   ),
//                   const SizedBox(width: 6),
//                   Flexible(
//                     child: Text(
//                       _formatDate(appointment.appointmentDate),
//                       style: GoogleFonts.poppins(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                         color: isPast ? _C.textSecondary : _C.primary,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   Container(
//                     width: 1,
//                     height: 12,
//                     margin: const EdgeInsets.symmetric(horizontal: 10),
//                     color: isPast ? _C.divider : _C.primary.withOpacity(0.25),
//                   ),
//                   Icon(
//                     Icons.schedule_rounded,
//                     size: 15,
//                     color: isPast ? _C.textMuted : _C.accent,
//                   ),
//                   const SizedBox(width: 6),
//                   Flexible(
//                     child: Text(
//                       _formatTime(appointment.startTime),
//                       style: GoogleFonts.poppins(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                         color: isPast ? _C.textSecondary : _C.textPrimary,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   const Spacer(),
//                   // Arrow indicator
//                   Icon(
//                     Icons.chevron_right_rounded,
//                     size: 18,
//                     color: isPast ? _C.textMuted : _C.primary,
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

// // ─────────────────────────────────────────────────────────────────────────────
// // Avatar — initials fallback, tinted for past appointments
// // ─────────────────────────────────────────────────────────────────────────────

// class _Avatar extends StatelessWidget {
//   final String name;
//   final String? imageUrl;
//   final bool isPast;

//   const _Avatar({
//     required this.name,
//     required this.imageUrl,
//     required this.isPast,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
//     final bgColor =
//         isPast ? const Color(0xFFCDD5DF) : _C.primaryLight.withOpacity(0.4);
//     final fgColor = isPast ? _C.textSecondary : _C.primary;

//     return Container(
//       width: 52,
//       height: 52,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: bgColor,
//         image:
//             hasImage
//                 ? DecorationImage(
//                   image: NetworkImage(imageUrl!),
//                   fit: BoxFit.cover,
//                 )
//                 : null,
//         boxShadow: [
//           BoxShadow(
//             color: (isPast ? Colors.black : _C.primary).withOpacity(0.12),
//             blurRadius: 8,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child:
//           hasImage
//               ? null
//               : Center(
//                 child: Text(
//                   _initials(name),
//                   style: GoogleFonts.poppins(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w700,
//                     color: fgColor,
//                   ),
//                 ),
//               ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Status badge pill
// // ─────────────────────────────────────────────────────────────────────────────

// class _StatusBadge extends StatelessWidget {
//   final _StatusConfig config;

//   const _StatusBadge({required this.config});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//         color: config.surface,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: config.color.withOpacity(0.25), width: 1),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 6,
//             height: 6,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: config.color,
//             ),
//           ),
//           const SizedBox(width: 5),
//           Text(
//             config.label,
//             style: GoogleFonts.poppins(
//               fontSize: 11,
//               fontWeight: FontWeight.w600,
//               color: config.color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Tip chip — shown in idle state
// // ─────────────────────────────────────────────────────────────────────────────

// class _TipChip extends StatelessWidget {
//   final IconData icon;
//   final String label;

//   const _TipChip({required this.icon, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//       decoration: BoxDecoration(
//         color: _C.primarySurface,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: _C.primary.withOpacity(0.15)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 14, color: _C.primary),
//           const SizedBox(width: 6),
//           Text(
//             label,
//             style: GoogleFonts.poppins(
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//               color: _C.primary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Loading state
// // ─────────────────────────────────────────────────────────────────────────────

// class _LoadingState extends StatelessWidget {
//   const _LoadingState();

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const SizedBox(
//             width: 36,
//             height: 36,
//             child: CircularProgressIndicator(strokeWidth: 3, color: _C.primary),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'Loading appointments…',
//             style: GoogleFonts.poppins(fontSize: 14, color: _C.textSecondary),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_state.dart';
import 'package:idoc_doctor_side/presentation/screens/patients/patient_detail_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Design tokens
// ─────────────────────────────────────────────────────────────────────────────

class _C {
  static const primary = Color(0xFF0077B6);
  static const primaryLight = Color(0xFF90E0EF);
  static const primarySurface = Color(0xFFE8F4FD);
  static const accent = Color(0xFF00B4D8);
  static const confirmed = Color(0xFF0096C7);
  static const pending = Color(0xFFE07B00);
  static const pendingSurface = Color(0xFFFFF3E0);
  static const completed = Color(0xFF2D9E6B);
  static const completedSurface = Color(0xFFE8F8F1);
  static const cancelled = Color(0xFFD13D3D);
  static const cancelledSurface = Color(0xFFFFEBEB);
  static const bgTop = Color(0xFFE0F4FF);
  static const bgBase = Color(0xFFF2F8FF);
  static const cardBg = Colors.white;
  static const divider = Color(0xFFEEF2F7);
  static const textPrimary = Color(0xFF1A2332);
  static const textSecondary = Color(0xFF6B7A91);
  static const textMuted = Color(0xFFADB8C9);
}

// ─────────────────────────────────────────────────────────────────────────────
// Status helper
// ─────────────────────────────────────────────────────────────────────────────

class _StatusConfig {
  final String label;
  final Color color;
  final Color surface;

  const _StatusConfig(this.label, this.color, this.surface);

  factory _StatusConfig.from(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return const _StatusConfig('Confirmed', _C.confirmed, _C.primarySurface);
      case 'pending':
        return const _StatusConfig('Pending', _C.pending, _C.pendingSurface);
      case 'completed':
        return const _StatusConfig('Completed', _C.completed, _C.completedSurface);
      case 'cancelled':
        return const _StatusConfig('Cancelled', _C.cancelled, _C.cancelledSurface);
      default:
        return _StatusConfig(
          status.isEmpty
              ? 'Unknown'
              : status[0].toUpperCase() + status.substring(1).toLowerCase(),
          _C.textMuted,
          _C.bgBase,
        );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

String _resolveStatus(DoctorAppointmentModel a) {
  if (a.status.toLowerCase() == 'completed') return 'completed';
  if (a.status.toLowerCase() == 'cancelled') return 'cancelled';
  try {
    final parts = a.endTime.split(':');
    final end = DateTime(
      a.appointmentDate.year,
      a.appointmentDate.month,
      a.appointmentDate.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
    if (end.isBefore(DateTime.now())) return 'completed';
  } catch (_) {}
  return a.status.toLowerCase();
}

String _formatTime(String t) {
  try {
    final p = t.split(':');
    int h = int.parse(p[0]);
    final m = int.parse(p[1]);
    final ampm = h >= 12 ? 'PM' : 'AM';
    h = h % 12;
    if (h == 0) h = 12;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} $ampm';
  } catch (_) {
    return t;
  }
}

String _formatDate(DateTime d) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${months[d.month - 1]} ${d.day}, ${d.year}';
}

String _initials(String name) {
  final parts = name.trim().split(' ');
  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts[0][0].toUpperCase();
  return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
}

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────

class SearchPatientsScreen extends StatefulWidget {
  final DoctorModel currentDoctor; // ← added

  const SearchPatientsScreen({
    super.key,
    required this.currentDoctor, // ← added
  });

  @override
  State<SearchPatientsScreen> createState() => _SearchPatientsScreenState();
}

class _SearchPatientsScreenState extends State<SearchPatientsScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<DoctorAppointmentModel> _searchResults = [];
  List<DoctorAppointmentModel> _allAppointments = [];
  bool _isSearching = false;

  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);

    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      _fadeCtrl.reverse();
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchResults = _allAppointments
          .where((a) => a.patientName.toLowerCase().contains(query))
          .toList();
    });
    _fadeCtrl.forward(from: 0);
  }

  void _navigateToPatientDetail(DoctorAppointmentModel appointment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PatientDetailScreen(
          appointment: appointment,
          currentDoctor: widget.currentDoctor, // ← fixed (was: doctir)
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: _C.bgTop,
        body: Column(
          children: [
            _SearchHeader(
              controller: _searchController,
              focusNode: _searchFocusNode,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: _C.bgBase,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  child: BlocBuilder<DoctorAppointmentBloc,
                      DoctorAppointmentState>(
                    builder: (context, state) {
                      if (state is DoctorAppointmentLoaded) {
                        _allAppointments = [
                          ...state.upcoming,
                          ...state.past,
                        ];

                        if (!_isSearching &&
                            _searchController.text.isEmpty) {
                          return _buildIdleState();
                        }

                        if (_isSearching && _searchResults.isEmpty) {
                          return _buildNoResultsState();
                        }

                        return _buildResultsList();
                      }

                      if (state is DoctorAppointmentLoading) {
                        return const _LoadingState();
                      }

                      return _buildIdleState();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Idle state ──────────────────────────────────────────────────────
  Widget _buildIdleState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: _C.primarySurface,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_search_rounded,
                size: 42,
                color: _C.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Find a Patient',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _C.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Search by patient name to find their appointment details',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: _C.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: const [
                _TipChip(icon: Icons.person_outline, label: 'First name'),
                _TipChip(icon: Icons.person_outline, label: 'Last name'),
                _TipChip(icon: Icons.person_outline, label: 'Full name'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── No results state ────────────────────────────────────────────────
  Widget _buildNoResultsState() {
    final query = _searchController.text.trim();
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF3E0),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 42,
                color: _C.pending,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Results Found',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _C.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: _C.textSecondary,
                  height: 1.6,
                ),
                children: [
                  const TextSpan(text: 'No patient found matching '),
                  TextSpan(
                    text: '"$query"',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: _C.textPrimary,
                    ),
                  ),
                  const TextSpan(
                    text: '.\nTry searching with a different name.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Results list ────────────────────────────────────────────────────
  Widget _buildResultsList() {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
            child: Row(
              children: [
                Text(
                  '${_searchResults.length} result${_searchResults.length == 1 ? '' : 's'}',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _C.textSecondary,
                  ),
                ),
                const Spacer(),
                Text(
                  'Tap a card to view details',
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: _C.textMuted),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              physics: const BouncingScrollPhysics(),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return _PatientCard(
                  appointment: _searchResults[index],
                  onTap: () =>
                      _navigateToPatientDetail(_searchResults[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Search header
// ─────────────────────────────────────────────────────────────────────────────

class _SearchHeader extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const _SearchHeader({required this.controller, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, topPad + 12, 16, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0077B6), Color(0xFF00B4D8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.25),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 17,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                'Search Patients',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, __) {
              return Container(
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: _C.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search by patient name…',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 13,
                      color: _C.textMuted,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 14, right: 8),
                      child: Icon(
                        Icons.search_rounded,
                        color: value.text.isNotEmpty
                            ? _C.primary
                            : _C.textMuted,
                        size: 22,
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 48,
                    ),
                    suffixIcon: value.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.cancel_rounded,
                              color: _C.textMuted,
                              size: 20,
                            ),
                            onPressed: controller.clear,
                            splashRadius: 18,
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 15,
                    ),
                  ),
                  textInputAction: TextInputAction.search,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Patient result card
// ─────────────────────────────────────────────────────────────────────────────

class _PatientCard extends StatelessWidget {
  final DoctorAppointmentModel appointment;
  final VoidCallback onTap;

  const _PatientCard({required this.appointment, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final status = _resolveStatus(appointment);
    final statusConfig = _StatusConfig.from(status);
    final isPast = status == 'completed' || status == 'cancelled';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: _C.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _C.divider, width: 1),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0077B6).withOpacity(0.07),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Avatar(
                    name: appointment.patientName,
                    imageUrl: appointment.profileImageUrl,
                    isPast: isPast,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          appointment.patientName,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _C.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (appointment.contactNumber.isNotEmpty) ...[
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(
                                Icons.phone_outlined,
                                size: 13,
                                color: _C.textMuted,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  appointment.contactNumber,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: _C.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  _StatusBadge(config: statusConfig),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isPast
                    ? const Color(0xFFF5F7FA)
                    : _C.primarySurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    size: 15,
                    color: isPast ? _C.textMuted : _C.primary,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      _formatDate(appointment.appointmentDate),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isPast ? _C.textSecondary : _C.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 12,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    color: isPast
                        ? _C.divider
                        : _C.primary.withOpacity(0.25),
                  ),
                  Icon(
                    Icons.schedule_rounded,
                    size: 15,
                    color: isPast ? _C.textMuted : _C.accent,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      _formatTime(appointment.startTime),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isPast
                            ? _C.textSecondary
                            : _C.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: isPast ? _C.textMuted : _C.primary,
                  ),
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
// Sub-widgets (unchanged from original)
// ─────────────────────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final bool isPast;

  const _Avatar({
    required this.name,
    required this.imageUrl,
    required this.isPast,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    final bgColor = isPast
        ? const Color(0xFFCDD5DF)
        : _C.primaryLight.withOpacity(0.4);
    final fgColor = isPast ? _C.textSecondary : _C.primary;

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
        image: hasImage
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color:
                (isPast ? Colors.black : _C.primary).withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: hasImage
          ? null
          : Center(
              child: Text(
                _initials(name),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: fgColor,
                ),
              ),
            ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final _StatusConfig config;

  const _StatusBadge({required this.config});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: config.surface,
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: config.color.withOpacity(0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: config.color,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            config.label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: config.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _TipChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TipChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: _C.primarySurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _C.primary.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: _C.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _C.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
                strokeWidth: 3, color: _C.primary),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading appointments…',
            style: GoogleFonts.poppins(
                fontSize: 14, color: _C.textSecondary),
          ),
        ],
      ),
    );
  }
}