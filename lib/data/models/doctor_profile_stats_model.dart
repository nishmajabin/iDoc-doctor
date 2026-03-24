/// Matches the exact Firestore field names written by PaymentBloc
class DoctorProfileStats {
  final double totalRevenue;
  final double thisMonthRevenue;
  final int totalCompletedAppointments; // status == 'completed'
  final int totalConfirmedAppointments; // status == 'confirmed' (paid but not yet consulted)
  final int thisMonthAppointments;
  final int totalPatients;
  final int pendingAppointments;

  const DoctorProfileStats({
    required this.totalRevenue,
    required this.thisMonthRevenue,
    required this.totalCompletedAppointments,
    required this.totalConfirmedAppointments,
    required this.thisMonthAppointments,
    required this.totalPatients,
    required this.pendingAppointments,
  });

  factory DoctorProfileStats.empty() => const DoctorProfileStats(
        totalRevenue: 0,
        thisMonthRevenue: 0,
        totalCompletedAppointments: 0,
        totalConfirmedAppointments: 0,
        thisMonthAppointments: 0,
        totalPatients: 0,
        pendingAppointments: 0,
      );

  /// Revenue-earning appointments = completed + confirmed (both are paid)
  int get totalPaidAppointments =>
      totalCompletedAppointments + totalConfirmedAppointments;

  DoctorProfileStats copyWith({
    double? totalRevenue,
    double? thisMonthRevenue,
    int? totalCompletedAppointments,
    int? totalConfirmedAppointments,
    int? thisMonthAppointments,
    int? totalPatients,
    int? pendingAppointments,
  }) {
    return DoctorProfileStats(
      totalRevenue: totalRevenue ?? this.totalRevenue,
      thisMonthRevenue: thisMonthRevenue ?? this.thisMonthRevenue,
      totalCompletedAppointments:
          totalCompletedAppointments ?? this.totalCompletedAppointments,
      totalConfirmedAppointments:
          totalConfirmedAppointments ?? this.totalConfirmedAppointments,
      thisMonthAppointments:
          thisMonthAppointments ?? this.thisMonthAppointments,
      totalPatients: totalPatients ?? this.totalPatients,
      pendingAppointments: pendingAppointments ?? this.pendingAppointments,
    );
  }
}