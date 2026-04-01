import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:idoc_doctor_side/core/handlers/profile/profile_firestore_handler.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_profile_stats_model.dart';

class DoctorProfileRepository {
  DoctorProfileRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _handler = DoctorProfileFirestoreHandler(firestore: firestore);

  final DoctorProfileFirestoreHandler _handler;

  Stream<Map<String, dynamic>?> watchDoctor(String doctorId) =>
      _handler.watchDoctor(doctorId);

  Future<DoctorProfileStats> fetchProfileStats(String doctorId) =>
      _handler.fetchProfileStats(doctorId);
}