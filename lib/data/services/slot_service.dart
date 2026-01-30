import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:idoc_doctor_side/data/models/slot_model.dart';

class SlotService {
  final FirebaseFirestore firestore;

  SlotService(this.firestore);

  /// Fetch slots for a doctor within a date range
  Future<List<SlotModel>> fetchSlotsByDateRange({
    required String doctorId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      // Normalize dates to start of day
      final normalizedStart = DateTime(startDate.year, startDate.month, startDate.day);
      final normalizedEnd = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

      // Use orderBy to avoid index issues
      final snapshot = await firestore
          .collection('slots')
          .where('doctorId', isEqualTo: doctorId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(normalizedStart))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(normalizedEnd))
          .orderBy('date')
          .orderBy('startTime')
          .get();

      return snapshot.docs
          .map((doc) => SlotModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      // If index error occurs, fallback to client-side filtering
      try {
        final snapshot = await firestore
            .collection('slots')
            .where('doctorId', isEqualTo: doctorId)
            .get();

        final normalizedStart = DateTime(startDate.year, startDate.month, startDate.day);
        final normalizedEnd = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

        return snapshot.docs
            .map((doc) => SlotModel.fromFirestore(doc))
            .where((slot) {
              final slotDate = DateTime(slot.date.year, slot.date.month, slot.date.day);
              return !slotDate.isBefore(normalizedStart) && 
                     !slotDate.isAfter(normalizedEnd);
            })
            .toList()
          ..sort((a, b) {
            final dateCompare = a.date.compareTo(b.date);
            if (dateCompare != 0) return dateCompare;
            return a.startTime.compareTo(b.startTime);
          });
      } catch (fallbackError) {
        throw Exception('Failed to fetch slots: $fallbackError');
      }
    }
  }

  /// Check if any slots exist for specific dates in the range
  Future<Map<DateTime, bool>> checkExistingSlotsForDates({
    required String doctorId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final normalizedStart = DateTime(startDate.year, startDate.month, startDate.day);
      final normalizedEnd = DateTime(endDate.year, endDate.month, endDate.day);

      final snapshot = await firestore
          .collection('slots')
          .where('doctorId', isEqualTo: doctorId)
          .get();

      final Map<DateTime, bool> dateMap = {};
      
      // Initialize all dates in range as false
      DateTime current = normalizedStart;
      while (!current.isAfter(normalizedEnd)) {
        dateMap[DateTime(current.year, current.month, current.day)] = false;
        current = current.add(const Duration(days: 1));
      }

      // Mark dates that have slots
      for (final doc in snapshot.docs) {
        final slot = SlotModel.fromFirestore(doc);
        final slotDate = DateTime(slot.date.year, slot.date.month, slot.date.day);
        
        if (dateMap.containsKey(slotDate)) {
          dateMap[slotDate] = true;
        }
      }

      return dateMap;
    } catch (e) {
      throw Exception('Failed to check existing slots: $e');
    }
  }

  /// Check if ANY slots exist in the date range (simpler check)
  Future<bool> hasAnySlotsInRange({
    required String doctorId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final dateMap = await checkExistingSlotsForDates(
        doctorId: doctorId,
        startDate: startDate,
        endDate: endDate,
      );

      return dateMap.values.any((hasSlots) => hasSlots);
    } catch (e) {
      throw Exception('Failed to check slots in range: $e');
    }
  }

  /// Create multiple slots at once
  Future<void> createSlots(List<SlotModel> slots) async {
    try {
      // Use smaller batches to avoid limits
      const batchSize = 500;
      
      for (int i = 0; i < slots.length; i += batchSize) {
        final batch = firestore.batch();
        final end = (i + batchSize < slots.length) ? i + batchSize : slots.length;
        
        for (int j = i; j < end; j++) {
          final docRef = firestore.collection('slots').doc();
          batch.set(docRef, slots[j].toFirestore());
        }
        
        await batch.commit();
      }
    } catch (e) {
      throw Exception('Failed to create slots: $e');
    }
  }

  /// Delete a specific slot (only if available and not too close to appointment time)
  Future<void> deleteSlot(String slotId) async {
    try {
      // Get slot details first
      final docSnapshot = await firestore.collection('slots').doc(slotId).get();
      
      if (!docSnapshot.exists) {
        throw Exception('Slot not found');
      }

      final slot = SlotModel.fromFirestore(docSnapshot);

      // Don't allow deletion if slot is booked
      if (slot.status == 'booked') {
        throw Exception('Cannot delete booked slots');
      }

      await firestore.collection('slots').doc(slotId).delete();
    } catch (e) {
      throw Exception('Failed to delete slot: $e');
    }
  }

  /// Update slot time (only if available and within 1 hour of creation)
  Future<void> updateSlot({
    required String slotId,
    required String startTime,
    required String endTime,
  }) async {
    try {
      // Get current slot details
      final docSnapshot = await firestore.collection('slots').doc(slotId).get();
      
      if (!docSnapshot.exists) {
        throw Exception('Slot not found');
      }

      final slot = SlotModel.fromFirestore(docSnapshot);

      // Check if slot is available
      if (slot.status != 'available') {
        throw Exception('Can only edit available slots');
      }

      // Check if slot is within 1 hour of creation time
      final now = DateTime.now();
      final timeSinceCreation = now.difference(slot.createdAt);

      if (timeSinceCreation.inMinutes > 60) {
        throw Exception('Cannot edit slots after 1 hour of creation');
      }

      await firestore.collection('slots').doc(slotId).update({
        'startTime': startTime,
        'endTime': endTime,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update slot: $e');
    }
  }

  /// Block a slot (make it unavailable)
  Future<void> blockSlot(String slotId) async {
    try {
      await firestore.collection('slots').doc(slotId).update({
        'status': 'blocked',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to block slot: $e');
    }
  }

  /// Delete all available slots for a specific date range
  Future<void> deleteSlotsInRange({
    required String doctorId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final normalizedStart = DateTime(startDate.year, startDate.month, startDate.day);
      final normalizedEnd = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

      final snapshot = await firestore
          .collection('slots')
          .where('doctorId', isEqualTo: doctorId)
          .get();

      final batch = firestore.batch();
      int count = 0;
      
      for (final doc in snapshot.docs) {
        final slot = SlotModel.fromFirestore(doc);
        final slotDate = DateTime(slot.date.year, slot.date.month, slot.date.day);
        
        // Only delete available slots within date range
        if (slot.status == 'available' &&
            !slotDate.isBefore(normalizedStart) &&
            !slotDate.isAfter(normalizedEnd)) {
          batch.delete(doc.reference);
          count++;
          
          // Commit in batches of 500
          if (count % 500 == 0) {
            await batch.commit();
          }
        }
      }

      // Commit remaining
      if (count % 500 != 0) {
        await batch.commit();
      }
    } catch (e) {
      throw Exception('Failed to delete slots in range: $e');
    }
  }
}