import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/logic/cubits/patient/search_patient/search_patient_state.dart';

class SearchPatientsCubit extends Cubit<SearchPatientsState> {
  SearchPatientsCubit() : super(const SearchPatientsState());

  void updateAppointments(List<DoctorAppointmentModel> all) {
    // Re-run active search against the fresh list
    final results = state.isSearching && state.query.isNotEmpty
        ? all
            .where((a) =>
                a.patientName.toLowerCase().contains(state.query))
            .toList()
        : <DoctorAppointmentModel>[];

    emit(state.copyWith(allAppointments: all, searchResults: results));
  }

  void onQueryChanged(String raw) {
    final query = raw.trim().toLowerCase();

    if (query.isEmpty) {
      emit(state.copyWith(
        query:         '',
        isSearching:   false,
        searchResults: [],
      ));
      return;
    }

    // Guard: appointments must be loaded before searching
    if (state.allAppointments.isEmpty) return;

    final results = state.allAppointments
        .where((a) => a.patientName.toLowerCase().contains(query))
        .toList();

    emit(state.copyWith(
      query:         query,
      isSearching:   true,
      searchResults: results,
    ));
  }

  void clearSearch() {
    emit(state.copyWith(
      query:         '',
      isSearching:   false,
      searchResults: [],
    ));
  }
}