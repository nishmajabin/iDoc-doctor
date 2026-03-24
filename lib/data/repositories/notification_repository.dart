import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:idoc_doctor_side/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/data/models/notification_item_model.dart';
import 'package:idoc_doctor_side/data/services/notification_service.dart';
import 'package:idoc_doctor_side/data/services/notification_storage_service.dart';
import 'package:uuid/uuid.dart';


class NotificationRepository {
  final NotificationService _notificationService;
  final NotificationStorageService _storageService;
  final FirebaseFirestore _firestore;
  final Uuid _uuid = const Uuid();

  final Set<String> _knownAppointmentIds = {};
  final Map<String, DateTime> _lastSeenMessageTime = {};

  StreamSubscription<QuerySnapshot>? _appointmentSub;
  StreamSubscription<QuerySnapshot>? _chatRoomSub;
  final List<StreamSubscription> _chatMessageSubs = [];
  final Map<String, Timer> _reminderTimers = {};

  String? _doctorId;

  NotificationRepository({
    NotificationService? notificationService,
    NotificationStorageService? storageService,
    FirebaseFirestore? firestore,
  })  : _notificationService =
            notificationService ?? NotificationService.instance,
        _storageService = storageService ?? NotificationStorageService(),
        _firestore = firestore ?? FirebaseFirestore.instance;


  NotificationStorageService get storageService => _storageService;

  Future<void> initialize(String doctorId) async {
    _doctorId = doctorId;
    await _notificationService.initialize();
    await _notificationService.storeFcmToken(doctorId);
    _notificationService.listenForTokenRefresh(doctorId);
  }

