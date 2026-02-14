import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/data/services/appointment_service.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_event.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_state.dart';

class DoctorAppointmentBloc extends Bloc<DoctorAppointmentEvent, DoctorAppointmentState> {
  final DoctorAppointmentService service;

  DoctorAppointmentBloc(this.service) : super(DoctorAppointmentInitial()) {
    on<FetchDoctorAppointments>(_onFetchAppointments);
    on<MarkAppointmentCompleted>(_onMarkCompleted);
    on<AddPrescriptionEvent>(_onAddPrescription);
  }

  Future<void> _onFetchAppointments(
    FetchDoctorAppointments event,
    Emitter<DoctorAppointmentState> emit,
  ) async {
    try {
      emit(DoctorAppointmentLoading());

      final List<DoctorAppointmentModel> all = await service.fetchAppointments(event.doctorId);

      final DateTime now = DateTime.now();

      // Separate appointments into upcoming and past
      final List<DoctorAppointmentModel> upcoming = [];
      final List<DoctorAppointmentModel> past = [];

      for (final appointment in all) {
        final appointmentDateTime = _combineDateTime(
          appointment.appointmentDate,
          appointment.startTime,
        );

        // Past: completed status OR appointment time has passed
        if (appointment.status.toLowerCase() == 'completed' ||
            appointmentDateTime.isBefore(now)) {
          past.add(appointment);
        } else {
          // Upcoming: confirmed, pending, or future appointments
          upcoming.add(appointment);
        }
      }

      // Sort upcoming by date/time (earliest first)
      upcoming.sort((a, b) {
        final dateCompare = a.appointmentDate.compareTo(b.appointmentDate);
        if (dateCompare != 0) return dateCompare;
        return a.startTime.compareTo(b.startTime);
      });

      // Sort past by date/time (most recent first)
      past.sort((a, b) {
        final dateCompare = b.appointmentDate.compareTo(a.appointmentDate);
        if (dateCompare != 0) return dateCompare;
        return b.startTime.compareTo(a.startTime);
      });

      emit(DoctorAppointmentLoaded(
        upcoming: upcoming,
        past: past,
      ));
    } catch (e) {
      emit(DoctorAppointmentError('Failed to load appointments: ${e.toString()}'));
    }
  }

  Future<void> _onMarkCompleted(
    MarkAppointmentCompleted event,
    Emitter<DoctorAppointmentState> emit,
  ) async {
    try {
      await service.markCompleted(event.appointmentId);
      
      // Refresh appointments after marking as completed
      if (state is DoctorAppointmentLoaded) {
        // You may want to store doctorId in the bloc to refresh properly
        emit(const AppointmentActionSuccess('Appointment marked as completed'));
      }
    } catch (e) {
      emit(DoctorAppointmentError('Failed to mark appointment as completed: ${e.toString()}'));
    }
  }

  Future<void> _onAddPrescription(
    AddPrescriptionEvent event,
    Emitter<DoctorAppointmentState> emit,
  ) async {
    try {
      print('=== BLoC: Adding Prescription ===');
      print('Appointment ID: ${event.appointmentId}');
      print('Prescription: ${event.prescription}');
      
      await service.addPrescription(
        event.appointmentId,
        event.prescription,
      );
      
      print('✅ BLoC: Prescription added successfully');
      
      emit(const AppointmentActionSuccess('Prescription added successfully'));
    } catch (e) {
      print('❌ BLoC: Error adding prescription: $e');
      emit(DoctorAppointmentError('Failed to add prescription: ${e.toString()}'));
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
    } catch (e) {
      return DateTime(date.year, date.month, date.day);
    }
  }
}