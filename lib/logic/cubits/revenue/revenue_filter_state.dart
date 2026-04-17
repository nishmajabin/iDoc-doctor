import 'package:equatable/equatable.dart';

enum RevenueFilterStatus { initial, loading, success, error }

class RevenueFilterState extends Equatable {
  final DateTime? startDate;
  final DateTime? endDate;
  final double filteredRevenue;
  final int filteredAppointments;
  final RevenueFilterStatus status;
  final String? errorMessage;

  const RevenueFilterState({
    this.startDate,
    this.endDate,
    this.filteredRevenue = 0,
    this.filteredAppointments = 0,
    this.status = RevenueFilterStatus.initial,
    this.errorMessage,
  });

  bool get hasRange => startDate != null && endDate != null;

  String get formattedRange {
    if (!hasRange) return 'Select date range';
    final fmt = _formatDate;
    return '${fmt(startDate!)} – ${fmt(endDate!)}';
  }

  static String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]} ${d.year}';

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  RevenueFilterState copyWith({
    DateTime? startDate,
    DateTime? endDate,
    double? filteredRevenue,
    int? filteredAppointments,
    RevenueFilterStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RevenueFilterState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      filteredRevenue: filteredRevenue ?? this.filteredRevenue,
      filteredAppointments: filteredAppointments ?? this.filteredAppointments,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        startDate, endDate, filteredRevenue,
        filteredAppointments, status, errorMessage,
      ];
}