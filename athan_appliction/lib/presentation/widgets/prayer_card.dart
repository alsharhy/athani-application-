import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// بطاقة عرض وقت الصلاة مع تمييز الحالية والقادمة
class PrayerCard extends StatelessWidget {
  final String prayerNameAr;
  final String time;
  final IconData icon;
  final bool isCurrent;
  final bool isNext;

  const PrayerCard({
    super.key,
    required this.prayerNameAr,
    required this.time,
    required this.icon,
    this.isCurrent = false,
    this.isNext = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Color cardColor;
    Color textColor;
    Color iconBgColor;
    Color iconColor;
    List<BoxShadow>? shadow;

    if (isCurrent) {
      // الصلاة الحالية - لون بارز
      cardColor = colorScheme.primary;
      textColor = colorScheme.onPrimary;
      iconBgColor = Colors.white.withValues(alpha: 0.2);
      iconColor = Colors.white;
      shadow = [
        BoxShadow(
          color: colorScheme.primary.withValues(alpha: 0.4),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
    } else if (isNext) {
      // الصلاة القادمة - لون مميز ثانوي
      cardColor = colorScheme.primaryContainer;
      textColor = colorScheme.onPrimaryContainer;
      iconBgColor = colorScheme.primary.withValues(alpha: 0.15);
      iconColor = colorScheme.primary;
      shadow = [
        BoxShadow(
          color: colorScheme.primary.withValues(alpha: 0.15),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
    } else {
      // صلاة عادية
      cardColor = colorScheme.surface;
      textColor = colorScheme.onSurface;
      iconBgColor = colorScheme.primaryContainer.withValues(alpha: 0.4);
      iconColor = colorScheme.primary;
      shadow = [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: shadow,
        border: isNext
            ? Border.all(
                color: colorScheme.primary.withValues(alpha: 0.3), width: 1.5)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                // أيقونة الصلاة
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: iconColor, size: 26),
                ),
                const SizedBox(width: 16),
                // اسم الصلاة
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prayerNameAr,
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      if (isCurrent)
                        Text(
                          'الوقت الحالي',
                          style: GoogleFonts.cairo(
                            fontSize: 11,
                            color: textColor.withValues(alpha: 0.7),
                          ),
                        ),
                      if (isNext)
                        Text(
                          'الصلاة القادمة',
                          style: GoogleFonts.cairo(
                            fontSize: 11,
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
                // الوقت
                Text(
                  time,
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
