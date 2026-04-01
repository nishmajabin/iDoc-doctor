import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:idoc_doctor_side/core/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/core/data/models/notification_item_model.dart';
import 'package:idoc_doctor_side/core/data/services/notification_service.dart';

class NotificationAppointmentHandler {
  NotificationAppointmentHandler({
    required FirebaseFirestore firestore,
    required NotificationService notificationService,
    required void Function({
      required String title,
      required String body,
      required NotificationType type,
      Map<String, dynamic>? data,
      String? notificationId,
    }) onPersist,
  })  : _firestore = firestore,
        _notificationService = notificationService,
        _onPersist = onPersist;

  final FirebaseFirestore _firestore;
  final NotificationService _notificationService;
  final void Function({
    required String title,
    required String body,
    required NotificationType type,
    Map<String, dynamic>? data,
    String? notificationId,
  }) _onPersist;

  final Set<String> _knownAppointmentIds = {};
  final Map<String, Timer> _reminderTimers = {};
  StreamSubscription<QuerySnapshot>? _appointmentSub;

  // ── Public ────────────────────────────────────────────────────────────────

  void listen(String doctorId) {
    _appointmentSub?.cancel();
    _appointmentSub = _firestore
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .where('status', isEqualTo: 'confirmed')
        .snapshots()
        .listen(_onSnapshot, onError: (e) {
      debugPrint('[AppointmentHandler] Listener error: $e');
    });
  }

  void dispose() {
    _appointmentSub?.cancel();
    for (final timer in _reminderTimers.values) {
      timer.cancel();
    }
    _reminderTimers.clear();
    _knownAppointmentIds.clear();
  }

  // ── Private ───────────────────────────────────────────────────────────────

  void _onSnapshot(QuerySnapshot snapshot) {
    final isFirstSnapshot = _knownAppointmentIds.isEmpty;

    for (final change in snapshot.docChanges) {
      if (change.type != DocumentChangeType.added) continue;

      final doc = change.doc;
      final appointmentId = doc.id;

      try {
        final appointment = DoctorAppointmentModel.fromFirestore(doc);

        if (isFirstSnapshot) {
          _knownAppointmentIds.add(appointmentId);
          _scheduleReminder(appointment);
          continue;
        }

        if (_knownAppointmentIds.contains(appointmentId)) continue;

        _knownAppointmentIds.add(appointmentId);

        const title = '📅 New Appointment Booked';
        final body = '${appointment.patientName} booked a slot on '
            '${_formatDate(appointment.appointmentDate)} at ${appointment.startTime}.';

        _notificationService.showNotification(
          title: title,
          body: body,
          payload: '{"type":"new_appointment","appointmentId":"$appointmentId"}',
        );

        _onPersist(
          title: title,
          body: body,
          type: NotificationType.appointmentBooked,
          data: {'appointmentId': appointmentId},
        );

        _scheduleReminder(appointment);
      } catch (e) {
        debugPrint('[AppointmentHandler] Error parsing doc: $e');
      }
    }
  }

  void _scheduleReminder(DoctorAppointmentModel appointment, {int minutesBefore = 10}) {
    try {
      final appointmentDateTime = _combineDateTime(
        appointment.appointmentDate,
        appointment.startTime,
      );
      final delay = appointmentDateTime
          .subtract(Duration(minutes: minutesBefore))
          .difference(DateTime.now());

      if (!delay.isNegative && delay != Duration.zero) {
        _notificationService.scheduleAppointmentReminder(
          appointmentId: appointment.appointmentId,
          patientName: appointment.patientName,
          appointmentDateTime: appointmentDateTime,
          minutesBefore: minutesBefore,
        );

        _reminderTimers[appointment.appointmentId]?.cancel();
        _reminderTimers[appointment.appointmentId] = Timer(delay, () {
          _onPersist(
            notificationId: 'reminder_${appointment.appointmentId}',
            title: '⏰ Upcoming Appointment',
            body: 'Your appointment with ${appointment.patientName} is in $minutesBefore minutes.',
            type: NotificationType.appointmentReminder,
            data: {'appointmentId': appointment.appointmentId},
          );
          _reminderTimers.remove(appointment.appointmentId);
        });
      }
    } catch (e) {
      debugPrint('[AppointmentHandler] Error scheduling reminder: $e');
    }
  }

  DateTime _combineDateTime(DateTime date, String time) {
    try {
      final parts = time.split(':');
      return DateTime(date.year, date.month, date.day,
          int.parse(parts[0]), int.parse(parts[1]));
    } catch (_) {
      return DateTime(date.year, date.month, date.day);
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}