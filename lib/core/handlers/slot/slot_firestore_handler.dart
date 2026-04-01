import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:idoc_doctor_side/core/data/models/slot_model.dart';

class SlotFirestoreHandler {
  SlotFirestoreHandler(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _slots =>
      _firestore.collection('slots');

  // ── Fetch ─────────────────────────────────────────────────────────────────

  Future<List<SlotModel>> fetchByDateRange({
    required String doctorId,
    required DateTime start,
    required DateTime end,
  }) async {
    try {
      final snap = await _slots
          .where('doctorId', isEqualTo: doctorId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(end))
          .orderBy('date')
          .orderBy('startTime')
          .get();
      return snap.docs.map(SlotModel.fromFirestore).toList();
    } catch (_) {
      final snap = await _slots.where('doctorId', isEqualTo: doctorId).get();
      return snap.docs
          .map(SlotModel.fromFirestore)
          .where((s) {
            final d = _normalizeDate(s.date);
            return !d.isBefore(start) && !d.isAfter(end);
          })
          .toList()
        ..sort((a, b) {
          final cmp = a.date.compareTo(b.date);
          return cmp != 0 ? cmp : a.startTime.compareTo(b.startTime);
        });
    }
  }

  Future<List<SlotModel>> fetchAllByDoctor(String doctorId) async {
    final snap = await _slots.where('doctorId', isEqualTo: doctorId).get();
    return snap.docs.map(SlotModel.fromFirestore).toList();
  }

  Future<SlotModel> fetchById(String slotId) async {
    final doc = await _slots.doc(slotId).get();
    if (!doc.exists) throw Exception('Slot not found');
    return SlotModel.fromFirestore(doc);
  }

  // ── Write ─────────────────────────────────────────────────────────────────

  Future<void> createSlots(List<SlotModel> slots) async {
    const batchSize = 500;
    for (int i = 0; i < slots.length; i += batchSize) {
      final batch = _firestore.batch();
      final end = (i + batchSize).clamp(0, slots.length);
      for (int j = i; j < end; j++) {
        batch.set(_slots.doc(), slots[j].toFirestore());
      }
      await batch.commit();
    }
  }

  Future<void> deleteSlot(String slotId) => _slots.doc(slotId).delete();

  Future<void> updateSlotTime({
    required String slotId,
    required String startTime,
    required String endTime,
  }) =>
      _slots.doc(slotId).update({
        'startTime': startTime,
        'endTime': endTime,
        'updatedAt': FieldValue.serverTimestamp(),
      });

  Future<void> blockSlot(String slotId) =>
      _slots.doc(slotId).update({
        'status': 'blocked',
        'updatedAt': FieldValue.serverTimestamp(),
      });

  Future<void> deleteSlotsInRange({
    required String doctorId,
    required DateTime start,
    required DateTime end,
  }) async {
    final snap = await _slots.where('doctorId', isEqualTo: doctorId).get();

    WriteBatch batch = _firestore.batch();
    int count = 0;

    for (final doc in snap.docs) {
      final slot = SlotModel.fromFirestore(doc);
      final slotDate = _normalizeDate(slot.date);

      if (slot.status == 'available' &&
          !slotDate.isBefore(start) &&
          !slotDate.isAfter(end)) {
        batch.delete(doc.reference);
        count++;

        if (count % 500 == 0) {
          await batch.commit();
          batch = _firestore.batch();
        }
      }
    }

    if (count % 500 != 0) await batch.commit();
  }

  // ── Helper ────────────────────────────────────────────────────────────────

  DateTime _normalizeDate(DateTime d) => DateTime(d.year, d.month, d.day);
}