  void listenForAppointments(String doctorId) {
    _appointmentSub?.cancel();

    _appointmentSub = _firestore
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .where('status', isEqualTo: 'confirmed')
        .snapshots()
        .listen((snapshot) {

      final bool isFirstSnapshot = _knownAppointmentIds.isEmpty;

      for (final change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final doc = change.doc;
          final appointmentId = doc.id;

          try {
            final appointment = DoctorAppointmentModel.fromFirestore(doc);

            if (isFirstSnapshot) {
              _knownAppointmentIds.add(appointmentId);
              _scheduleReminderForAppointment(appointment);
              continue;
            }

            if (!_knownAppointmentIds.contains(appointmentId)) {
              _knownAppointmentIds.add(appointmentId);

              const title = '📅 New Appointment Booked';
              final body =
                  '${appointment.patientName} booked a slot on '
                  '${_formatDate(appointment.appointmentDate)} '
                  'at ${appointment.startTime}.';

              _notificationService.showNotification(
                title: title,
                body: body,
                payload:
                    '{"type":"new_appointment","appointmentId":"$appointmentId"}',
              );

              _persistNotification(
                title: title,
                body: body,
                type: NotificationType.appointmentBooked,
                data: {'appointmentId': appointmentId},
              );

              _scheduleReminderForAppointment(appointment);

              debugPrint(
                  '[NotifRepo] New appointment notification: $appointmentId');
            }
          } catch (e) {
            debugPrint('[NotifRepo] Error parsing appointment doc: $e');
          }
        }
      }
    }, onError: (e) {
      debugPrint('[NotifRepo] Appointment listener error: $e');
    });
  }

  void _scheduleReminderForAppointment(
    DoctorAppointmentModel appointment, {
    int minutesBefore = 10,
  }) {
    try {
      final appointmentDateTime = _combineDateTime(
        appointment.appointmentDate,
        appointment.startTime,
      );
      final reminderTime =
          appointmentDateTime.subtract(Duration(minutes: minutesBefore));
      final delay = reminderTime.difference(DateTime.now());

      if (delay.isNegative || delay == Duration.zero) {
        debugPrint(
            '[NotifRepo] Reminder time already passed for ${appointment.appointmentId}');
        return;
      }

      _notificationService.scheduleAppointmentReminder(
        appointmentId: appointment.appointmentId,
        patientName: appointment.patientName,
        appointmentDateTime: appointmentDateTime,
        minutesBefore: minutesBefore,
      );

      _reminderTimers[appointment.appointmentId]?.cancel();

      _reminderTimers[appointment.appointmentId] = Timer(delay, () {
        debugPrint(
            '[NotifRepo] Reminder timer fired for ${appointment.appointmentId}');

        _persistNotification(
          notificationId: 'reminder_${appointment.appointmentId}',
          title: '⏰ Upcoming Appointment',
          body: 'Your appointment with ${appointment.patientName} '
              'is in $minutesBefore minutes.',
          type: NotificationType.appointmentReminder,
          data: {'appointmentId': appointment.appointmentId},
        );

        _reminderTimers.remove(appointment.appointmentId);
      });

      debugPrint(
          '[NotifRepo] Reminder scheduled for ${appointment.appointmentId} '
          'in ${delay.inMinutes}m ${delay.inSeconds % 60}s');
    } catch (e) {
      debugPrint('[NotifRepo] Error scheduling reminder: $e');
    }
  }

  void listenForChatMessages(String doctorId) {
    _chatRoomSub?.cancel();
    for (final sub in _chatMessageSubs) {
      sub.cancel();
    }
    _chatMessageSubs.clear();

    _chatRoomSub = _firestore
        .collection('chatRooms')
        .where('doctorId', isEqualTo: doctorId)
        .snapshots()
        .listen((snapshot) {
      for (final doc in snapshot.docs) {
        _watchChatRoomMessages(doc.id, doctorId);
      }
    }, onError: (e) {
      debugPrint('[NotifRepo] Chat room listener error: $e');
    });
  }

  void _watchChatRoomMessages(String chatRoomId, String doctorId) {
    final sub = _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isEmpty) return;

      final latestDoc = snapshot.docs.first;
      final data = latestDoc.data();

      final senderId = data['senderId'] as String? ?? '';
      final messageText = data['messageText'] as String? ?? '';
      final timestamp = data['timestamp'] != null
          ? (data['timestamp'] as Timestamp).toDate()
          : DateTime.now();

      if (senderId == doctorId) return;

      final lastSeen = _lastSeenMessageTime[chatRoomId];
      if (lastSeen != null && !timestamp.isAfter(lastSeen)) return;

      _lastSeenMessageTime[chatRoomId] = timestamp;

      if (lastSeen == null) return;

      _firestore.collection('chatRooms').doc(chatRoomId).get().then((roomDoc) {
        final roomData = roomDoc.data();
        final patientName = roomData?['patientName'] as String? ?? 'A patient';

        final title = '💬 New Message from $patientName';
        final body = messageText.length > 100
            ? '${messageText.substring(0, 100)}…'
            : messageText;

        _notificationService.showNotification(
          title: title,
          body: body,
          payload: '{"type":"new_chat_message","chatRoomId":"$chatRoomId"}',
        );

        _persistNotification(
          title: title,
          body: body,
          type: NotificationType.chatMessage,
          data: {'chatRoomId': chatRoomId},
        );

        debugPrint(
            '[NotifRepo] Chat notification from $patientName in $chatRoomId');
      });
    }, onError: (e) {
      debugPrint('[NotifRepo] Chat message listener error: $e');
    });

    _chatMessageSubs.add(sub);
  }


  void _persistNotification({
    required String title,
    required String body,
    required NotificationType type,
    Map<String, dynamic>? data,
    String? notificationId,
  }) {
    if (_doctorId == null) return;

    final notification = NotificationItemModel(
      notificationId: notificationId ?? _uuid.v4(),
      doctorId: _doctorId!,
      title: title,
      body: body,
      type: type,
      timestamp: DateTime.now(),
      isRead: false,
      data: data,
    );

    _storageService.saveNotification(notification);
  }

  Future<void> removeFcmToken(String doctorId) async {
    try {
      await _firestore.collection('doctors').doc(doctorId).update({
        'fcmToken': FieldValue.delete(),
        'fcmTokenUpdatedAt': FieldValue.delete(),
      });
      debugPrint('[NotifRepo] FCM token removed for doctor: $doctorId');
    } catch (e) {
      debugPrint('[NotifRepo] Error removing FCM token: $e');
    }
  }

  Future<void> dispose() async {
    for (final timer in _reminderTimers.values) {
      timer.cancel();
    }
    _reminderTimers.clear();

    _appointmentSub?.cancel();
    _chatRoomSub?.cancel();
    for (final sub in _chatMessageSubs) {
      sub.cancel();
    }
    _chatMessageSubs.clear();
    _knownAppointmentIds.clear();
    _lastSeenMessageTime.clear();
    await _notificationService.cancelAllNotifications();
    debugPrint('[NotifRepo] Disposed all notification listeners and timers');
  }

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