import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/core/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/core/data/repositories/chat_repository.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_screen/chat_screen.dart';

class ChatButton extends StatefulWidget {
  final DoctorAppointmentModel appointment;
  final DoctorModel currentDoctor;

  const ChatButton({
    super.key,
    required this.appointment,
    required this.currentDoctor,
  });

  @override
  State<ChatButton> createState() => _ChatButtonState();
}

class _ChatButtonState extends State<ChatButton> {
  bool _loading = false;

  Future<void> _openChat() async {
    if (_loading) return;
    setState(() => _loading = true);

    try {
      // Creates the room in Firestore if it doesn't exist yet (idempotent).
      // This is what makes it appear in ChatRoomListScreen.
      await ChatRepository().getOrCreateChatRoom(
        doctorId: widget.appointment.doctorId,
        patientId: widget.appointment.userId,
        appointmentId: widget.appointment.appointmentId,
        doctorName: widget.currentDoctor.name,
        patientName: widget.appointment.patientName,
        doctorProfileImageUrl: widget.currentDoctor.profileImageUrl,
        patientProfileImageUrl: widget.appointment.profileImageUrl,
      );

      if (!mounted) return;

      await Navigator.of(context).push(
        ChatScreen.route(
          doctorId: widget.appointment.doctorId,
          patientId: widget.appointment.userId,
          appointmentId: widget.appointment.appointmentId,
          currentUserId: widget.currentDoctor.id!,
          currentUserIsDoctor: true,
          doctorName: widget.currentDoctor.name,
          patientName: widget.appointment.patientName,
          doctorProfileImageUrl: widget.currentDoctor.profileImageUrl,
          patientProfileImageUrl: widget.appointment.profileImageUrl,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Could not open chat. Please try again.',
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.cancelled,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openChat,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0E7C7B), Color(0xFF27C4C3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0E7C7B).withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: _loading
            ? const Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Chat with Patient',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
