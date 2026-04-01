import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorAuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> loginDoctor({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = userCredential.user?.uid;
      if (userId == null) {
        throw Exception('User ID not found');
      }

      final doctorDoc = await _firestore.collection('doctors').doc(userId).get();

      if (!doctorDoc.exists) {
        final applicationDoc = await _firestore
            .collection('applications')
            .doc(userId)
            .get();

        if (applicationDoc.exists) {
          final status = applicationDoc.data()?['status'];
          if (status == 'pending') {
            await _auth.signOut();
            throw Exception('Your application is pending approval');
          } else if (status == 'rejected') {
            await _auth.signOut();
            throw Exception('Your application was rejected');
          }
        }

        await _auth.signOut();
        throw Exception('Doctor account not found');
      }

      final doctorData = doctorDoc.data()!;
      
      if (doctorData['status'] != 'approved') {
        await _auth.signOut();
        throw Exception('Your account is not approved yet');
      }

      return {
        'id': userId,
        ...doctorData,
      };
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('No user found with this email');
        case 'wrong-password':
          throw Exception('Incorrect password');
        case 'invalid-email':
          throw Exception('Invalid email address');
        case 'user-disabled':
          throw Exception('This account has been disabled');
        case 'too-many-requests':
          throw Exception('Too many attempts. Please try again later');
        default:
          throw Exception('Login failed: ${e.message}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getCurrentDoctor() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return null;

      final doctorDoc = await _firestore
          .collection('doctors')
          .doc(currentUser.uid)
          .get();

      if (!doctorDoc.exists) return null;

      return {
        'id': currentUser.uid,
        ...doctorDoc.data()!,
      };
    } catch (e) {
      return null;
    }
  }

  Future<void> logoutDoctor() async {
    await _auth.signOut();
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      final doctorsQuery = await _firestore
          .collection('doctors')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (doctorsQuery.docs.isNotEmpty) return true;

      final applicationsQuery = await _firestore
          .collection('applications')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      return applicationsQuery.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}