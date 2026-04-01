
import 'package:idoc_doctor_side/core/data/models/doctor_profile_stats_model.dart';

abstract class DoctorProfileEvent {
  const DoctorProfileEvent();
}

/// Start streaming the doctor Firestore document.
/// [doctorId] = DoctorModel.id (Firestore document ID, NOT Firebase Auth UID).
class LoadDoctorProfile extends DoctorProfileEvent {
  final String doctorId;
  const LoadDoctorProfile(this.doctorId);
}

/// Re-fetch revenue/appointment stats.
/// [doctorId] = same Firestore document ID.
class RefreshProfileStats extends DoctorProfileEvent {
  final String doctorId;
  const RefreshProfileStats({required this.doctorId});
}

/// Internal event — applied when the Firestore stats query resolves.
class StatsFetched extends DoctorProfileEvent {
  final DoctorProfileStats stats;
  const StatsFetched(this.stats);
}