import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  CollectionReference get _doctorsCollection => 
      _firestore.collection('doctors');
  
  Future<String> createDoctorApplication(DoctorModel doctor) async {
    try {
      final docRef = await _doctorsCollection.add(doctor.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create doctor application: $e');
    }
  }
  
  Future<void> updateDoctorApplication(String doctorId, Map<String, dynamic> data) async {
    try {
      await _doctorsCollection.doc(doctorId).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update doctor application: $e');
    }
  }
  
  Future<DoctorModel?> getDoctorById(String doctorId) async {
    try {
      final doc = await _doctorsCollection.doc(doctorId).get();
      
      if (doc.exists) {
        return DoctorModel.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get doctor: $e');
    }
  }
  
  Future<DoctorModel?> getDoctorByEmail(String email) async {
    try {
      final querySnapshot = await _doctorsCollection
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return DoctorModel.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get doctor by email: $e');
    }
  }
  
  Stream<List<DoctorModel>> getPendingApplications() {
    return _doctorsCollection
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return DoctorModel.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }
  
  Future<void> updateApplicationStatus(String doctorId, String status) async {
    try {
      await _doctorsCollection.doc(doctorId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update status: $e');
    }
  }
  
  Future<void> deleteDoctorApplication(String doctorId) async {
    try {
      await _doctorsCollection.doc(doctorId).delete();
    } catch (e) {
      throw Exception('Failed to delete doctor application: $e');
    }
  }
  
  Future<bool> emailExists(String email) async {
    try {
      final querySnapshot = await _doctorsCollection
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check email: $e');
    }
  }
  
  Future<bool> licenseNumberExists(String licenseNumber) async {
    try {
      final querySnapshot = await _doctorsCollection
          .where('licenseNumber', isEqualTo: licenseNumber)
          .limit(1)
          .get();
      
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check license number: $e');
    }
  }
}