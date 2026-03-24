
import 'package:idoc_doctor_side/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/data/models/doctor_profile_stats_model.dart';

abstract class DoctorProfileState {
  const DoctorProfileState();
}

class DoctorProfileInitial extends DoctorProfileState {
  const DoctorProfileInitial();
}

class DoctorProfileLoading extends DoctorProfileState {
  const DoctorProfileLoading();
}

class DoctorProfileLoaded extends DoctorProfileState {
  final DoctorModel doctor;
  final DoctorProfileStats stats;
  final bool isStatsRefreshing;

  const DoctorProfileLoaded({
    required this.doctor,
    required this.stats,
    this.isStatsRefreshing = false,
  });

  DoctorProfileLoaded copyWith({
    DoctorModel? doctor,
    DoctorProfileStats? stats,
    bool? isStatsRefreshing,
  }) {
    return DoctorProfileLoaded(
      doctor: doctor ?? this.doctor,
      stats: stats ?? this.stats,
      isStatsRefreshing: isStatsRefreshing ?? this.isStatsRefreshing,
    );
  }
}

class DoctorProfileError extends DoctorProfileState {
  final String message;
  const DoctorProfileError(this.message);
}