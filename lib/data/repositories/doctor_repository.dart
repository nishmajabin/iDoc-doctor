import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:idoc_doctor_side/data/models/doctor_model.dart';

class DoctorRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Initialize Cloudinary
  late final CloudinaryPublic _cloudinary;

  DoctorRepository() {
    // Initialize Cloudinary with your credentials
    _cloudinary = CloudinaryPublic(
      'dwykvyw5l', // Your cloud name
      'doctor_files_presets', // Your upload preset
      cache: false,
    );
  }

  /// Submit doctor application - creates doctor with 'pending' status
  Future<String> submitDoctorApplication({
    required DoctorModel doctor,
    File? licenseFile,
    File? profileImage,
  }) async {
    try {
      // Upload files to Cloudinary if provided
      String? licenseUrl;
      String? profileImageUrl;

      if (licenseFile != null) {
        licenseUrl = await _uploadFileToCloudinary(
          file: licenseFile,
          folder: 'doctor_licenses',
          resourceType: CloudinaryResourceType.Auto,
        );
      }

      if (profileImage != null) {
        profileImageUrl = await _uploadFileToCloudinary(
          file: profileImage,
          folder: 'doctor_profiles',
          resourceType: CloudinaryResourceType.Image,
        );
      }

      // Create doctor document with 'pending' status
      final doctorData = {
        'name': doctor.name,
        'place': doctor.place,
        'email': doctor.email,
        'password': doctor.password,
        'phone': doctor.phone,
        'gender': doctor.gender,
        'specialist': doctor.specialist,
        'bio': doctor.bio,
        'licenseNumber': doctor.licenseNumber,
        'experience': doctor.experience,
        'licenseProofUrl': licenseUrl,
        'profileImageUrl': profileImageUrl,
        'status': 'pending', // Status is 'pending' by default
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Add to 'doctors' collection with pending status
      final docRef = await _firestore
          .collection('doctors')
          .add(doctorData);

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to submit application: $e');
    }
  }

  /// Login doctor - checks email, password, and approval status
  Future<DoctorModel> loginDoctor({
    required String email,
    required String password,
  }) async {
    try {
      // Query doctor by email
      final querySnapshot = await _firestore
          .collection('doctors')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      // Check if doctor exists
      if (querySnapshot.docs.isEmpty) {
        throw Exception('No account found with this email');
      }

      final doctorDoc = querySnapshot.docs.first;
      final doctorData = doctorDoc.data();

      // Check if password matches
      if (doctorData['password'] != password) {
        throw Exception('Incorrect password');
      }

      // Check if doctor is approved
      if (doctorData['status'] != 'approved') {
        throw Exception('Your account is pending approval. Please wait for admin approval.');
      }

      // Create Firebase Auth user if not exists
      try {
        await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          // User already exists, just sign in
          await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
        } else {
          rethrow;
        }
      }

      // Return doctor model
      return DoctorModel.fromMap(doctorData, doctorDoc.id);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  /// Logout doctor
  Future<void> logoutDoctor() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  /// Get current logged-in doctor
  Future<DoctorModel?> getCurrentDoctor() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final querySnapshot = await _firestore
          .collection('doctors')
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;

      final doctorDoc = querySnapshot.docs.first;
      return DoctorModel.fromMap(doctorDoc.data(), doctorDoc.id);
    } catch (e) {
      throw Exception('Failed to get current doctor: $e');
    }
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  /// Get doctor profile by ID
  Future<DoctorModel?> getDoctorById(String doctorId) async {
    try {
      final doc = await _firestore.collection('doctors').doc(doctorId).get();
      
      if (!doc.exists) return null;

      return DoctorModel.fromMap(doc.data()!, doctorId);
    } catch (e) {
      throw Exception('Failed to get doctor: $e');
    }
  }

  /// Check application status by email
  Future<Map<String, dynamic>?> checkApplicationStatus(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('doctors')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null; // No application found
      }

      final doctorDoc = querySnapshot.docs.first;
      final data = doctorDoc.data();

      return {
        'status': data['status'],
        'id': doctorDoc.id,
        'data': data,
      };
    } catch (e) {
      throw Exception('Failed to check status: $e');
    }
  }

  /// Stream to monitor doctor status changes
  Stream<Map<String, dynamic>?> watchDoctorStatus(String doctorId) {
    return _firestore
        .collection('doctors')
        .doc(doctorId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      
      final data = doc.data()!;
      return {
        'status': data['status'],
        'id': doc.id,
        'data': data,
      };
    });
  }

  /// Upload file to Cloudinary
  Future<String> _uploadFileToCloudinary({
    required File file,
    required String folder,
    required CloudinaryResourceType resourceType,
  }) async {
    try {
      CloudinaryResponse response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          folder: folder,
          resourceType: resourceType,
        ),
      );

      return response.secureUrl;
    } catch (e) {
      throw Exception('Failed to upload file to Cloudinary: $e');
    }
  }
}