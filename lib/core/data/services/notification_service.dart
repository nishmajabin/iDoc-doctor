import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:idoc_doctor_side/core/handlers/notifications/notification_fcm_handler.dart';
import 'package:idoc_doctor_side/core/handlers/notifications/notification_local_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class NotificationService {
  NotificationService._internal();
  static final NotificationService instance = NotificationService._internal();

  late final NotificationFcmHandler _fcmHandler;
  late final NotificationLocalHandler _localHandler;

  bool _initialized = false;

  Stream<String?> get onNotificationTapped => _localHandler.onNotificationTapped;

  // ── Init ──────────────────────────────────────────────────────────────────

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    _localHandler = NotificationLocalHandler();
    await _localHandler.initialize();

    _fcmHandler = NotificationFcmHandler(
      fcm: FirebaseMessaging.instance,
      firestore: FirebaseFirestore.instance,
      onShowNotification: ({required title, required body, payload}) =>
          _localHandler.show(title: title, body: body, payload: payload),
    );

    await _initTimezone();
    await _fcmHandler.requestPermission();
    _fcmHandler.setupListeners();
    await _fcmHandler.handleInitialMessage();
  }

  Future<void> _initTimezone() async {
    tz.initializeTimeZones();
    final tzInfo = await FlutterTimezone.getLocalTimezone();
    final tzString = tzInfo.toString();
    final ianaId = tzString.contains('(')
        ? tzString.split('(')[1].split(',')[0].trim()
        : tzString;
    tz.setLocalLocation(tz.getLocation(ianaId));
  }

  // ── FCM token ─────────────────────────────────────────────────────────────

  Future<bool> requestPermission() => _fcmHandler.requestPermission();

  Future<String?> getFcmToken() => _fcmHandler.getFcmToken();

  Future<void> storeFcmToken(String doctorId) =>
      _fcmHandler.storeFcmToken(doctorId);

  void listenForTokenRefresh(String doctorId) =>
      _fcmHandler.listenForTokenRefresh(doctorId);

  // ── Local notifications ───────────────────────────────────────────────────

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
    int? id,
  }) =>
      _localHandler.show(title: title, body: body, payload: payload, id: id);

  Future<void> scheduleAppointmentReminder({
    required String appointmentId,
    required String patientName,
    required DateTime appointmentDateTime,
    int minutesBefore = 10,
  }) =>
      _localHandler.scheduleReminder(
        appointmentId: appointmentId,
        patientName: patientName,
        appointmentDateTime: appointmentDateTime,
        minutesBefore: minutesBefore,
      );

  Future<void> cancelAppointmentReminder(String appointmentId) =>
      _localHandler.cancelReminder(appointmentId);

  Future<void> cancelAllNotifications() => _localHandler.cancelAll();

  Future<void> disposeService() => _localHandler.dispose();
}