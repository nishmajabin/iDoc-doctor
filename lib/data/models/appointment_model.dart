import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorAppointmentModel {
  final String appointmentId;
  final String doctorId;
  final String userId;
  final String slotId;
  final String patientName;
  final String contactNumber; // ✅ ADDED
  final String description; // ✅ ADDED
  final DateTime appointmentDate;
  final String startTime;
  final String endTime;
  final String status;
  final String? doctorName;
  final String? doctorSpecialist;
  final String? doctorProfileImageUrl;
  final String? profileImageUrl; // User's profile image
  final String? prescription; // ✅ ADDED for prescription functionality

  DoctorAppointmentModel({
    required this.appointmentId,
    required this.doctorId,
    required this.userId,
    required this.slotId,
    required this.patientName,
    required this.contactNumber, // ✅ ADDED
    required this.description, // ✅ ADDED
    required this.appointmentDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.doctorName,
    this.doctorSpecialist,
    this.doctorProfileImageUrl,
    this.profileImageUrl,
    this.prescription, // ✅ ADDED
  });

  // Create from Firestore document
  factory DoctorAppointmentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return DoctorAppointmentModel(
      appointmentId: doc.id,
      doctorId: data['doctorId'] as String,
      userId: data['userId'] as String,
      slotId: data['slotId'] as String,
      patientName: data['patientName'] as String,
      contactNumber: data['contactNumber'] as String? ?? '', // ✅ ADDED with fallback
      description: data['description'] as String? ?? '', // ✅ ADDED with fallback
      appointmentDate: (data['appointmentDate'] as Timestamp).toDate(),
      startTime: data['startTime'] as String,
      endTime: data['endTime'] as String,
      status: data['status'] as String,
      doctorName: data['doctorName'] as String?,
      doctorSpecialist: data['doctorSpecialist'] as String?,
      doctorProfileImageUrl: data['doctorProfileImageUrl'] as String?,
      profileImageUrl: data['profileImageUrl'] as String?,
      prescription: data['prescription'] as String?, // ✅ ADDED
    );
  }

  // Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'appointmentId': appointmentId,
      'doctorId': doctorId,
      'userId': userId,
      'slotId': slotId,
      'patientName': patientName,
      'contactNumber': contactNumber, // ✅ ADDED
      'description': description, // ✅ ADDED
      'appointmentDate': Timestamp.fromDate(appointmentDate),
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
      if (doctorName != null) 'doctorName': doctorName,
      if (doctorSpecialist != null) 'doctorSpecialist': doctorSpecialist,
      if (doctorProfileImageUrl != null) 'doctorProfileImageUrl': doctorProfileImageUrl,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      if (prescription != null) 'prescription': prescription, // ✅ ADDED
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  DoctorAppointmentModel copyWith({
    String? appointmentId,
    String? doctorId,
    String? userId,
    String? slotId,
    String? patientName,
    String? contactNumber, // ✅ ADDED
    String? description, // ✅ ADDED
    DateTime? appointmentDate,
    String? startTime,
    String? endTime,
    String? status,
    String? doctorName,
    String? doctorSpecialist,
    String? doctorProfileImageUrl,
    String? profileImageUrl,
    String? prescription, // ✅ ADDED
  }) {
    return DoctorAppointmentModel(
      appointmentId: appointmentId ?? this.appointmentId,
      doctorId: doctorId ?? this.doctorId,
      userId: userId ?? this.userId,
      slotId: slotId ?? this.slotId,
      patientName: patientName ?? this.patientName,
      contactNumber: contactNumber ?? this.contactNumber, // ✅ ADDED
      description: description ?? this.description, // ✅ ADDED
      appointmentDate: appointmentDate ?? this.appointmentDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      doctorName: doctorName ?? this.doctorName,
      doctorSpecialist: doctorSpecialist ?? this.doctorSpecialist,
      doctorProfileImageUrl: doctorProfileImageUrl ?? this.doctorProfileImageUrl,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      prescription: prescription ?? this.prescription, // ✅ ADDED
    );
  }
}