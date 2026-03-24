import 'package:flutter/material.dart';

class PatientAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final bool isUpcoming;

  const PatientAvatar({
    required this.name,
    this.imageUrl,
    this.isUpcoming = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'P';

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Outer gradient ring
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isUpcoming
                ? const LinearGradient(
                    colors: [Color(0xFF0077B6), Color(0xFF00B4D8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isUpcoming ? null : const Color(0xFFDDE8F0),
          ),
          padding: const EdgeInsets.all(2),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(2),
            child: ClipOval(
              child: hasImage
                  ? Image.network(
                      imageUrl!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _buildInitials(initial, isUpcoming),
                    )
                  : _buildInitials(initial, isUpcoming),
            ),
          ),
        ),

        // Online / availability indicator (upcoming only)
        if (isUpcoming)
          Positioned(
            bottom: 1,
            right: 1,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: const Color(0xFF2D9E6B),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInitials(String initial, bool isUpcoming) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: isUpcoming
            ? const LinearGradient(
                colors: [Color(0xFF052C40), Color(0xFF0077B6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isUpcoming ? null : const Color(0xFFDDE8F0),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: isUpcoming ? Colors.white : const Color(0xFF9DAFC2),
          ),
        ),
      ),
    );
  }
}