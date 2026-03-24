import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:idoc_doctor_side/data/models/appointment_model.dart';

class DoctorAppointmentService {
  final FirebaseFirestore _firestore;

  DoctorAppointmentService(this._firestore);

  Future<List<DoctorAppointmentModel>> fetchAppointments(String doctorId) async {
    try {
      print('=== FETCHING DOCTOR APPOINTMENTS ===');
      print('Doctor ID: $doctorId');

      final snapshot = await _firestore
          .collection('appointments')
          .where('doctorId', isEqualTo: doctorId)
          .get();

      print('Documents found: ${snapshot.docs.length}');

      final appointments = <DoctorAppointmentModel>[];

      for (var doc in snapshot.docs) {
        try {
          final data = doc.data();
          log('Contact Number: ${data['contactNumber']}');
          log('Description: ${data['description']}');

          final appointment = DoctorAppointmentModel.fromFirestore(doc);
          appointments.add(appointment);
        } catch (e, stackTrace) {
          log('Stack trace: $stackTrace');
        }
      }
      return appointments;
    } catch (e, stackTrace) {
      log('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> markCompleted(String appointmentId) async {
    try {
      await _firestore.collection('appointments').doc(appointmentId).update({
        'status': 'completed',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addPrescription(String appointmentId, String prescription) async {
    try {
      await _firestore.collection('appointments').doc(appointmentId).update({
        'prescription': prescription,
        'updatedAt': FieldValue.serverTimestamp(),
      });

    } catch (e) {
      rethrow;
    }
  }

  Future<DoctorAppointmentModel?> getAppointment(String appointmentId) async {
    try {
      final doc = await _firestore.collection('appointments').doc(appointmentId).get();

      if (!doc.exists) {
        return null;
      }

      return DoctorAppointmentModel.fromFirestore(doc);
    } catch (e) {
      debugPrint('❌ Error getting appointment: $e');
      rethrow;
    }
  }
}