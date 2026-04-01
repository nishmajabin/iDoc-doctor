import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/logic/cubits/profile/edit_profile/edit_profile_cubit.dart';
import 'package:idoc_doctor_side/logic/cubits/profile/edit_profile/edit_profile_form_state.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/edit_profile/widgets/edit_profile_app_bar.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/edit_profile/widgets/edit_profile_avatar_picker.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/edit_profile/widgets/edit_profile_bio_field.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/edit_profile/widgets/edit_profile_dropdown_tile.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/edit_profile/widgets/edit_profile_form_actions.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/edit_profile/widgets/edit_profile_form_card.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/edit_profile/widgets/edit_profile_form_controllers.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/edit_profile/widgets/edit_profile_read_only_card.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/edit_profile/widgets/edit_profile_save_button.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/edit_profile/widgets/edit_profile_section_label.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/edit_profile/widgets/field_divider.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/edit_profile/widgets/field_tile.dart';

class EditProfileForm extends StatelessWidget {
  final DoctorModel doctor;
  final File? pickedImage;
  final bool isSaving;

  static const _specialists = [
    'Cardiologist', 'Dermatologist', 'General Practitioner',
    'Neurologist', 'Orthopedist', 'Pediatrician', 'Psychiatrist',
    'Radiologist', 'Surgeon', 'Urologist', 'Gynecologist',
    'Oncologist', 'Ophthalmologist', 'ENT Specialist', 'Dentist',
  ];
  static const _genders = ['Male', 'Female', 'Other'];

  const EditProfileForm({
    required this.doctor,
    required this.pickedImage,
    required this.isSaving,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize controllers once with doctor data
    EditProfileFormControllers.init(
      name:       doctor.name,
      phone:      doctor.phone,
      place:      doctor.place,
      bio:        doctor.bio,
      experience: doctor.experience,
    );

    return BlocProvider(
      create: (_) => EditProfileFormCubit(doctor),
      child: BlocBuilder<EditProfileFormCubit, EditProfileFormState>(
        builder: (context, formState) {
          final cubit = context.read<EditProfileFormCubit>();

          return Scaffold(
            backgroundColor: AppColors.bgColor,
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                EditProfileAppBar(
                  isSaving: isSaving,
                  onSave: () => EditProfileFormActions.submit(
                    context:     context,
                    formState:   formState,
                    doctor:      doctor,
                    pickedImage: pickedImage,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Form(
                    key: EditProfileFormControllers.formKey,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 48),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EditProfileAvatarPicker(
                            doctor:      doctor,
                            pickedImage: pickedImage,
                            onTap: isSaving
                                ? null
                                : () => EditProfileFormActions.pickImage(context),
                          ),
                          const SizedBox(height: 28),
                          const EditProfileSectionLabel(label: 'Personal Information'),
                          const SizedBox(height: 12),
                          EditProfileFormCard(
                            children: [
                              FieldTile(
                                controller: EditProfileFormControllers.nameCtrl,
                                label:      'Full Name',
                                hint:       'Enter your full name',
                                icon:       Icons.person_outline_rounded,
                                iconColor:  AppColors.primary,
                                bgColor:    AppColors.primarySurface,
                                enabled:    !isSaving,
                                validator:  (v) => v == null || v.trim().isEmpty
                                    ? 'Name is required'
                                    : null,
                                isFirst: true,
                              ),
                              FieldDivider(),
                              FieldTile(
                                controller: EditProfileFormControllers.phoneCtrl,
                                label:      'Phone Number',
                                hint:       '+91 XXXXX XXXXX',
                                icon:       Icons.phone_outlined,
                                iconColor:  AppColors.confirmed,
                                bgColor:    AppColors.confirmedSurface,
                                keyboardType: TextInputType.phone,
                                enabled:    !isSaving,
                                validator:  (v) {
                                  if (v == null || v.trim().isEmpty) return 'Phone is required';
                                  if (v.trim().length < 10) return 'Enter a valid phone number';
                                  return null;
                                },
                              ),
                              FieldDivider(),
                              FieldTile(
                                controller: EditProfileFormControllers.placeCtrl,
                                label:      'Location / City',
                                hint:       'e.g. Mumbai, Maharashtra',
                                icon:       Icons.location_on_outlined,
                                iconColor:  AppColors.pending,
                                bgColor:    AppColors.pendingSurface,
                                enabled:    !isSaving,
                                isLast:     true,
                                validator:  (v) => v == null || v.trim().isEmpty
                                    ? 'Location is required'
                                    : null,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const EditProfileSectionLabel(label: 'Professional Details'),
                          const SizedBox(height: 12),
                          EditProfileFormCard(
                            children: [
                              EditProfileDropdownTile(
                                label:     'Specialization',
                                hint:      'Select specialization',
                                icon:      Icons.medical_services_outlined,
                                iconColor: AppColors.completed,
                                bgColor:   AppColors.completedSurface,
                                value:     formState.selectedSpecialist,
                                items:     _specialists,
                                enabled:   !isSaving,
                                onChanged: cubit.selectSpecialist,
                                isFirst:   true,
                              ),
                              FieldDivider(),
                              EditProfileDropdownTile(
                                label:     'Gender',
                                hint:      'Select gender',
                                icon:      Icons.wc_outlined,
                                iconColor: AppColors.textSecondary,
                                bgColor:   AppColors.bgColor,
                                value:     formState.selectedGender,
                                items:     _genders,
                                enabled:   !isSaving,
                                onChanged: cubit.selectGender,
                              ),
                              FieldDivider(),
                              FieldTile(
                                controller:   EditProfileFormControllers.experienceCtrl,
                                label:        'Years of Experience',
                                hint:         'e.g. 5',
                                icon:         Icons.workspace_premium_outlined,
                                iconColor:    AppColors.accent,
                                bgColor:      AppColors.primarySurface,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                enabled: !isSaving,
                                isLast:  true,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) return 'Experience is required';
                                  final n = int.tryParse(v);
                                  if (n == null || n < 0 || n > 60) return 'Enter a valid number (0–60)';
                                  return null;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const EditProfileSectionLabel(label: 'About / Bio'),
                          const SizedBox(height: 12),
                          EditProfileBioField(
                            controller: EditProfileFormControllers.bioCtrl,
                            enabled:    !isSaving,
                          ),
                          const SizedBox(height: 24),
                          const EditProfileSectionLabel(label: 'Non-editable Information'),
                          const SizedBox(height: 12),
                          EditProfileReadOnlyCard(doctor: doctor),
                          const SizedBox(height: 32),
                          EditProfileSaveButton(
                            isSaving: isSaving,
                            onTap: () => EditProfileFormActions.submit(
                              context:     context,
                              formState:   formState,
                              doctor:      doctor,
                              pickedImage: pickedImage,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}