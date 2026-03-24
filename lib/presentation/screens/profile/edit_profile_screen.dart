import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/constants/color.dart';
import 'package:idoc_doctor_side/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/logic/blocs/edit_profile/edit_profile_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/edit_profile/edit_profile_event.dart';
import 'package:idoc_doctor_side/logic/blocs/edit_profile/edit_profile_state.dart';
import 'package:image_picker/image_picker.dart';

// ─── Entry point ──────────────────────────────────────────────────────────────
class EditProfileScreen extends StatelessWidget {
  final DoctorModel currentDoctor;
  const EditProfileScreen({required this.currentDoctor, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          EditProfileBloc()..add(EditProfileStarted(currentDoctor)),
      child: const _EditProfileView(),
    );
  }
}

// ─── View ─────────────────────────────────────────────────────────────────────
// Keeps a local copy of the last EditProfileReady so that when the state
// transitions to EditProfileSaving we still have the doctor + pickedImage.
class _EditProfileView extends StatefulWidget {
  const _EditProfileView();

  @override
  State<_EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<_EditProfileView> {
  EditProfileReady? _lastReady;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileBloc, EditProfileState>(
      listener: (context, state) {
        if (state is EditProfileSaveSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded,
                      color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Text('Profile updated successfully',
                      style: GoogleFonts.poppins(
                          fontSize: 13, fontWeight: FontWeight.w500)),
                ],
              ),
              backgroundColor: AppColors.completed,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
              duration: const Duration(seconds: 2),
            ),
          );
          Navigator.pop(context, state.updatedDoctor);
        } else if (state is EditProfileSaveFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message,
                  style: GoogleFonts.poppins(fontSize: 13)),
              backgroundColor: AppColors.cancelled,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      },
      builder: (context, state) {
        // ── Cache the last ready state so saving overlay still has data ──────
        if (state is EditProfileReady) {
          _lastReady = state;
        }

        if (state is EditProfileInitial || _lastReady == null) {
          return  Scaffold(
            backgroundColor: AppColors.bgColor,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        // Both EditProfileReady and EditProfileSaving render the form.
        // isSaving drives the loading indicators / disabled state.
        return _EditProfileForm(
          doctor: _lastReady!.doctor,
          pickedImage: _lastReady!.pickedImage,
          isSaving: state is EditProfileSaving,
        );
      },
    );
  }
}

// ─── Form ─────────────────────────────────────────────────────────────────────
class _EditProfileForm extends StatefulWidget {
  final DoctorModel doctor;
  final File? pickedImage;
  final bool isSaving;

  const _EditProfileForm({
    required this.doctor,
    required this.pickedImage,
    required this.isSaving,
  });

  @override
  State<_EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<_EditProfileForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _placeCtrl;
  late final TextEditingController _bioCtrl;
  late final TextEditingController _experienceCtrl;

  String? _selectedSpecialist;
  String? _selectedGender;

