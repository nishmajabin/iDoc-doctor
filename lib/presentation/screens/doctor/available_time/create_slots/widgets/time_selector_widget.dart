import 'package:flutter/material.dart';

// ── TimeSelectorWidget (row of two pickers) ──────────────────────────────────

class TimeSelectorWidget extends StatelessWidget {
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final Future<void> Function({required bool isStart}) onSelectTime;

  const TimeSelectorWidget({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.onSelectTime,
  });

  bool get _hasValidTimeRange {
    if (startTime == null || endTime == null) return true;
    final s = startTime!.hour * 60 + startTime!.minute;
    final e = endTime!.hour * 60 + endTime!.minute;
    return e > s;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _TimeCard(
                  label: 'Start Time',
                  time: startTime,
                  icon: Icons.wb_sunny_outlined,
                  accentColor: const Color(0xFF0077B6),
                  onTap: () => onSelectTime(isStart: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F4FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: Color(0xFF0077B6),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _TimeCard(
                  label: 'End Time',
                  time: endTime,
                  icon: Icons.nights_stay_outlined,
                  accentColor: const Color(0xFF00B4D8),
                  onTap: () => onSelectTime(isStart: false),
                ),
              ),
            ],
          ),
          if (!_hasValidTimeRange) ...[
            const SizedBox(height: 10),
            _buildTimeError(),
          ],
          if (startTime != null && endTime != null && _hasValidTimeRange) ...[
            const SizedBox(height: 10),
            _buildDurationBadge(),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeError() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFD13D3D).withOpacity(0.3),
        ),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning_amber_rounded,
              size: 16, color: Color(0xFFD13D3D)),
          SizedBox(width: 8),
          Text(
            'End time must be after start time',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFFD13D3D),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationBadge() {
    final totalMin = (endTime!.hour * 60 + endTime!.minute) -
        (startTime!.hour * 60 + startTime!.minute);
    final hours = totalMin ~/ 60;
    final mins = totalMin % 60;
    final durationStr = hours > 0
        ? (mins > 0 ? '${hours}h ${mins}m working window' : '${hours}h working window')
        : '${mins}m working window';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F8F1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF2D9E6B).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline_rounded,
              size: 16, color: Color(0xFF2D9E6B)),
          const SizedBox(width: 8),
          Text(
            durationStr,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF2D9E6B),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Individual time card ──────────────────────────────────────────────────────

class _TimeCard extends StatelessWidget {
  final String label;
  final TimeOfDay? time;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  const _TimeCard({
    required this.label,
    required this.time,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasTime = time != null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: hasTime ? accentColor.withOpacity(0.06) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasTime ? accentColor.withOpacity(0.4) : const Color(0xFFE0E8F0),
            width: hasTime ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF052C40).withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: hasTime
                        ? accentColor.withOpacity(0.12)
                        : const Color(0xFFF2F8FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 14,
                    color: hasTime ? accentColor : const Color(0xFFADB8C9),
                  ),
                ),
                const Spacer(),
                if (!hasTime)
                  Icon(
                    Icons.touch_app_outlined,
                    size: 14,
                    color: Colors.grey[400],
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: hasTime ? accentColor : const Color(0xFF9DAFC2),
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              hasTime ? time!.format(context) : 'Tap to set',
              style: TextStyle(
                fontSize: hasTime ? 20 : 14,
                fontWeight: FontWeight.w700,
                color: hasTime ? const Color(0xFF1A2332) : const Color(0xFFBDC8D5),
                letterSpacing: hasTime ? -0.5 : 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}