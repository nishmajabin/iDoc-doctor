import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_profile_stats_model.dart';
import 'package:idoc_doctor_side/core/data/repositories/profile_repository.dart';
import 'package:idoc_doctor_side/logic/blocs/profile/profile_event.dart';
import 'package:idoc_doctor_side/logic/blocs/profile/profile_state.dart';

class DoctorProfileBloc extends Bloc<DoctorProfileEvent, DoctorProfileState> {
  final DoctorProfileRepository _repository;

  // Flag to ensure we only auto-fetch stats once on first load
  bool _statsFetchedOnce = false;

  DoctorProfileBloc({DoctorProfileRepository? repository})
      : _repository = repository ?? DoctorProfileRepository(),
        super(const DoctorProfileInitial()) {
    on<LoadDoctorProfile>(_onLoad);
    on<RefreshProfileStats>(_onRefreshStats);
    on<StatsFetched>(_onStatsFetched);
  }

  // ── Load doctor (stream) ───────────────────────────────────────────────────

  Future<void> _onLoad(
    LoadDoctorProfile event,
    Emitter<DoctorProfileState> emit,
  ) async {
    emit(const DoctorProfileLoading());
    _statsFetchedOnce = false;

    try {
      await emit.forEach<Map<String, dynamic>?>(
        _repository.watchDoctor(event.doctorId),
        onData: (data) {
          if (data == null) {
            return const DoctorProfileError('Doctor not found');
          }

          final doctor = DoctorModel.fromMap(data, event.doctorId);

          // Preserve existing stats between document updates
          final currentStats = state is DoctorProfileLoaded
              ? (state as DoctorProfileLoaded).stats
              : DoctorProfileStats.empty();

          if (!_statsFetchedOnce) {
            _statsFetchedOnce = true;
            Future.microtask(
              () => add(RefreshProfileStats(doctorId: event.doctorId)),
            );
          }

          return DoctorProfileLoaded(
            doctor: doctor,
            stats: currentStats,
            // Only show spinner on the very first load
            isStatsRefreshing: !_statsFetchedOnce,
          );
        },
        onError: (_, __) =>
            const DoctorProfileError('Failed to load profile'),
      );
    } catch (e) {
      emit(DoctorProfileError(e.toString()));
    }
  }

  // ── Refresh stats (manual + auto first-load) ───────────────────────────────

  Future<void> _onRefreshStats(
    RefreshProfileStats event,
    Emitter<DoctorProfileState> emit,
  ) async {
    if (state is! DoctorProfileLoaded) return;
    final current = state as DoctorProfileLoaded;
    if (current.isStatsRefreshing) return; // prevent duplicate

    emit(current.copyWith(isStatsRefreshing: true));

    try {
      final stats = await _repository.fetchProfileStats(event.doctorId);
      add(StatsFetched(stats));
    } catch (_) {
      add(StatsFetched(current.stats)); // restore on error
    }
  }

  // ── Internal: apply fetched stats ───────────────────────────────────────

  void _onStatsFetched(
    StatsFetched event,
    Emitter<DoctorProfileState> emit,
  ) {
    if (state is! DoctorProfileLoaded) return;
    emit(
      (state as DoctorProfileLoaded).copyWith(
        stats: event.stats,
        isStatsRefreshing: false,
      ),
    );
  }
}