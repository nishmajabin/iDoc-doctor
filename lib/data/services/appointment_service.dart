import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:idoc_doctor_side/data/models/appointment_model.dart';

class DoctorAppointmentService {
  final FirebaseFirestore _firestore;

  DoctorAppointmentService(this._firestore);

  /// Fetch all appointments for a doctor
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
          print('---');
          print('Document ID: ${doc.id}');
          final data = doc.data();
          
          // Debug: Print contact number and description
          print('Contact Number: ${data['contactNumber']}');
          print('Description: ${data['description']}');

          final appointment = DoctorAppointmentModel.fromFirestore(doc);
          appointments.add(appointment);

          print('✅ Parsed: ${appointment.appointmentId} - ${appointment.patientName}');
          print('   Contact: ${appointment.contactNumber}');
          print('   Description: ${appointment.description}');
        } catch (e, stackTrace) {
          print('❌ Error parsing document ${doc.id}: $e');
          print('Stack trace: $stackTrace');
        }
      }

      print('=== APPOINTMENTS LOADED ===');
      print('Total: ${appointments.length}');
      print('=========================');

      return appointments;
    } catch (e, stackTrace) {
      print('❌ Error fetching doctor appointments: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Mark appointment as completed
  Future<void> markCompleted(String appointmentId) async {
    try {
      print('=== MARKING APPOINTMENT AS COMPLETED ===');
      print('Appointment ID: $appointmentId');

      await _firestore.collection('appointments').doc(appointmentId).update({
        'status': 'completed',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Appointment marked as completed');
    } catch (e) {
      print('❌ Error marking appointment as completed: $e');
      rethrow;
    }
  }

  /// Add or update prescription for an appointment
  Future<void> addPrescription(String appointmentId, String prescription) async {
    try {
      print('=== ADDING/UPDATING PRESCRIPTION ===');
      print('Appointment ID: $appointmentId');
      print('Prescription: $prescription');

      await _firestore.collection('appointments').doc(appointmentId).update({
        'prescription': prescription,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Prescription saved successfully');
    } catch (e) {
      print('❌ Error adding prescription: $e');
      rethrow;
    }
  }

  /// Get a single appointment by ID (useful for refresh after updates)
  Future<DoctorAppointmentModel?> getAppointment(String appointmentId) async {
    try {
      final doc = await _firestore.collection('appointments').doc(appointmentId).get();

      if (!doc.exists) {
        return null;
      }

      return DoctorAppointmentModel.fromFirestore(doc);
    } catch (e) {
      print('❌ Error getting appointment: $e');
      rethrow;
    }
  }
}