import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_model.dart';

class EditProfileAvatarPicker extends StatelessWidget {
  final DoctorModel doctor;
  final File? pickedImage;
  final VoidCallback? onTap;
  const EditProfileAvatarPicker(
      {required this.doctor, required this.pickedImage, required this.onTap, super.key});

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
                    color: AppColors.primary.withValues(alpha: 0.2),
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
                    border: Border.all(color: AppColors.bgColor, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child:  Icon(Icons.camera_alt_rounded,
                      color: AppColors.bgColor, size: 16),
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