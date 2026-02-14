import 'package:flutter/material.dart';

class BreakTimeSelectorWidget extends StatelessWidget {
  final int selectedBreakTime;
  final Function(int) onBreakTimeChanged;

  const BreakTimeSelectorWidget({
    super.key,
    required this.selectedBreakTime,
    required this.onBreakTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.coffee, size: 18, color: Colors.grey[700]),
              const SizedBox(width: 8),
              Text(
                'Break Time (after each slot)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [0, 5, 10, 15, 20, 30].map((breakTime) {
              final isSelected = selectedBreakTime == breakTime;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onBreakTimeChanged(breakTime),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? const Color(0xFFFF9800) 
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected 
                            ? const Color(0xFFFF9800) 
                            : Colors.grey[300]!,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFFFF9800).withValues(alpha: 0.3),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        breakTime == 0 ? 'None' : '$breakTime\nmin',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.black87,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          if (selectedBreakTime > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.orange[800]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'A $selectedBreakTime-minute break will be added after each appointment',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[800],
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