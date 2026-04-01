import 'package:cloud_firestore/cloud_firestore.dart';

class CallSignalingHandler {
  CallSignalingHandler({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _calls =>
      _firestore.collection('calls');

  Future<void> createCallDocument({
    required String appointmentId,
    required String doctorId,
    required String userId,
    required String doctorName,
    required String patientName,
    String? doctorProfileImageUrl,
  }) =>
      _calls.doc(appointmentId).set({
        'callId': appointmentId,
        'channelName': appointmentId,
        'doctorId': doctorId,
        'userId': userId,
        'doctorName': doctorName,
        'patientName': patientName,
        'doctorProfileImageUrl': doctorProfileImageUrl,
        'status': 'ringing',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

  Stream<String?> watchCallStatus({required String callId}) =>
      _calls.doc(callId).snapshots().map(
            (doc) => doc.exists ? (doc.data() ?? {})['status'] as String? : null,
          );

  Future<void> endCallDocument({required String callId}) =>
      _calls.doc(callId).update({
        'status': 'ended',
        'updatedAt': FieldValue.serverTimestamp(),
      });
}