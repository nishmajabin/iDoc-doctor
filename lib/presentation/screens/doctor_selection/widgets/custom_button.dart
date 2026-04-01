import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';

class StyledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String label;
  final double height;

  const StyledButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isLoading = false,
    this.height = 65,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 50),
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.boxShadowColor.withValues(alpha: 0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.bgColorElevated,
            elevation: 0,
            shadowColor: AppColors.transparentColor,
            foregroundColor: AppColors.bgColor,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
              side: const BorderSide(color: AppColors.borderSideColor , width: 4),
            ),
            disabledBackgroundColor: AppColors.primaryColor,
          ),
          child:
              isLoading
                  ?  SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.bgColor),
                      strokeWidth: 1,
                    ),
                  )
                  : Text(
                    label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
        ),
      ),
    );
  }
}
