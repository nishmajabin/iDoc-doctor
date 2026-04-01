import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/presentation/screens/auth/sign_in/sign_in_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:idoc_doctor_side/presentation/screens/doctor_selection/widgets/custom_button.dart';

class ApplicationSuccessScreen extends StatelessWidget {
  const ApplicationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6F0F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Back Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 3,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.chevron_left,
                    color: Color(0xFF2C3E50),
                    size: 27,
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // Success Icon Circle with Lottie Animation
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFB3E5F5),
                  ),
                  child: Center(
                    child: Lottie.asset(
                      'assets/lottie/register.json', // Replace with your lottie file path
                      width: 160,
                      height: 160,
                      fit: BoxFit.contain,
                      repeat: true,
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // Success Message
              Center(
                child: Column(
                  children: [
                    Text(
                      'Thank you for submitting your Application!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Our admin team will check your email within the next 24 hours for further instructions. Upon approval, you will receive a password to access the application.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // OK Button
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: StyledButton(
                  label: 'OK',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoctorLoginScreen(),
                      ),
                    );
                  },
                  height: 60,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
