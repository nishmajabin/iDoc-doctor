import 'package:idoc_doctor_side/core/data/models/appointment_model.dart';

class SearchPatientsState {
  final List<DoctorAppointmentModel> allAppointments;
  final List<DoctorAppointmentModel> searchResults;
  final bool isSearching;
  final String query;

  const SearchPatientsState({
    this.allAppointments = const [],
    this.searchResults   = const [],
    this.isSearching     = false,
    this.query           = '',
  });

  SearchPatientsState copyWith({
    List<DoctorAppointmentModel>? allAppointments,
    List<DoctorAppointmentModel>? searchResults,
    bool? isSearching,
    String? query,
  }) {
    return SearchPatientsState(
      allAppointments: allAppointments ?? this.allAppointments,
      searchResults:   searchResults   ?? this.searchResults,
      isSearching:     isSearching     ?? this.isSearching,
      query:           query           ?? this.query,
    );
  }
}