  static const _specialists = [
    'Cardiologist', 'Dermatologist', 'General Practitioner',
    'Neurologist', 'Orthopedist', 'Pediatrician', 'Psychiatrist',
    'Radiologist', 'Surgeon', 'Urologist', 'Gynecologist',
    'Oncologist', 'Ophthalmologist', 'ENT Specialist', 'Dentist',
  ];
  static const _genders = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    final d = widget.doctor;
    _nameCtrl       = TextEditingController(text: d.name);
    _phoneCtrl      = TextEditingController(text: d.phone);
    _placeCtrl      = TextEditingController(text: d.place);
    _bioCtrl        = TextEditingController(text: d.bio);
    _experienceCtrl = TextEditingController(text: d.experience.toString());
    _selectedSpecialist = d.specialist;
    _selectedGender     = d.gender;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _placeCtrl.dispose();
    _bioCtrl.dispose();
    _experienceCtrl.dispose();
    super.dispose();
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final picked =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked != null && mounted) {
      context
          .read<EditProfileBloc>()
          .add(EditProfileImagePicked(File(picked.path)));
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final experience =
        int.tryParse(_experienceCtrl.text.replaceAll(RegExp(r'\D'), '')) ?? 0;

    context.read<EditProfileBloc>().add(
          EditProfileSubmitted(
            name: _nameCtrl.text,
            phone: _phoneCtrl.text,
            place: _placeCtrl.text,
            bio: _bioCtrl.text,
            specialist: _selectedSpecialist ?? widget.doctor.specialist,
            gender: _selectedGender ?? widget.doctor.gender,
            experience: experience,
            newProfileImage: widget.pickedImage,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _EditAppBar(isSaving: widget.isSaving, onSave: _submit),
          SliverToBoxAdapter(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _AvatarPicker(
                      doctor: widget.doctor,
                      pickedImage: widget.pickedImage,
                      onTap: widget.isSaving ? null : _pickImage,
                    ),
                    const SizedBox(height: 28),
                    _SectionLabel(label: 'Personal Information'),
                    const SizedBox(height: 12),
                    _FormCard(
                      children: [
                        _FieldTile(
                          controller: _nameCtrl,
                          label: 'Full Name',
                          hint: 'Enter your full name',
                          icon: Icons.person_outline_rounded,
                          iconColor: AppColors.primary,
                          bgColor: AppColors.primarySurface,
                          enabled: !widget.isSaving,
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'Name is required'
                              : null,
                          isFirst: true,
                        ),
                        _FieldDivider(),
                        _FieldTile(
                          controller: _phoneCtrl,
                          label: 'Phone Number',
                          hint: '+91 XXXXX XXXXX',
                          icon: Icons.phone_outlined,
                          iconColor: AppColors.confirmed,
                          bgColor: AppColors.confirmedSurface,
                          keyboardType: TextInputType.phone,
                          enabled: !widget.isSaving,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Phone is required';
                            }
                            if (v.trim().length < 10) {
                              return 'Enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                        _FieldDivider(),
                        _FieldTile(
                          controller: _placeCtrl,
                          label: 'Location / City',
                          hint: 'e.g. Mumbai, Maharashtra',
                          icon: Icons.location_on_outlined,
                          iconColor: AppColors.pending,
                          bgColor: AppColors.pendingSurface,
                          enabled: !widget.isSaving,
                          isLast: true,
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'Location is required'
                              : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _SectionLabel(label: 'Professional Details'),
                    const SizedBox(height: 12),
                    _FormCard(
                      children: [
                        _DropdownTile(
                          label: 'Specialization',
                          hint: 'Select specialization',
                          icon: Icons.medical_services_outlined,
                          iconColor: AppColors.completed,
                          bgColor: AppColors.completedSurface,
                          value: _selectedSpecialist,
                          items: _specialists,
                          enabled: !widget.isSaving,
                          onChanged: (v) =>
                              setState(() => _selectedSpecialist = v),
                          isFirst: true,
                        ),
                        _FieldDivider(),
                        _DropdownTile(
                          label: 'Gender',
                          hint: 'Select gender',
                          icon: Icons.wc_outlined,
                          iconColor: AppColors.textSecondary,
                          bgColor: const Color(0xFFF0F3F7),
                          value: _selectedGender,
                          items: _genders,
                          enabled: !widget.isSaving,
                          onChanged: (v) =>
                              setState(() => _selectedGender = v),
                        ),
                        _FieldDivider(),
                        _FieldTile(
                          controller: _experienceCtrl,
                          label: 'Years of Experience',
                          hint: 'e.g. 5',
                          icon: Icons.workspace_premium_outlined,
                          iconColor: AppColors.accent,
                          bgColor: AppColors.primarySurface,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          enabled: !widget.isSaving,
                          isLast: true,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Experience is required';
                            }
                            final n = int.tryParse(v);
                            if (n == null || n < 0 || n > 60) {
                              return 'Enter a valid number (0–60)';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _SectionLabel(label: 'About / Bio'),
                    const SizedBox(height: 12),
                    _BioField(
                        controller: _bioCtrl, enabled: !widget.isSaving),
                    const SizedBox(height: 24),
                    _SectionLabel(label: 'Non-editable Information'),
                    const SizedBox(height: 12),
                    _ReadOnlyCard(doctor: widget.doctor),
                    const SizedBox(height: 32),
                    _SaveButton(
                        isSaving: widget.isSaving, onTap: _submit),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── App bar ──────────────────────────────────────────────────────────────────
class _EditAppBar extends StatelessWidget {
  final bool isSaving;
  final VoidCallback onSave;
  const _EditAppBar({required this.isSaving, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.gradientStart,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: Colors.white, size: 20),
        onPressed: isSaving ? null : () => Navigator.pop(context),
      ),
      actions: [
        if (isSaving)
          const Padding(
            padding: EdgeInsets.all(14),
            child: SizedBox(
              width: 20, height: 20,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2),
            ),
          )
        else
          TextButton(
            onPressed: onSave,
            child: Text('Save',
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
          ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.gradientStart, AppColors.gradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
                top: -30, right: -30,
                child: _Circle(size: 150, opacity: 0.08)),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Edit Profile',
                        style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.4)),
                    Text('Update your professional details',
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.7))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  final double size;
  final double opacity;
  const _Circle({required this.size, required this.opacity});
  @override
  Widget build(BuildContext context) => Container(
        width: size, height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(opacity),
        ),
      );
}

// ─── Avatar picker ────────────────────────────────────────────────────────────
class _AvatarPicker extends StatelessWidget {
  final DoctorModel doctor;
  final File? pickedImage;
  final VoidCallback? onTap;
  const _AvatarPicker(
      {required this.doctor, required this.pickedImage, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 52,
                backgroundColor: AppColors.primarySurface,
                backgroundImage: pickedImage != null
                    ? FileImage(pickedImage!)
                    : (doctor.profileImageUrl != null
                        ? NetworkImage(doctor.profileImageUrl!)
                            as ImageProvider
                        : null),
                child: (pickedImage == null && doctor.profileImageUrl == null)
                    ? Text(_initials(doctor.name),
                        style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary))
                    : null,
              ),
            ),
            Positioned(
              bottom: 0, right: 0,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.camera_alt_rounded,
                      color: Colors.white, size: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    final trimmed = parts.where((p) => p.isNotEmpty).toList();
    if (trimmed.length >= 2) {
      return '${trimmed[0][0]}${trimmed[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

// ─── Section label ────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4, height: 18,
          decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 8),
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.2)),
      ],
    );
  }
}

// ─── Form card wrapper ────────────────────────────────────────────────────────
class _FormCard extends StatelessWidget {
  final List<Widget> children;
  const _FormCard({required this.children});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _FieldDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Divider(
      height: 1, indent: 70, endIndent: 16, color: AppColors.divider);
}

// ─── Text field tile ──────────────────────────────────────────────────────────
class _FieldTile extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final bool isFirst;
  final bool isLast;
  final String? Function(String?)? validator;

  const _FieldTile({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.enabled = true,
    this.isFirst = false,
    this.isLast = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, isFirst ? 14 : 10, 16, isLast ? 14 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
                color: bgColor, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: TextFormField(
              controller: controller,
              enabled: enabled,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              validator: validator,
              style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                labelText: label,
                hintText: hint,
                labelStyle: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500),
                hintStyle: GoogleFonts.poppins(
                    fontSize: 13, color: AppColors.textMuted),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                errorStyle: GoogleFonts.poppins(
                    fontSize: 10, color: AppColors.cancelled),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Dropdown tile ────────────────────────────────────────────────────────────
class _DropdownTile extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String? value;
  final List<String> items;
  final bool enabled;
  final bool isFirst;
  final bool isLast;
  final ValueChanged<String?> onChanged;

  const _DropdownTile({
    required this.label,
    required this.hint,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.value,
    required this.items,
    required this.onChanged,
    this.enabled = true,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, isFirst ? 14 : 10, 16, isLast ? 14 : 10),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
                color: bgColor, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: value,
              hint: Text(hint,
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: AppColors.textMuted)),
              style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500),
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary, size: 20),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              items: items
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e,
                            style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                color: AppColors.textPrimary)),
                      ))
                  .toList(),
              onChanged: enabled ? onChanged : null,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bio field ────────────────────────────────────────────────────────────────
