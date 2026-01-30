import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:idoc_doctor_side/data/models/appointment_model.dart';

class DoctorAppointmentService {
  final FirebaseFirestore firestore;

  DoctorAppointmentService(this.firestore);

  Future<List<DoctorAppointmentModel>> fetchAppointments(
    String doctorId,
  ) async {
    final snapshot = await firestore
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .get();

    return snapshot.docs
        .map((e) => DoctorAppointmentModel.fromFirestore(e))
        .toList();
  }

  Future<void> markCompleted(String appointmentId) async {
    await firestore.collection('appointments').doc(appointmentId).update({
      'status': 'completed',
    });
  }

  Future<void> addPrescription(
    String appointmentId,
    String prescription,
  ) async {
    await firestore.collection('appointments').doc(appointmentId).update({
      'prescription': prescription,
    });
  }
}
