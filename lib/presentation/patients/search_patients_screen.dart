import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_state.dart';
import 'package:idoc_doctor_side/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/presentation/patients/patient_detail_screen.dart';

class SearchPatientsScreen extends StatefulWidget {
  const SearchPatientsScreen({super.key});

  @override
  State<SearchPatientsScreen> createState() => _SearchPatientsScreenState();
}

class _SearchPatientsScreenState extends State<SearchPatientsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<DoctorAppointmentModel> _searchResults = [];
  List<DoctorAppointmentModel> _allAppointments = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    // Auto-focus search field when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchResults = _allAppointments.where((appointment) {
        final patientName = appointment.patientName.toLowerCase();
        final contactNumber = appointment.contactNumber.toLowerCase();
        final appointmentId = appointment.appointmentId.toLowerCase();
        
        return patientName.contains(query) ||
               contactNumber.contains(query) ||
               appointmentId.contains(query);
      }).toList();
    });
  }

  void _navigateToPatientDetail(DoctorAppointmentModel appointment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientDetailScreen(appointment: appointment),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB3E5FC),
      body: SafeArea(
        child: Column(
          children: [
            // ─── Search Header ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black87,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Search field
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        style: const TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          hintText: 'Search by name, phone, or ID...',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 15,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.black54,
                            size: 24,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.black54,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ─── Search Results ─────────────────────────────────────
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: BlocBuilder<DoctorAppointmentBloc, DoctorAppointmentState>(
                  builder: (context, state) {
                    if (state is DoctorAppointmentLoaded) {
                      // Combine all appointments for searching
                      _allAppointments = [
                        ...state.upcoming,
                        ...state.past,
                      ];

                      // Show initial state
                      if (!_isSearching && _searchController.text.isEmpty) {
                        return _buildEmptySearchState();
                      }

                      // Show search results
                      if (_searchResults.isEmpty && _isSearching) {
                        return _buildNoResultsState();
                      }

                      return _buildSearchResults();
                    }

                    if (state is DoctorAppointmentLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return _buildEmptySearchState();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Empty search state (before user types) ─────────────────────────
  Widget _buildEmptySearchState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Search for Patients',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Search by patient name, phone number, or appointment ID',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── No results state ───────────────────────────────────────────────
  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No Results Found',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Try searching with a different name, phone number, or ID',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Search results list ────────────────────────────────────────────
  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final appointment = _searchResults[index];
        return _SearchResultCard(
          appointment: appointment,
          onTap: () => _navigateToPatientDetail(appointment),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Search Result Card - WITH DYNAMIC STATUS BASED ON APPOINTMENT TIME
// ═══════════════════════════════════════════════════════════════════════════
class _SearchResultCard extends StatelessWidget {
  final DoctorAppointmentModel appointment;
  final VoidCallback onTap;

  const _SearchResultCard({
    required this.appointment,
    required this.onTap,
  });

  /// Determines the actual display status based on appointment time
  String _getDisplayStatus() {
    // If already completed or cancelled in DB, show that
    if (appointment.status.toLowerCase() == 'completed') {
      return 'completed';
    }
    if (appointment.status.toLowerCase() == 'cancelled') {
      return 'cancelled';
    }

    // Check if appointment time has passed
    final appointmentDateTime = _combineDateTime(
      appointment.appointmentDate,
      appointment.endTime, // Use end time to determine if appointment is truly finished
    );

    final now = DateTime.now();

    // If appointment end time has passed, it should show as "Completed"
    if (appointmentDateTime.isBefore(now)) {
      return 'completed';
    }

    // Otherwise show the actual status (confirmed, pending, etc.)
    return appointment.status.toLowerCase();
  }

  /// Combines date and time string into DateTime
  DateTime _combineDateTime(DateTime date, String time) {
    try {
      final parts = time.split(':');
      return DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
    } catch (e) {
      return DateTime(date.year, date.month, date.day);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayTime = _formatTime(appointment.startTime);
    final displayDate = _formatDate(appointment.appointmentDate);
    final displayStatus = _getDisplayStatus();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Row(
          children: [
            // Profile picture
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.grey[200],
              backgroundImage: appointment.profileImageUrl != null &&
                      appointment.profileImageUrl!.isNotEmpty
                  ? NetworkImage(appointment.profileImageUrl!)
                  : null,
              child: appointment.profileImageUrl == null ||
                      appointment.profileImageUrl!.isEmpty
                  ? Icon(
                      Icons.person,
                      size: 32,
                      color: Colors.grey[500],
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            // Patient info - WRAPPED IN FLEXIBLE TO FIX OVERFLOW
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.patientName,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (appointment.contactNumber.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            appointment.contactNumber,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '$displayDate at $displayTime',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Status badge with dynamic color based on actual status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor(displayStatus),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _getStatusText(displayStatus),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String time24) {
    try {
      final parts = time24.split(':');
      int hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final ampm = hour >= 12 ? 'PM' : 'AM';
      hour = hour % 12;
      if (hour == 0) hour = 12;
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $ampm';
    } catch (_) {
      return time24;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.blue; // ✅ Blue for confirmed (not yet finished)
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green; // ✅ Green for completed
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }
}