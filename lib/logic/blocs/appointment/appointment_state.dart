// import 'package:equatable/equatable.dart';
// import 'package:idoc_doctor_side/data/models/appointment_model.dart';

// abstract class DoctorAppointmentState extends Equatable {
//   const DoctorAppointmentState();

//   @override
//   List<Object?> get props => [];
// }

// class DoctorAppointmentInitial extends DoctorAppointmentState {}

// class DoctorAppointmentLoading extends DoctorAppointmentState {}

// class DoctorAppointmentLoaded extends DoctorAppointmentState {
//   final List<DoctorAppointmentModel> upcoming;
//   final List<DoctorAppointmentModel> past;

//   const DoctorAppointmentLoaded({
//     required this.upcoming,
//     required this.past,
//   });

//   @override
//   List<Object?> get props => [upcoming, past];
// }

// class DoctorAppointmentError extends DoctorAppointmentState {
//   final String message;

//   const DoctorAppointmentError(this.message);

//   @override
//   List<Object?> get props => [message];
// }

// class AppointmentActionSuccess extends DoctorAppointmentState {
//   final String message;

//   const AppointmentActionSuccess(this.message);

//   @override
//   List<Object?> get props => [message];
// }

import 'package:equatable/equatable.dart';
import 'package:idoc_doctor_side/data/models/appointment_model.dart';

abstract class DoctorAppointmentState extends Equatable {
  const DoctorAppointmentState();

  @override
  List<Object?> get props => [];
}

class DoctorAppointmentInitial extends DoctorAppointmentState {}

class DoctorAppointmentLoading extends DoctorAppointmentState {}

class DoctorAppointmentLoaded extends DoctorAppointmentState {
  final List<DoctorAppointmentModel> upcoming;
  final List<DoctorAppointmentModel> past;
  final bool isUpcomingSelected; // ← NEW: replaces setState

  const DoctorAppointmentLoaded({
    required this.upcoming,
    required this.past,
    this.isUpcomingSelected = true, // default to upcoming tab
  });

  DoctorAppointmentLoaded copyWith({
    List<DoctorAppointmentModel>? upcoming,
    List<DoctorAppointmentModel>? past,
    bool? isUpcomingSelected,
  }) {
    return DoctorAppointmentLoaded(
      upcoming: upcoming ?? this.upcoming,
      past: past ?? this.past,
      isUpcomingSelected: isUpcomingSelected ?? this.isUpcomingSelected,
    );
  }

  @override
  List<Object?> get props => [upcoming, past, isUpcomingSelected];
}

class DoctorAppointmentError extends DoctorAppointmentState {
  final String message;

  const DoctorAppointmentError(this.message);

  @override
  List<Object?> get props => [message];
}
class AppointmentActionSuccess extends DoctorAppointmentState {
  final String message;

  const AppointmentActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}