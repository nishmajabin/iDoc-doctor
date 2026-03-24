import 'package:flutter/material.dart';

class BreakTimeSelectorWidget extends StatelessWidget {
  final int selectedBreakTime;
  final Function(int) onBreakTimeChanged;

  static const _breakOptions = [0, 5, 10, 15, 20, 30];

  const BreakTimeSelectorWidget({
    super.key,
    required this.selectedBreakTime,
    required this.onBreakTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Break Between Slots',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7A91),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: selectedBreakTime > 0
                      ? const Color(0xFFE07B00).withOpacity(0.12)
                      : const Color(0xFF2D9E6B).withOpacity(0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  selectedBreakTime == 0 ? 'No break' : '$selectedBreakTime min break',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: selectedBreakTime > 0
                        ? const Color(0xFFE07B00)
                        : const Color(0xFF2D9E6B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: _breakOptions.map((breakTime) {
              final isSelected = selectedBreakTime == breakTime;
              final isNone = breakTime == 0;
              final selectedColor = isNone
                  ? const Color(0xFF2D9E6B)
                  : const Color(0xFFE07B00);

              return Expanded(
                child: GestureDetector(
                  onTap: () => onBreakTimeChanged(breakTime),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? selectedColor.withOpacity(0.10)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? selectedColor.withOpacity(0.5)
                            : const Color(0xFFE0E8F0),
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: selectedColor.withOpacity(0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color:
                                    const Color(0xFF052C40).withOpacity(0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          isNone ? '—' : '$breakTime',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isNone ? 18 : 15,
                            fontWeight: FontWeight.w800,
                            color: isSelected
                                ? selectedColor
                                : const Color(0xFF1A2332),
                          ),
                        ),
                        Text(
                          isNone ? 'None' : 'min',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? selectedColor.withOpacity(0.7)
                                : const Color(0xFF9DAFC2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          if (selectedBreakTime > 0) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFFE07B00).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.free_breakfast_outlined,
                    size: 15,
                    color: Color(0xFFE07B00),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$selectedBreakTime-minute buffer added after each appointment',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFB35F00),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}