class _BioField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  const _BioField({required this.controller, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.description_outlined,
                    color: AppColors.primary, size: 18),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: TextFormField(
                controller: controller,
                enabled: enabled,
                maxLines: 5,
                minLines: 3,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Bio cannot be empty'
                    : null,
                style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    color: AppColors.textPrimary,
                    height: 1.6),
                decoration: InputDecoration(
                  labelText: 'Professional Bio',
                  hintText:
                      'Tell patients about your expertise, experience and approach...',
                  labelStyle: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500),
                  hintStyle: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textMuted,
                      height: 1.5),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  errorStyle: GoogleFonts.poppins(
                      fontSize: 10, color: AppColors.cancelled),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Read-only card ───────────────────────────────────────────────────────────
class _ReadOnlyCard extends StatelessWidget {
  final DoctorModel doctor;
  const _ReadOnlyCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _ReadOnlyRow(
            icon: Icons.email_outlined,
            iconColor: AppColors.primary,
            bgColor: AppColors.primarySurface,
            label: 'Email',
            value: doctor.email,
          ),
          const Divider(height: 20, indent: 52, color: AppColors.divider),
          _ReadOnlyRow(
            icon: Icons.badge_outlined,
            iconColor: AppColors.completed,
            bgColor: AppColors.completedSurface,
            label: 'License Number',
            value: doctor.licenseNumber,
          ),
        ],
      ),
    );
  }
}

class _ReadOnlyRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String label;
  final String value;
  const _ReadOnlyRow({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
              color: bgColor, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: iconColor, size: 17),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(label,
                      style: GoogleFonts.poppins(
                          fontSize: 10.5,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F3F7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('Read only',
                        style: GoogleFonts.poppins(
                            fontSize: 9,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(value,
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Save button ──────────────────────────────────────────────────────────────
class _SaveButton extends StatelessWidget {
  final bool isSaving;
  final VoidCallback onTap;
  const _SaveButton({required this.isSaving, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSaving ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSaving
                ? [
                    AppColors.gradientStart.withOpacity(0.6),
                    AppColors.gradientEnd.withOpacity(0.6),
                  ]
                : const [AppColors.gradientStart, AppColors.gradientEnd],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSaving
              ? []
              : [
                  BoxShadow(
                    color: AppColors.gradientStart.withOpacity(0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSaving)
              const SizedBox(
                width: 18, height: 18,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
            else
              const Icon(Icons.check_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(
              isSaving ? 'Saving...' : 'Save Changes',
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.2),
            ),
          ],
        ),
      ),
    );
  }
}