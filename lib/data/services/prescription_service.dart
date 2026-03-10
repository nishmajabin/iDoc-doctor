import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:idoc_doctor_side/data/models/prescription_model.dart';

class PrescriptionService {
  final FirebaseFirestore _firestore;

  PrescriptionService(this._firestore);

  Future<void> submitPrescription({
    required String appointmentId,
    required String userId,
    required String patientName,
    required String docNote,
    required List<PrescriptionMedication> medications,
  }) async {
    await _firestore
        .collection('appointments')
        .doc(appointmentId)
        .collection('prescription')
        .add({
      'prescriptions': medications.map((m) => m.toMap()).toList(),
      'docnote': docNote,
      'userId': userId,
      'name': patientName,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await _firestore
        .collection('appointments')
        .doc(appointmentId)
        .update({'status': 'completed'});
  }

  Future<List<PrescriptionRecord>> fetchPrescriptions(
      String appointmentId) async {
    final snapshot = await _firestore
        .collection('appointments')
        .doc(appointmentId)
        .collection('prescription')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => PrescriptionRecord.fromFirestore(doc.id, doc.data()))
        .toList();
  }
}