import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

class NotificationFcmHandler {
  NotificationFcmHandler({
    required FirebaseMessaging fcm,
    required FirebaseFirestore firestore,
    required void Function({
      required String title,
      required String body,
      String? payload,
    }) onShowNotification,
  })  : _fcm = fcm,
        _firestore = firestore,
        _onShowNotification = onShowNotification;

  final FirebaseMessaging _fcm;
  final FirebaseFirestore _firestore;
  final void Function({
    required String title,
    required String body,
    String? payload,
  }) _onShowNotification;

  CollectionReference<Map<String, dynamic>> get _doctors =>
      _firestore.collection('doctors');

  // ── Setup ─────────────────────────────────────────────────────────────────

  void setupListeners() {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
  }

  Future<void> handleInitialMessage() async {
    final message = await _fcm.getInitialMessage();
    if (message != null) _onMessageOpenedApp(message);
  }

  // ── Permission ────────────────────────────────────────────────────────────

  Future<bool> requestPermission() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  // ── Token ─────────────────────────────────────────────────────────────────

  Future<String?> getFcmToken() async {
    try {
      return await _fcm.getToken();
    } catch (e) {
      debugPrint('[FCM] Error getting token: $e');
      return null;
    }
  }

  Future<void> storeFcmToken(String doctorId) async {
    final token = await getFcmToken();
    if (token == null) return;
    await _doctors.doc(doctorId).update({
      'fcmToken': token,
      'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
    });
  }

  void listenForTokenRefresh(String doctorId) {
    _fcm.onTokenRefresh.listen((token) => _doctors.doc(doctorId).update({
          'fcmToken': token,
          'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
        }));
  }

  // ── Message handlers ──────────────────────────────────────────────────────

  void _onForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;
    _onShowNotification(
      title: notification.title ?? 'iDoc',
      body: notification.body ?? '',
      payload: jsonEncode(message.data),
    );
  }

  void _onMessageOpenedApp(RemoteMessage message) {}
}