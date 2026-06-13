import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ودجت العداد التنازلي المستقل (يمكن استخدامه في أماكن مختلفة)
class CountdownWidget extends StatelessWidget {
  final Duration remaining;
  final Color textColor;
  final double fontSize;

  const CountdownWidget({
    super.key,
    required this.remaining,
    this.textColor = Colors.white,
    this.fontSize = 32,
  });

  @override
  Widget build(BuildContext context) {
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);
    final seconds = remaining.inSeconds.remainder(60);

    final timeString =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Text(
      timeString,
      style: GoogleFonts.cairo(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }
}
