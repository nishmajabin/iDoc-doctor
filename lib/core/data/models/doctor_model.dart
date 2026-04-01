import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorModel {
  final String? id;
  final String name;
  final String place;
  final String email;
  final String password;
  final String? confirmPassword;
  final String phone;
  final String gender;
  final String specialist;
  final String bio;
  final String licenseNumber;
  final int experience;
  final String? licenseProofUrl;
  final String? profileImageUrl;
  final String status;
  final bool blocked; // New field
  final String? blockReason; // New field
  final DateTime? blockedAt; // New field
  final DateTime createdAt;
  final DateTime? updatedAt;

  DoctorModel({
    this.id,
    required this.name,
    required this.place,
    required this.email,
    required this.password,
    this.confirmPassword,
    required this.phone,
    required this.gender,
    required this.specialist,
    required this.bio,
    required this.licenseNumber,
    required this.experience,
    this.licenseProofUrl,
    this.profileImageUrl,
    this.status = 'pending',
    this.blocked = false, // Default to not blocked
    this.blockReason,
    this.blockedAt,
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert DoctorModel to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'place': place,
      'email': email,
      'password': password,
      'phone': phone,
      'gender': gender,
      'specialist': specialist,
      'bio': bio,
      'licenseNumber': licenseNumber,
      'experience': experience,
      'licenseProofUrl': licenseProofUrl,
      'profileImageUrl': profileImageUrl,
      'status': status,
      'blocked': blocked,
      'blockReason': blockReason,
      'blockedAt': blockedAt != null ? Timestamp.fromDate(blockedAt!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  // Create DoctorModel from Firebase document
  factory DoctorModel.fromMap(Map<String, dynamic> map, String documentId) {
    return DoctorModel(
      id: documentId,
      name: map['name'] ?? '',
      place: map['place'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      phone: map['phone'] ?? '',
      gender: map['gender'] ?? '',
      specialist: map['specialist'] ?? '',
      bio: map['bio'] ?? '',
      licenseNumber: map['licenseNumber'] ?? '',
      experience: map['experience'] ?? 0,
      licenseProofUrl: map['licenseProofUrl'],
      profileImageUrl: map['profileImageUrl'],
      status: map['status'] ?? 'pending',
      blocked: map['blocked'] ?? false,
      blockReason: map['blockReason'],
      blockedAt: (map['blockedAt'] as Timestamp?)?.toDate(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // Create a copy with updated fields
  DoctorModel copyWith({
    String? id,
    String? name,
    String? place,
    String? email,
    String? password,
    String? confirmPassword,
    String? phone,
    String? gender,
    String? specialist,
    String? bio,
    String? licenseNumber,
    int? experience,
    String? licenseProofUrl,
    String? profileImageUrl,
    String? status,
    bool? blocked,
    String? blockReason,
    DateTime? blockedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      place: place ?? this.place,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      specialist: specialist ?? this.specialist,
      bio: bio ?? this.bio,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      experience: experience ?? this.experience,
      licenseProofUrl: licenseProofUrl ?? this.licenseProofUrl,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      status: status ?? this.status,
      blocked: blocked ?? this.blocked,
      blockReason: blockReason ?? this.blockReason,
      blockedAt: blockedAt ?? this.blockedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Validate if password and confirmPassword match
  bool validatePasswords() {
    return confirmPassword != null && password == confirmPassword;
  }

  @override
  String toString() {
    return 'DoctorModel(id: $id, name: $name, email: $email, specialist: $specialist, status: $status, blocked: $blocked)';
  }
}