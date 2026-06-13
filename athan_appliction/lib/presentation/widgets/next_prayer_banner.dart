import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// شريط الصلاة القادمة مع العداد التنازلي في الهيدر
class NextPrayerBanner extends StatelessWidget {
  final String prayerName;
  final Duration remaining;
  final IconData icon;

  const NextPrayerBanner({
    super.key,
    required this.prayerName,
    required this.remaining,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);
    final seconds = remaining.inSeconds.remainder(60);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Text(
                'الصلاة القادمة: $prayerName',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // العداد التنازلي
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTimeUnit(hours.toString().padLeft(2, '0'), 'ساعة'),
              _buildSeparator(),
              _buildTimeUnit(minutes.toString().padLeft(2, '0'), 'دقيقة'),
              _buildSeparator(),
              _buildTimeUnit(seconds.toString().padLeft(2, '0'), 'ثانية'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: GoogleFonts.cairo(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.75),
          ),
        ),
      ],
    );
  }

  Widget _buildSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        ':',
        style: GoogleFonts.cairo(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
