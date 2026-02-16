// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:idoc_doctor_side/data/models/appointment_model.dart';
// import 'package:idoc_doctor_side/data/services/appointment_service.dart';
// import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_event.dart';
// import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_state.dart';

// class DoctorAppointmentBloc extends Bloc<DoctorAppointmentEvent, DoctorAppointmentState> {
//   final DoctorAppointmentService service;

//   DoctorAppointmentBloc(this.service) : super(DoctorAppointmentInitial()) {
//     on<FetchDoctorAppointments>(_onFetchAppointments);
//     on<MarkAppointmentCompleted>(_onMarkCompleted);
//     on<AddPrescriptionEvent>(_onAddPrescription);
//   }

//   Future<void> _onFetchAppointments(
//     FetchDoctorAppointments event,
//     Emitter<DoctorAppointmentState> emit,
//   ) async {
//     try {
//       emit(DoctorAppointmentLoading());

//       final List<DoctorAppointmentModel> all = await service.fetchAppointments(event.doctorId);

//       final DateTime now = DateTime.now();

//       // Separate appointments into upcoming and past
//       final List<DoctorAppointmentModel> upcoming = [];
//       final List<DoctorAppointmentModel> past = [];

//       for (final appointment in all) {
//         final appointmentDateTime = _combineDateTime(
//           appointment.appointmentDate,
//           appointment.startTime,
//         );

//         // Past: completed status OR appointment time has passed
//         if (appointment.status.toLowerCase() == 'completed' ||
//             appointmentDateTime.isBefore(now)) {
//           past.add(appointment);
//         } else {
//           // Upcoming: confirmed, pending, or future appointments
//           upcoming.add(appointment);
//         }
//       }

//       // Sort upcoming by date/time (earliest first)
//       upcoming.sort((a, b) {
//         final dateCompare = a.appointmentDate.compareTo(b.appointmentDate);
//         if (dateCompare != 0) return dateCompare;
//         return a.startTime.compareTo(b.startTime);
//       });

//       // Sort past by date/time (most recent first)
//       past.sort((a, b) {
//         final dateCompare = b.appointmentDate.compareTo(a.appointmentDate);
//         if (dateCompare != 0) return dateCompare;
//         return b.startTime.compareTo(a.startTime);
//       });

//       emit(DoctorAppointmentLoaded(
//         upcoming: upcoming,
//         past: past,
//       ));
//     } catch (e) {
//       emit(DoctorAppointmentError('Failed to load appointments: ${e.toString()}'));
//     }
//   }

//   Future<void> _onMarkCompleted(
//     MarkAppointmentCompleted event,
//     Emitter<DoctorAppointmentState> emit,
//   ) async {
//     try {
//       await service.markCompleted(event.appointmentId);

//       // Refresh appointments after marking as completed
//       if (state is DoctorAppointmentLoaded) {
//         // You may want to store doctorId in the bloc to refresh properly
//         emit(const AppointmentActionSuccess('Appointment marked as completed'));
//       }
//     } catch (e) {
//       emit(DoctorAppointmentError('Failed to mark appointment as completed: ${e.toString()}'));
//     }
//   }

//   Future<void> _onAddPrescription(
//     AddPrescriptionEvent event,
//     Emitter<DoctorAppointmentState> emit,
//   ) async {
//     try {
//       print('=== BLoC: Adding Prescription ===');
//       print('Appointment ID: ${event.appointmentId}');
//       print('Prescription: ${event.prescription}');

//       await service.addPrescription(
//         event.appointmentId,
//         event.prescription,
//       );

//       print('✅ BLoC: Prescription added successfully');

//       emit(const AppointmentActionSuccess('Prescription added successfully'));
//     } catch (e) {
//       print('❌ BLoC: Error adding prescription: $e');
//       emit(DoctorAppointmentError('Failed to add prescription: ${e.toString()}'));
//     }
//   }

//   DateTime _combineDateTime(DateTime date, String time) {
//     try {
//       final parts = time.split(':');
//       return DateTime(
//         date.year,
//         date.month,
//         date.day,
//         int.parse(parts[0]),
//         int.parse(parts[1]),
//       );
//     } catch (e) {
//       return DateTime(date.year, date.month, date.day);
//     }
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/data/services/appointment_service.dart';
import 'appointment_event.dart';
import 'appointment_state.dart';

