import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/repositories/profile_repository.dart';
import 'revenue_filter_state.dart';

class RevenueFilterCubit extends Cubit<RevenueFilterState> {
  final DoctorProfileRepository _repository;
  final String _doctorId;

  RevenueFilterCubit({
    required DoctorProfileRepository repository,
    required String doctorId,
  })  : _repository = repository,
        _doctorId = doctorId,
        super(const RevenueFilterState());

  Future<void> applyDateRange(DateTime start, DateTime end) async {
    final normalizedStart = DateTime(start.year, start.month, start.day);
    final normalizedEnd = DateTime(end.year, end.month, end.day, 23, 59, 59);

    emit(state.copyWith(
      startDate: normalizedStart,
      endDate: normalizedEnd,
      status: RevenueFilterStatus.loading,
      clearError: true,
    ));

    try {
      final result = await _repository.fetchRevenueForRange(
        doctorId: _doctorId,
        start: normalizedStart,
        end: normalizedEnd,
      );

      emit(state.copyWith(
        filteredRevenue: result.revenue,
        filteredAppointments: result.appointmentCount,
        status: RevenueFilterStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RevenueFilterStatus.error,
        errorMessage: 'Failed to fetch revenue for selected range.',
      ));
    }
  }

  void clearFilter() {
    emit(const RevenueFilterState());
  }
}