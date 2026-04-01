import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class DepartmentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<String>> getDepartmentsStream() {
    return _firestore.collection('categories').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            return data['name'] as String? ?? '';
          })
          .where((name) => name.isNotEmpty) 
          .toList()
        ..sort(); 
    });
  }


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

  Stream<List<Map<String, dynamic>>> getDepartmentsWithDetailsStream() {
    return _firestore.collection('categories').snapshots().map((snapshot) {
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
