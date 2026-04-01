import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';

class DoctorCloudinaryHandler {
  DoctorCloudinaryHandler()
      : _cloudinary = CloudinaryPublic(
          'dwykvyw5l',
          'doctor_files_presets',
          cache: false,
        );

  final CloudinaryPublic _cloudinary;

  Future<String?> uploadLicense(File? file) =>
      _upload(file, folder: 'doctor_licenses', resourceType: CloudinaryResourceType.Auto);

  Future<String?> uploadProfileImage(File? file) =>
      _upload(file, folder: 'doctor_profiles', resourceType: CloudinaryResourceType.Image);

  Future<String?> _upload(
    File? file, {
    required String folder,
    required CloudinaryResourceType resourceType,
  }) async {
    if (file == null) return null;
    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(file.path, folder: folder, resourceType: resourceType),
      );
      return response.secureUrl;
    } catch (e) {
      throw Exception('Failed to upload file to Cloudinary: $e');
    }
  }
}