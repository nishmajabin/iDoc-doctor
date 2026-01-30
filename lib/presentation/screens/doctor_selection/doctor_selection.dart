import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/constants/color.dart';
import 'package:idoc_doctor_side/presentation/screens/auth/sign_in/sign_in_screen.dart';
import 'package:idoc_doctor_side/presentation/screens/doctor_selection/widgets/custom_button.dart';
import 'package:idoc_doctor_side/presentation/screens/send_application/doctor_details_screen.dart';
import 'package:lottie/lottie.dart';

class DoctorSelection extends StatelessWidget {
  const DoctorSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Color.fromARGB(255, 215, 242, 255),
              Colors.white,
            ],
            stops: [0.1, 0.5, 0.9],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // Send Application Section
                _buildLottieCard(lottieAsset: 'assets/lottie/email_sent.json'),
                const SizedBox(height: 30),
                StyledButton(
                  label: 'SEND APPLICATION',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoctorDetailsScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 70),

                // Login Section
                _buildImageCard(imageAsset: 'assets/images/doctor_login.png'),
                const SizedBox(height: 16),
                StyledButton(
                  label: 'LOGIN',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoctorLoginScreen(),
                      ),
                    );
                  },
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLottieCard({required String lottieAsset}) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 280, maxHeight: 280),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.strokeColor, width: 3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFD4F1F9),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Lottie.asset(
                  lottieAsset,
                  fit: BoxFit.contain,
                  repeat: true,
                  animate: true,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageCard({required String imageAsset}) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 280, maxHeight: 280),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.strokeColor, width: 3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFD4F1F9),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Image.asset(imageAsset, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
