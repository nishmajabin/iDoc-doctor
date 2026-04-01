import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:idoc_doctor_side/core/handlers/slot/slot_firestore_handler.dart';
import 'package:idoc_doctor_side/core/data/models/slot_model.dart';

class SlotService {
  SlotService(FirebaseFirestore firestore)
      : _handler = SlotFirestoreHandler(firestore);

  final SlotFirestoreHandler _handler;

  // ── Fetch ─────────────────────────────────────────────────────────────────

  Future<List<SlotModel>> fetchSlotsByDateRange({
    required String doctorId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      return await _handler.fetchByDateRange(
        doctorId: doctorId,
        start: _startOf(startDate),
        end: _endOf(endDate),
      );
    } catch (e) {
      throw Exception('Failed to fetch slots: $e');
    }
  }

  Future<Map<DateTime, bool>> checkExistingSlotsForDates({
    required String doctorId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final start = _normalizeDate(startDate);
      final end = _normalizeDate(endDate);
      final slots = await _handler.fetchAllByDoctor(doctorId);

      final Map<DateTime, bool> dateMap = {};
      for (var d = start; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
        dateMap[d] = false;
      }
      for (final slot in slots) {
        final slotDate = _normalizeDate(slot.date);
        if (dateMap.containsKey(slotDate)) dateMap[slotDate] = true;
      }

      return dateMap;
    } catch (e) {
      throw Exception('Failed to check existing slots: $e');
    }
  }

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

  // ── Write ─────────────────────────────────────────────────────────────────

  Future<void> createSlots(List<SlotModel> slots) async {
    try {
      await _handler.createSlots(slots);
    } catch (e) {
      throw Exception('Failed to create slots: $e');
    }
  }

  Future<void> deleteSlot(String slotId) async {
    try {
      final slot = await _handler.fetchById(slotId);
      if (slot.status == 'booked') throw Exception('Cannot delete booked slots');
      await _handler.deleteSlot(slotId);
    } catch (e) {
      throw Exception('Failed to delete slot: $e');
    }
  }

  Future<void> updateSlot({
    required String slotId,
    required String startTime,
    required String endTime,
  }) async {
    try {
      final slot = await _handler.fetchById(slotId);
      if (slot.status != 'available') throw Exception('Can only edit available slots');
      if (DateTime.now().difference(slot.createdAt).inMinutes > 60) {
        throw Exception('Cannot edit slots after 1 hour of creation');
      }
      await _handler.updateSlotTime(slotId: slotId, startTime: startTime, endTime: endTime);
    } catch (e) {
      throw Exception('Failed to update slot: $e');
    }
  }

  Future<void> blockSlot(String slotId) async {
    try {
      await _handler.blockSlot(slotId);
    } catch (e) {
      throw Exception('Failed to block slot: $e');
    }
  }

  Future<void> deleteSlotsInRange({
    required String doctorId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      await _handler.deleteSlotsInRange(
        doctorId: doctorId,
        start: _normalizeDate(startDate),
        end: _endOf(endDate),
      );
    } catch (e) {
      throw Exception('Failed to delete slots in range: $e');
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  DateTime _normalizeDate(DateTime d) => DateTime(d.year, d.month, d.day);
  DateTime _startOf(DateTime d) => DateTime(d.year, d.month, d.day);
  DateTime _endOf(DateTime d) => DateTime(d.year, d.month, d.day, 23, 59, 59);
}