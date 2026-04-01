// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:idoc_doctor_side/core/exceptions/doctor_exceptions.dart';
// import 'package:idoc_doctor_side/data/models/doctor_model.dart';

// class DoctorFirestoreHandler {
//   DoctorFirestoreHandler() : _firestore = FirebaseFirestore.instance;

//   final FirebaseFirestore _firestore;

//   CollectionReference<Map<String, dynamic>> get _doctors =>
//       _firestore.collection('doctors');

//   Future<QueryDocumentSnapshot<Map<String, dynamic>>?> _findByEmail(String email) async {
//     final snap = await _doctors.where('email', isEqualTo: email).limit(1).get();
//     return snap.docs.isEmpty ? null : snap.docs.first;
//   }

//   Future<String> addDoctor(Map<String, dynamic> data) async {
//     final ref = await _doctors.add(data);
//     return ref.id;
//   }

//   Future<DoctorModel?> getByEmail(String email) async {
//     final doc = await _findByEmail(email);
//     if (doc == null) return null;
//     return DoctorModel.fromMap(doc.data(), doc.id);
//   }

//   Future<DoctorModel?> getById(String doctorId) async {
//     final doc = await _doctors.doc(doctorId).get();
//     if (!doc.exists) return null;
//     return DoctorModel.fromMap(doc.data()!, doctorId);
//   }

//   Future<Map<String, dynamic>?> checkApplicationStatus(String email) async {
//     final doc = await _findByEmail(email);
//     if (doc == null) return null;
//     final data = doc.data();
//     return {
//       'status': data['status'],
//       'blocked': data['blocked'] ?? false,
//       'blockReason': data['blockReason'],
//       'id': doc.id,
//       'data': data,
//     };
//   }

//   Stream<Map<String, dynamic>?> watchDoctorStatus(String doctorId) =>
//       _doctors.doc(doctorId).snapshots().map((doc) {
//         if (!doc.exists) return null;
//         final data = doc.data()!;
//         return {
//           'status': data['status'],
//           'blocked': data['blocked'] ?? false,
//           'blockReason': data['blockReason'],
//           'id': doc.id,
//           'data': data,
//         };
//       });

//   void assertNotBlocked(Map<String, dynamic> data) {
//     if (data['blocked'] != true) return;
//     final reason = data['blockReason'] as String?;
//     final message = [
//       'Your account has been blocked by the administrator.',
//       if (reason != null && reason.isNotEmpty) '\nReason: $reason',
//       '\nPlease contact support for assistance.',
//     ].join();
//     throw DoctorBlockedException(message);
//   }

//   void assertApproved(Map<String, dynamic> data) {
//     if (data['status'] == 'approved') return;
//     throw Exception('Your account is pending approval. Please wait for admin approval.');
//   }
// }