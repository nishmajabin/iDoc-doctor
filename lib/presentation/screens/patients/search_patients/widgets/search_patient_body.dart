import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_state.dart';
import 'package:idoc_doctor_side/logic/cubits/patient/search_patient/search_patient_cubit.dart';
import 'package:idoc_doctor_side/logic/cubits/patient/search_patient/search_patient_state.dart';
import 'package:idoc_doctor_side/presentation/screens/patients/search_patients/widgets/idle_state.dart';
import 'package:idoc_doctor_side/presentation/screens/patients/search_patients/widgets/no_result_state.dart';
import 'package:idoc_doctor_side/presentation/screens/patients/search_patients/widgets/results_list.dart';
import 'package:idoc_doctor_side/presentation/screens/patients/search_patients/widgets/search_patient_header.dart';

// ── Shared controller instances — lives outside build() ──────────────────────
final _searchController = TextEditingController();
final _searchFocusNode  = FocusNode();

class SearchPatientsBody extends StatelessWidget {
  final DoctorModel currentDoctor;

  const SearchPatientsBody({required this.currentDoctor, super.key});

  @override
  Widget build(BuildContext context) {
    // ── Seed cubit with appointments already in the bloc (handles initial load)
    final appointmentState = context.read<DoctorAppointmentBloc>().state;
    if (appointmentState is DoctorAppointmentLoaded) {
      context.read<SearchPatientsCubit>().updateAppointments([
        ...appointmentState.upcoming,
        ...appointmentState.past,
      ]);
    }

    // ── Auto-focus search field on first frame ────────────────────────────────
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.strokeColor,
        body: Column(
          children: [
            SearchPatientHeader(
              controller: _searchController,
              focusNode:  _searchFocusNode,
              onChanged:  (value) =>
                  context.read<SearchPatientsCubit>().onQueryChanged(value),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color:        AppColors.bgBase,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  // ── Keep cubit in sync when appointments refresh ───────────
                  child: BlocListener<DoctorAppointmentBloc,
                      DoctorAppointmentState>(
                    listener: (context, appointmentState) {
                      if (appointmentState is DoctorAppointmentLoaded) {
                        context
                            .read<SearchPatientsCubit>()
                            .updateAppointments([
                          ...appointmentState.upcoming,
                          ...appointmentState.past,
                        ]);
                      }
                    },
                    child: BlocBuilder<SearchPatientsCubit, SearchPatientsState>(
                      builder: (context, searchState) {
                        if (!searchState.isSearching &&
                            searchState.query.isEmpty) {
                          return const IdleState();
                        }

                        if (searchState.isSearching &&
                            searchState.searchResults.isEmpty) {
                          return NoResultsState(query: searchState.query);
                        }

                        return ResultsList(
                          results:       searchState.searchResults,
                          currentDoctor: currentDoctor,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}