import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[FCM Background] Message: ${message.messageId}');
}

@pragma('vm:entry-point')
void _onBackgroundNotificationTap(NotificationResponse response) {
  debugPrint('[Local Notif Background] Tapped payload: ${response.payload}');
}

class NotificationService {
  NotificationService._internal();
  static final NotificationService instance = NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotif =
      FlutterLocalNotificationsPlugin();

  final StreamController<String?> _tapPayloadController =
      StreamController<String?>.broadcast();

  Stream<String?> get onNotificationTapped => _tapPayloadController.stream;

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    tz.initializeTimeZones();
    final tzInfo = await FlutterTimezone.getLocalTimezone();
    final tzString = tzInfo.toString();
    final ianaId =
        tzString.contains('(')
            ? tzString.split('(')[1].split(',')[0].trim()
            : tzString;
    tz.setLocalLocation(tz.getLocation(ianaId));

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // FIX: flutter_local_notifications v18+ uses named parameter 'settings'.
    await _localNotif.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundNotificationTap,
    );

    const androidChannel = AndroidNotificationChannel(
      'idoc_doctor_channel',
      'iDoc Doctor Notifications',
      description: 'Notifications for appointments, chats, and reminders',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _localNotif
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);

    await requestPermission();

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  //  PERMISSION
  // ──────────────────────────────────────────────────────────────────────────

  Future<bool> requestPermission() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    final granted =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
    debugPrint('[Notification] Permission granted: $granted');
    return granted;
  }

  // ──────────────────────────────────────────────────────────────────────────
  //  FCM TOKEN
  // ──────────────────────────────────────────────────────────────────────────

  Future<String?> getFcmToken() async {
    try {
      final token = await _fcm.getToken();
      debugPrint('[FCM] Token: $token');
      return token;
    } catch (e) {
      debugPrint('[FCM] Error getting token: $e');
      return null;
    }
  }

  Future<void> storeFcmToken(String doctorId) async {
    final token = await getFcmToken();
    if (token == null) return;

    await FirebaseFirestore.instance.collection('doctors').doc(doctorId).update(
      {'fcmToken': token, 'fcmTokenUpdatedAt': FieldValue.serverTimestamp()},
    );
    debugPrint('[FCM] Token stored for doctor: $doctorId');
  }

  void listenForTokenRefresh(String doctorId) {
    _fcm.onTokenRefresh.listen((newToken) async {
      debugPrint('[FCM] Token refreshed: $newToken');
      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(doctorId)
          .update({
            'fcmToken': newToken,
            'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
          });
    });
  }

  // ──────────────────────────────────────────────────────────────────────────
  //  FOREGROUND FCM MESSAGE
  // ──────────────────────────────────────────────────────────────────────────

  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('[FCM Foreground] ${message.notification?.title}');
    final notification = message.notification;
    if (notification == null) return;

    showNotification(
      title: notification.title ?? 'iDoc',
      body: notification.body ?? '',
      payload: jsonEncode(message.data),
    );
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint('[FCM] App opened from notification: ${message.data}');
  }

  // ──────────────────────────────────────────────────────────────────────────
  //  LOCAL NOTIFICATION TAP
  // ──────────────────────────────────────────────────────────────────────────

  void _onNotificationTap(NotificationResponse response) {
    debugPrint('[Local Notif] Tapped payload: ${response.payload}');
    if (!_tapPayloadController.isClosed) {
      _tapPayloadController.add(response.payload);
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  //  SHOW INSTANT LOCAL NOTIFICATION
  // ──────────────────────────────────────────────────────────────────────────

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
    int? id,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'idoc_doctor_channel',
      'iDoc Doctor Notifications',
      channelDescription:
          'Notifications for appointments, chats, and reminders',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // FIX: flutter_local_notifications v18+ uses named parameters.
    await _localNotif.show(
      id: id ?? DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  //  SCHEDULE LOCAL NOTIFICATION (appointment reminders)
  // ──────────────────────────────────────────────────────────────────────────

  Future<void> scheduleAppointmentReminder({
    required String appointmentId,
    required String patientName,
    required DateTime appointmentDateTime,
    int minutesBefore = 10,
  }) async {
    final scheduledTime = appointmentDateTime.subtract(
      Duration(minutes: minutesBefore),
    );

    if (scheduledTime.isBefore(DateTime.now())) {
      debugPrint(
        '[Scheduled Notif] Skipped — reminder time already passed for $appointmentId',
      );
      return;
    }

    final tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

    const androidDetails = AndroidNotificationDetails(
      'idoc_doctor_channel',
      'iDoc Doctor Notifications',
      channelDescription:
          'Notifications for appointments, chats, and reminders',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final notifId = appointmentId.hashCode.abs() % 2147483647;

    // FIX: flutter_local_notifications v18+ uses named parameters.
    await _localNotif.zonedSchedule(
      id: notifId,
      title: '⏰ Upcoming Appointment',
      body: 'Your appointment with $patientName is in $minutesBefore minutes.',
      scheduledDate: tzScheduledTime,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: jsonEncode({
        'type': 'appointment_reminder',
        'appointmentId': appointmentId,
        'patientName': patientName,
      }),
    );

    debugPrint(
      '[Scheduled Notif] Reminder set for $appointmentId at $tzScheduledTime',
    );
  }

  Future<void> cancelAppointmentReminder(String appointmentId) async {
    final notifId = appointmentId.hashCode.abs() % 2147483647;
    // FIX: flutter_local_notifications v18+ uses named parameter 'id'.
    await _localNotif.cancel(id: notifId);
    debugPrint('[Scheduled Notif] Cancelled reminder for $appointmentId');
  }

  Future<void> cancelAllNotifications() async {
    await _localNotif.cancelAll();
    debugPrint('[Scheduled Notif] All notifications cancelled');
  }

  // ──────────────────────────────────────────────────────────────────────────
  //  DISPOSE
  // ──────────────────────────────────────────────────────────────────────────

  Future<void> disposeService() async {
    await _tapPayloadController.close();
  }
}
