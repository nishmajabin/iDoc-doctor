import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:idoc_doctor_side/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/data/services/cloudinary_service.dart';

class EditProfileRepository {
  final FirebaseFirestore _firestore;
  final CloudinaryService _cloudinary;

  EditProfileRepository({
    FirebaseFirestore? firestore,
    CloudinaryService? cloudinary,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _cloudinary = cloudinary ?? CloudinaryService();


  Future<DoctorModel> updateProfile({
    required DoctorModel doctor,
    required String name,
    required String phone,
    required String place,
    required String bio,
    required String specialist,
    required String gender,
    required int experience,
    File? newProfileImage,
  }) async {
    String? profileImageUrl = doctor.profileImageUrl;

    if (newProfileImage != null) {
      profileImageUrl = await _cloudinary.uploadProfileImage(
        newProfileImage,
        doctor.id!,
      );
    }

    final updatedFields = <String, dynamic>{
      'name': name.trim(),
      'phone': phone.trim(),
      'place': place.trim(),
      'bio': bio.trim(),
      'specialist': specialist,
      'gender': gender,
      'experience': experience,
      'profileImageUrl': profileImageUrl,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    };

    await _firestore
        .collection('doctors')
        .doc(doctor.id!)
        .update(updatedFields);

    return doctor.copyWith(
      name: name.trim(),
      phone: phone.trim(),
      place: place.trim(),
      bio: bio.trim(),
      specialist: specialist,
      gender: gender,
      experience: experience,
      profileImageUrl: profileImageUrl,
      updatedAt: DateTime.now(),
    );
  }
}