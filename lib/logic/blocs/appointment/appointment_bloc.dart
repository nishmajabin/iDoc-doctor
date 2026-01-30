import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/data/services/appointment_service.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_event.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_state.dart';


class DoctorAppointmentBloc
    extends Bloc<DoctorAppointmentEvent, DoctorAppointmentState> {
  final DoctorAppointmentService service;

  DoctorAppointmentBloc(this.service)
      : super(DoctorAppointmentInitial()) {
    on<FetchDoctorAppointments>(_fetch);
    on<MarkAppointmentCompleted>(_complete);
    on<AddPrescriptionEvent>(_addPrescription);
  }

  Future<void> _fetch(
    FetchDoctorAppointments event,
    Emitter<DoctorAppointmentState> emit,
  ) async {
    try {
      emit(DoctorAppointmentLoading());

      final List<DoctorAppointmentModel> all =
          await service.fetchAppointments(event.doctorId);

      final DateTime now = DateTime.now();

      /// ✅ FIXED TYPES HERE
      final List<DoctorAppointmentModel> upcoming = [];
      final List<DoctorAppointmentModel> past = [];

      for (final appointment in all) {
        final appointmentDateTime = _combineDateTime(
          appointment.appointmentDate,
          appointment.startTime,
        );

        if (appointment.status == 'completed' ||
            appointmentDateTime.isBefore(now)) {
          past.add(appointment);
        } else {
          upcoming.add(appointment);
        }
      }

      emit(
        DoctorAppointmentLoaded(
          upcoming: upcoming,
          past: past,
        ),
      );
    } catch (e) {
      emit(
        DoctorAppointmentError(
          'Failed to load appointments: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _complete(
    MarkAppointmentCompleted event,
    Emitter<DoctorAppointmentState> emit,
  ) async {
    await service.markCompleted(event.appointmentId);
  }

  Future<void> _addPrescription(
    AddPrescriptionEvent event,
    Emitter<DoctorAppointmentState> emit,
  ) async {
    await service.addPrescription(
      event.appointmentId,
      event.prescription,
    );
  }

  /// Combines date + "HH:mm" time safely
  DateTime _combineDateTime(DateTime date, String time) {
    final parts = time.split(':');

    return DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }
}
