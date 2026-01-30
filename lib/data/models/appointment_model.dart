import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorAppointmentModel {
  final String appointmentId;
  final String doctorId;
  final String userId;
  final String patientName;
  final DateTime appointmentDate;
  final String startTime;
  final String endTime;
  final String status;
  final String? prescription;
  final String? profileImageUrl;


DoctorAppointmentModel({
  required this.appointmentId,
  required this.doctorId,
  required this.userId,
  required this.patientName,
  required this.appointmentDate,
  required this.startTime,
  required this.endTime,
  required this.status,
  this.prescription,
  this.profileImageUrl,
});
  factory DoctorAppointmentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return DoctorAppointmentModel(
      appointmentId: doc.id,
      doctorId: data['doctorId'],
      userId: data['userId'],
      patientName: data['patientName'],
      appointmentDate:
          (data['appointmentDate'] as Timestamp).toDate(),
      startTime: data['startTime'],
      endTime: data['endTime'],
      status: data['status'],
      prescription: data['prescription'],
      profileImageUrl: data['profileImageUrl'],

    );
  }
}
