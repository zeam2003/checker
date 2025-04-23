import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CounterItem extends StatelessWidget {
  final String label;
  final String count;
  final IconData icon;
  final Color bgColor;
  final Color textColor;

  const CounterItem({
    super.key,
    required this.label,
    required this.count,
    required this.icon,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count,
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.roboto(
                  fontSize: 13,
                  color: textColor.withOpacity(0.8),
                ),
              ),
            ],
          ),
          Icon(
            icon,
            color: textColor,
            size: 22,
          ),
        ],
      ),
    );
  }
}