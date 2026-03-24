import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:idoc_doctor_side/core/constants/cloudinary_config.dart';

class CloudinaryService {
  Future<String> uploadFile({
    required File file,
    required String folder,
    String? publicId,
  }) async {
    try {
      final url = Uri.parse(CloudinaryConfig.uploadUrl);
      
      final request = http.MultipartRequest('POST', url);
      
      request.files.add(
        await http.MultipartFile.fromPath('file', file.path),
      );
      
      request.fields['upload_preset'] = CloudinaryConfig.uploadPreset;
      request.fields['folder'] = folder;
      
      if (publicId != null) {
        request.fields['public_id'] = publicId;
      }
      
      final response = await request.send();
      
      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonResponse = json.decode(responseString);
        
        return jsonResponse['secure_url'];
      } else {
        throw Exception('Failed to upload file: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error uploading to Cloudinary: $e');
    }
  }
  
  Future<String> uploadLicenseProof(File file, String doctorId) async {
    return await uploadFile(
      file: file,
      folder: CloudinaryConfig.licensesFolder,
      publicId: 'license_$doctorId',
    );
  }
  
  // Upload profile image
  Future<String> uploadProfileImage(File file, String doctorId) async {
    return await uploadFile(
      file: file,
      folder: CloudinaryConfig.profilesFolder,
      publicId: 'profile_$doctorId',
    );
  }
  
  // Delete file from Cloudinary (optional)
  Future<void> deleteFile(String publicId) async {
    try {

    } catch (e) {
      throw Exception('Error deleting from Cloudinary: $e');
    }
  }
}