class DoctorAppointmentBloc
    extends Bloc<DoctorAppointmentEvent, DoctorAppointmentState> {
  final DoctorAppointmentService service;

  // Stored so actions like MarkCompleted can auto-refresh the list.
  String? _lastDoctorId;

  DoctorAppointmentBloc(this.service)
    : super( DoctorAppointmentInitial()) {
    on<FetchDoctorAppointments>(_onFetchAppointments);
    on<RefreshDoctorAppointments>(_onRefreshAppointments);
    on<MarkAppointmentCompleted>(_onMarkCompleted);
    on<AddPrescriptionEvent>(_onAddPrescription);
    on<SwitchAppointmentTab>(_onSwitchTab);
  }

  // ── Handlers ────────────────────────────────────────────────────────────────

  Future<void> _onFetchAppointments(
    FetchDoctorAppointments event,
    Emitter<DoctorAppointmentState> emit,
  ) async {
    // Don't re-fetch if already loaded (prevents duplicate fetches on rebuild).
    // To force a refresh, dispatch RefreshDoctorAppointments instead.
    if (state is DoctorAppointmentLoaded) return;

    emit( DoctorAppointmentLoading());
    await _loadAppointments(event.doctorId, emit);
  }

  Future<void> _onRefreshAppointments(
    RefreshDoctorAppointments event,
    Emitter<DoctorAppointmentState> emit,
  ) async {
    // Keep current list visible — no loading spinner shown.
    await _loadAppointments(event.doctorId, emit);
  }

  Future<void> _onMarkCompleted(
    MarkAppointmentCompleted event,
    Emitter<DoctorAppointmentState> emit,
  ) async {
    try {
      await service.markCompleted(event.appointmentId);
      emit(const AppointmentActionSuccess('Appointment marked as completed'));

      // Auto-refresh the list so the card moves to the past section.
      if (_lastDoctorId != null) {
        await _loadAppointments(_lastDoctorId!, emit);
      }
    } catch (e) {
      emit(
        DoctorAppointmentError(
          'Failed to mark appointment as completed: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onAddPrescription(
    AddPrescriptionEvent event,
    Emitter<DoctorAppointmentState> emit,
  ) async {
    try {
      await service.addPrescription(event.appointmentId, event.prescription);
      emit(const AppointmentActionSuccess('Prescription added successfully'));

      // Auto-refresh so the updated prescription is reflected immediately.
      if (_lastDoctorId != null) {
        await _loadAppointments(_lastDoctorId!, emit);
      }
    } catch (e) {
      emit(
        DoctorAppointmentError('Failed to add prescription: ${e.toString()}'),
      );
    }
  }

  // ── Private helpers ─────────────────────────────────────────────────────────

  Future<void> _loadAppointments(
    String doctorId,
    Emitter<DoctorAppointmentState> emit,
  ) async {
    try {
      _lastDoctorId = doctorId;

      final List<DoctorAppointmentModel> all = await service.fetchAppointments(
        doctorId,
      );

      final DateTime now = DateTime.now();
      final upcoming = <DoctorAppointmentModel>[];
      final past = <DoctorAppointmentModel>[];

      for (final appointment in all) {
        final appointmentDateTime = _combineDateTime(
          appointment.appointmentDate,
          appointment.startTime,
        );

        // Past: explicitly completed/cancelled OR appointment time has passed
        if (appointment.status.toLowerCase() == 'completed' ||
            appointment.status.toLowerCase() == 'cancelled' ||
            appointmentDateTime.isBefore(now)) {
          past.add(appointment);
        } else {
          // Upcoming: confirmed, pending, or any future appointment
          upcoming.add(appointment);
        }
      }

      // Sort upcoming: earliest first
      upcoming.sort((a, b) {
        final dateCompare = a.appointmentDate.compareTo(b.appointmentDate);
        if (dateCompare != 0) return dateCompare;
        return a.startTime.compareTo(b.startTime);
      });

      // Sort past: most recent first
      past.sort((a, b) {
        final dateCompare = b.appointmentDate.compareTo(a.appointmentDate);
        if (dateCompare != 0) return dateCompare;
        return b.startTime.compareTo(a.startTime);
      });

      emit(DoctorAppointmentLoaded(upcoming: upcoming, past: past));
    } catch (e) {
      emit(
        DoctorAppointmentError('Failed to load appointments: ${e.toString()}'),
      );
    }
  }

  DateTime _combineDateTime(DateTime date, String time) {
    try {
      final parts = time.split(':');
      return DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
    } catch (_) {
      return DateTime(date.year, date.month, date.day);
    }
  }

   void _onSwitchTab(
    SwitchAppointmentTab event,
    Emitter<DoctorAppointmentState> emit,
  ) {
    final current = state;
    if (current is DoctorAppointmentLoaded) {
      emit(current.copyWith(isUpcomingSelected: event.isUpcoming));
    }
  }
}
