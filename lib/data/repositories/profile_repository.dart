import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:idoc_doctor_side/data/models/doctor_profile_stats_model.dart';

class _AppointmentFields {
  static const String doctorId         = 'doctorId';
  static const String patientId        = 'userId';      
  static const String status           = 'status';
  static const String consultationFee  = 'consultationFee'; 
  static const String paymentStatus    = 'paymentStatus';
  static const String appointmentDate  = 'appointmentDate'; 
}

class _AppointmentStatus {
  static const String confirmed = 'confirmed';
  static const String completed = 'completed';
  static const String pending   = 'pending';
  static const String cancelled = 'cancelled';
}

class DoctorProfileRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  DoctorProfileRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;


  Stream<Map<String, dynamic>?> watchDoctor(String doctorId) {
    return _firestore
        .collection('doctors')
        .doc(doctorId)
        .snapshots()
        .map((snap) => snap.exists ? {'id': snap.id, ...snap.data()!} : null);
  }

  Future<DoctorProfileStats> fetchProfileStats(String doctorId) async {
    try {
      final completedSnap = await _firestore
          .collection('appointments')
          .where(_AppointmentFields.doctorId, isEqualTo: doctorId)
          .where(_AppointmentFields.status, isEqualTo: _AppointmentStatus.completed)
          .get();

      final confirmedSnap = await _firestore
          .collection('appointments')
          .where(_AppointmentFields.doctorId, isEqualTo: doctorId)
          .where(_AppointmentFields.status, isEqualTo: _AppointmentStatus.confirmed)
          .where(_AppointmentFields.paymentStatus, isEqualTo: 'paid')
          .get();

      final pendingSnap = await _firestore
          .collection('appointments')
          .where(_AppointmentFields.doctorId, isEqualTo: doctorId)
          .where(_AppointmentFields.status, isEqualTo: _AppointmentStatus.pending)
          .get();

      // ── Aggregate ─────────────────────────────────────────────────────────
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);

      double totalRevenue = 0;
      double thisMonthRevenue = 0;
      int thisMonthAppointments = 0;
      final Set<String> uniquePatients = {};

      void _processDoc(QueryDocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;

        // ── Fee: field is 'consultationFee' (set by PaymentBloc) ────────────
        final fee = _extractFee(data);
        totalRevenue += fee;

        // ── Patient deduplication ─────────────────────────────────────────
        final patientId = data[_AppointmentFields.patientId] as String?;
        if (patientId != null && patientId.isNotEmpty) {
          uniquePatients.add(patientId);
        }

        // ── Monthly filter ────────────────────────────────────────────────
        // Use appointmentDate (always present) since completedAt may be missing
        final appointmentDate = _extractDate(data);
        if (appointmentDate != null && appointmentDate.isAfter(startOfMonth)) {
          thisMonthRevenue += fee;
          thisMonthAppointments++;
        }
      }

      for (final doc in completedSnap.docs) {
        _processDoc(doc);
      }
      for (final doc in confirmedSnap.docs) {
        _processDoc(doc);
      }

      return DoctorProfileStats(
        totalRevenue: totalRevenue,
        thisMonthRevenue: thisMonthRevenue,
        totalCompletedAppointments: completedSnap.docs.length,
        totalConfirmedAppointments: confirmedSnap.docs.length,
        thisMonthAppointments: thisMonthAppointments,
        totalPatients: uniquePatients.length,
        pendingAppointments: pendingSnap.docs.length,
      );
    } catch (e, stack) {
      // Log but don't crash — return zeros so the profile still loads
      assert(() {
        // ignore: avoid_print
        print('[DoctorProfileRepository] fetchProfileStats error: $e\n$stack');
        return true;
      }());
      return DoctorProfileStats.empty();
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Safely extracts the consultation fee.
  /// PaymentBloc writes 'consultationFee'; older records may use 'fee'.
  double _extractFee(Map<String, dynamic> data) {
    final fee = data[_AppointmentFields.consultationFee]
        ?? data['fee']          // fallback for legacy records
        ?? 0;
    return (fee as num).toDouble();
  }

  /// Prefers completedAt → appointmentDate for the monthly filter.
  DateTime? _extractDate(Map<String, dynamic> data) {
    final completedAt = (data['completedAt'] as Timestamp?)?.toDate();
    if (completedAt != null) return completedAt;

    final appointmentDate = data[_AppointmentFields.appointmentDate];
    if (appointmentDate is Timestamp) return appointmentDate.toDate();
    if (appointmentDate is String) {
      return DateTime.tryParse(appointmentDate);
    }
    return null;
  }
}