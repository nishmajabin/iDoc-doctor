import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_profile_stats_model.dart';

class _AppointmentFields {
  static const String doctorId        = 'doctorId';
  static const String patientId       = 'userId';
  static const String status          = 'status';
  static const String consultationFee = 'consultationFee';
  static const String paymentStatus   = 'paymentStatus';
  static const String appointmentDate = 'appointmentDate';
}

class _AppointmentStatus {
  static const String confirmed  = 'confirmed';
  static const String completed  = 'completed';
  static const String pending    = 'pending';
  static const String cancelled  = 'cancelled';
}

class DoctorProfileFirestoreHandler {
  DoctorProfileFirestoreHandler({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _appointments =>
      _firestore.collection('appointments');

  // ── Streams ───────────────────────────────────────────────────────────────

  Stream<Map<String, dynamic>?> watchDoctor(String doctorId) =>
      _firestore.collection('doctors').doc(doctorId).snapshots().map(
            (snap) => snap.exists ? {'id': snap.id, ...snap.data()!} : null,
          );

  // ── Stats ─────────────────────────────────────────────────────────────────

  Future<DoctorProfileStats> fetchProfileStats(String doctorId) async {
    final results = await Future.wait([
      _appointments
          .where(_AppointmentFields.doctorId, isEqualTo: doctorId)
          .where(_AppointmentFields.status, isEqualTo: _AppointmentStatus.completed)
          .get(),
      _appointments
          .where(_AppointmentFields.doctorId, isEqualTo: doctorId)
          .where(_AppointmentFields.status, isEqualTo: _AppointmentStatus.confirmed)
          .where(_AppointmentFields.paymentStatus, isEqualTo: 'paid')
          .get(),
      _appointments
          .where(_AppointmentFields.doctorId, isEqualTo: doctorId)
          .where(_AppointmentFields.status, isEqualTo: _AppointmentStatus.pending)
          .get(),
    ]);

    final completedSnap = results[0];
    final confirmedSnap = results[1];
    final pendingSnap   = results[2];

    return _aggregate(
      completedDocs: completedSnap.docs,
      confirmedDocs: confirmedSnap.docs,
      pendingCount: pendingSnap.docs.length,
    );
  }

  // ── Aggregation ───────────────────────────────────────────────────────────

  DoctorProfileStats _aggregate({
    required List<QueryDocumentSnapshot<Map<String, dynamic>>> completedDocs,
    required List<QueryDocumentSnapshot<Map<String, dynamic>>> confirmedDocs,
    required int pendingCount,
  }) {
    final startOfMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);

    double totalRevenue = 0;
    double thisMonthRevenue = 0;
    int thisMonthAppointments = 0;
    final Set<String> uniquePatients = {};

    void process(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
      final data = doc.data();
      final fee = _extractFee(data);
      totalRevenue += fee;

      final patientId = data[_AppointmentFields.patientId] as String?;
      if (patientId != null && patientId.isNotEmpty) uniquePatients.add(patientId);

      final date = _extractDate(data);
      if (date != null && date.isAfter(startOfMonth)) {
        thisMonthRevenue += fee;
        thisMonthAppointments++;
      }
    }

    for (final doc in [...completedDocs, ...confirmedDocs]) {
      process(doc);
    }

    return DoctorProfileStats(
      totalRevenue: totalRevenue,
      thisMonthRevenue: thisMonthRevenue,
      totalCompletedAppointments: completedDocs.length,
      totalConfirmedAppointments: confirmedDocs.length,
      thisMonthAppointments: thisMonthAppointments,
      totalPatients: uniquePatients.length,
      pendingAppointments: pendingCount,
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  double _extractFee(Map<String, dynamic> data) =>
      ((data[_AppointmentFields.consultationFee] ?? data['fee'] ?? 0) as num).toDouble();

  DateTime? _extractDate(Map<String, dynamic> data) {
    final completedAt = (data['completedAt'] as Timestamp?)?.toDate();
    if (completedAt != null) return completedAt;

    final date = data[_AppointmentFields.appointmentDate];
    if (date is Timestamp) return date.toDate();
    if (date is String) return DateTime.tryParse(date);
    return null;
  }
}