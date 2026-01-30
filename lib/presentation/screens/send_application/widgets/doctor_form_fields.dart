import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/constants/color.dart';
import 'package:idoc_doctor_side/core/utils/validators.dart';
import 'package:idoc_doctor_side/presentation/screens/send_application/widgets/custom_bio_field.dart';
import 'package:idoc_doctor_side/presentation/screens/send_application/widgets/custom_text_field.dart';
import 'package:idoc_doctor_side/presentation/screens/send_application/widgets/file_picker_button.dart';
import 'package:idoc_doctor_side/presentation/screens/send_application/widgets/gender_selector.dart';
import 'package:idoc_doctor_side/presentation/screens/send_application/widgets/specialist_dropdown.dart';

class DoctorFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController placeController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController phoneController;
  final TextEditingController bioController;
  final TextEditingController licenseController;
  final TextEditingController experienceController;

  const DoctorFormFields({
    super.key,
    required this.nameController,
    required this.placeController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.phoneController,
    required this.bioController,
    required this.licenseController,
    required this.experienceController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: nameController,
          hintText: 'Name',
          labelText: 'Name',
          prefixIcon: Icons.person_outline,
          keyboardType: TextInputType.name,
          validator: (value) => Validators.nameValidator(value, 'name'),
        ),
        const SizedBox(height: 30),
        CustomTextField(
          controller: placeController,
          hintText: 'Place',
          labelText: 'Place',
          prefixIcon: Icons.location_on_outlined,
          keyboardType: TextInputType.text,
          validator: Validators.placeValidator,
        ),
        const SizedBox(height: 30),
        CustomTextField(
          controller: emailController,
          hintText: 'Email',
          labelText: 'Email',
          prefixIcon: Icons.mail_outline,
          keyboardType: TextInputType.emailAddress,
          validator: Validators.emailValidator,
        ),const SizedBox(height: 30),
        CustomTextField(
          controller: passwordController,
          hintText: 'Password',
          labelText: 'Password',
          prefixIcon: Icons.lock_outline,
          keyboardType: TextInputType.text,
          validator: Validators.strongPasswordValidator,
        ),const SizedBox(height: 30),
        CustomTextField(
          controller: confirmPasswordController,
          hintText: 'Confirm Password',
          labelText: 'Confirm Password',
          prefixIcon: Icons.lock_outline,
          keyboardType: TextInputType.text,
          validator:
              (value) => Validators.confirmPasswordValidator(
                value,
                passwordController.text,
              ),
        ),
        const SizedBox(height: 30),
        CustomTextField(
          controller: phoneController,
          hintText: 'Phone Number',
          labelText: 'Phone Number',
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: Validators.phoneValidator,
        ),
        const SizedBox(height: 30),
        Text(
          'GENDER',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        const GenderSelector(),
        const SizedBox(height: 30),
        const SpecialistDropdown(),
        const SizedBox(height: 30),
        CustomBioField(
          controller: bioController,
          hintText: 'Bio',
          prefixIcon: Icons.description_outlined,
          validator: Validators.bioValidator,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: licenseController,
          hintText: 'License Number',
          labelText: 'License Number',
          prefixIcon: Icons.credit_card_outlined,
          keyboardType: TextInputType.text,
          validator: Validators.licenseNumberValidator,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: experienceController,
          hintText: 'Experience (years)',
          labelText: 'Experience',
          prefixIcon: Icons.work_outline,
          keyboardType: TextInputType.number,
          validator: Validators.experienceValidator,
        ),
        const SizedBox(height: 40),
        Text(
          'ADD PROOF LICENSE',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        const FilePickerButton(),
      ],
    );
  }
}
