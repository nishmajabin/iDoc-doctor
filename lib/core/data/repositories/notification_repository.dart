import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:idoc_doctor_side/core/handlers/notifications/notification_appointment_handler.dart';
import 'package:idoc_doctor_side/core/handlers/notifications/notification_chat_handler.dart';
import 'package:idoc_doctor_side/core/data/models/notification_item_model.dart';
import 'package:idoc_doctor_side/core/data/services/notification_service.dart';
import 'package:idoc_doctor_side/core/data/services/notification_storage_service.dart';
import 'package:uuid/uuid.dart';

class NotificationRepository {
  NotificationRepository({
    NotificationService? notificationService,
    NotificationStorageService? storageService,
    FirebaseFirestore? firestore,
  })  : _notificationService = notificationService ?? NotificationService.instance,
        _storageService = storageService ?? NotificationStorageService(),
        _firestore = firestore ?? FirebaseFirestore.instance {
    _appointmentHandler = NotificationAppointmentHandler(
      firestore: _firestore,
      notificationService: _notificationService,
      onPersist: _persistNotification,
    );
    _chatHandler = NotificationChatHandler(
      firestore: _firestore,
      notificationService: _notificationService,
      onPersist: _persistNotification,
    );
  }

  final NotificationService _notificationService;
  final NotificationStorageService _storageService;
  final FirebaseFirestore _firestore;
  final Uuid _uuid = const Uuid();

  late final NotificationAppointmentHandler _appointmentHandler;
  late final NotificationChatHandler _chatHandler;

  String? _doctorId;

  NotificationStorageService get storageService => _storageService;

  // ── Public ────────────────────────────────────────────────────────────────

  Future<void> initialize(String doctorId) async {
    _doctorId = doctorId;
    await _notificationService.initialize();
    await _notificationService.storeFcmToken(doctorId);
    _notificationService.listenForTokenRefresh(doctorId);
  }

  void listenForAppointments(String doctorId) =>
      _appointmentHandler.listen(doctorId);

  void listenForChatMessages(String doctorId) =>
      _chatHandler.listen(doctorId);

  Future<void> removeFcmToken(String doctorId) async {
    try {
      await _firestore.collection('doctors').doc(doctorId).update({
        'fcmToken': FieldValue.delete(),
        'fcmTokenUpdatedAt': FieldValue.delete(),
      });
    } catch (_) {}
  }

  Future<void> dispose() async {
    _appointmentHandler.dispose();
    _chatHandler.dispose();
    await _notificationService.cancelAllNotifications();
  }

  // ── Private ───────────────────────────────────────────────────────────────

  void _persistNotification({
    required String title,
    required String body,
    required NotificationType type,
    Map<String, dynamic>? data,
    String? notificationId,
  }) {
    if (_doctorId == null) return;
    _storageService.saveNotification(NotificationItemModel(
      notificationId: notificationId ?? _uuid.v4(),
      doctorId: _doctorId!,
      title: title,
      body: body,
      type: type,
      timestamp: DateTime.now(),
      isRead: false,
      data: data,
    ));
  }
}