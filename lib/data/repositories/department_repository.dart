import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class DepartmentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get departments/categories stream from Firestore
  /// Returns a stream of category names that were added by admin
  Stream<List<String>> getDepartmentsStream() {
    return _firestore
        .collection('categories')
        .snapshots()
        .map((snapshot) {
      // Extract category names from documents
      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            return data['name'] as String? ?? '';
          })
          .where((name) => name.isNotEmpty) // Filter out empty names
          .toList()
        ..sort(); // Sort alphabetically for better UX
    });
  }

  /// Get departments/categories as a one-time fetch
  /// Useful if you don't need real-time updates
  Future<List<String>> getDepartments() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      
      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            return data['name'] as String? ?? '';
          })
          .where((name) => name.isNotEmpty)
          .toList()
        ..sort();
    } catch (e) {
      log('Error fetching departments: $e');
      return [];
    }
  }

  /// Get full department/category details (including images)
  /// Use this if you need more than just names
  Stream<List<Map<String, dynamic>>> getDepartmentsWithDetailsStream() {
    return _firestore
        .collection('categories')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'] ?? '',
          'image': data['image'] ?? '',
        };
      }).toList();
    });
  }
}