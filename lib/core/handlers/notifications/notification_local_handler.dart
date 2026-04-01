import 'dart:async';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
void onBackgroundNotificationTap(NotificationResponse response) {}

const _androidDetails = AndroidNotificationDetails(
  'idoc_doctor_channel',
  'iDoc Doctor Notifications',
  channelDescription: 'Notifications for appointments, chats, and reminders',
  importance: Importance.high,
  priority: Priority.high,
  playSound: true,
  enableVibration: true,
  icon: '@mipmap/ic_launcher',
);

const _iosDetails = DarwinNotificationDetails(
  presentAlert: true,
  presentBadge: true,
  presentSound: true,
);

const _notificationDetails = NotificationDetails(
  android: _androidDetails,
  iOS: _iosDetails,
);

class NotificationLocalHandler {
  final FlutterLocalNotificationsPlugin _localNotif =
      FlutterLocalNotificationsPlugin();

  final _tapPayloadController = StreamController<String?>.broadcast();
  Stream<String?> get onNotificationTapped => _tapPayloadController.stream;

  // ── Init ──────────────────────────────────────────────────────────────────

  Future<void> initialize() async {
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );

    await _localNotif.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onTap,
      onDidReceiveBackgroundNotificationResponse: onBackgroundNotificationTap,
    );

    await _localNotif
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(const AndroidNotificationChannel(
          'idoc_doctor_channel',
          'iDoc Doctor Notifications',
          description: 'Notifications for appointments, chats, and reminders',
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
        ));
  }

  // ── Show ──────────────────────────────────────────────────────────────────

  Future<void> show({
    required String title,
    required String body,
    String? payload,
    int? id,
  }) =>
      _localNotif.show(
        id: id ?? DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title: title,
        body: body,
        notificationDetails: _notificationDetails,
        payload: payload,
      );

  // ── Schedule ──────────────────────────────────────────────────────────────

  Future<void> scheduleReminder({
    required String appointmentId,
    required String patientName,
    required DateTime appointmentDateTime,
    int minutesBefore = 10,
  }) async {
    final scheduledTime = appointmentDateTime.subtract(Duration(minutes: minutesBefore));
    if (scheduledTime.isBefore(DateTime.now())) return;

    await _localNotif.zonedSchedule(
      id: _notifId(appointmentId),
      title: '⏰ Upcoming Appointment',
      body: 'Your appointment with $patientName is in $minutesBefore minutes.',
      scheduledDate: tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails: _notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: jsonEncode({
        'type': 'appointment_reminder',
        'appointmentId': appointmentId,
        'patientName': patientName,
      }),
    );
  }

  // ── Cancel ────────────────────────────────────────────────────────────────

  Future<void> cancelReminder(String appointmentId) =>
      _localNotif.cancel(id: _notifId(appointmentId));

  Future<void> cancelAll() => _localNotif.cancelAll();

  Future<void> dispose() => _tapPayloadController.close();

  // ── Private ───────────────────────────────────────────────────────────────

  void _onTap(NotificationResponse response) {
    if (!_tapPayloadController.isClosed) {
      _tapPayloadController.add(response.payload);
    }
  }

  int _notifId(String appointmentId) =>
      appointmentId.hashCode.abs() % 2147483647;
}