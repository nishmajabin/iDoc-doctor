// presentation/widgets/specialist_dropdown.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/core/data/repositories/department_repository.dart';
import 'package:idoc_doctor_side/logic/blocs/doctor_application/doctor_application_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/doctor_application/doctor_application_event.dart';
import 'package:idoc_doctor_side/logic/blocs/doctor_application/doctor_application_state.dart';

class SpecialistDropdown extends StatelessWidget {
  const SpecialistDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final departmentRepository = DepartmentRepository();

    return BlocBuilder<DoctorApplicationBloc, DoctorApplicationState>(
      builder: (context, state) {
        String? selectedSpecialist;
        if (state is DoctorApplicationFormUpdated) {
          selectedSpecialist = state.specialist;
        }

        return StreamBuilder<List<String>>(
          stream: departmentRepository.getDepartmentsStream(),
          builder: (context, snapshot) {
            // Show loading indicator while fetching departments
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.bgColor,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child:  Center(
                  child: CircularProgressIndicator(color: AppColors.primaryColor),
                ),
              );
            }

            // Show error message if there's an error
            if (snapshot.hasError) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Error loading specializations',
                  style: TextStyle(color: Colors.red[700]),
                ),
              );
            }

            // Get the list of departments
            final departments = snapshot.data ?? [];

            // Show message if no departments are available
            if (departments.isEmpty) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.bgColor,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'No specializations available. Contact admin.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            // Build the dropdown with fetched departments
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: DropdownButtonFormField<String>(
                initialValue: selectedSpecialist,
                isExpanded: true,
                decoration: InputDecoration(
                  hintText: 'Select Specialization',
                  hintStyle:  TextStyle(color: AppColors.primaryColor),
                  prefixIcon:  Icon(
                    Icons.medical_services_outlined,
                    color: AppColors.primaryColor,
                  ),
                  suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:  BorderSide(color: AppColors.primaryColor, width: 2),
                  ),
                  filled: true,
                  fillColor: AppColors.bgColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                dropdownColor: AppColors.bgColor,
                icon: const SizedBox.shrink(),
                items: departments.map((String specialist) {
                  return DropdownMenuItem<String>(
                    value: specialist,
                    child: Text(
                      specialist,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    context.read<DoctorApplicationBloc>().add(
                          UpdateSpecialistEvent(newValue),
                        );
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a specialization';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            );
          },
        );
      },
    );
  }
}