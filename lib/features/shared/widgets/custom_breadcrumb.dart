import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBreadcrumb extends StatelessWidget {
  final List<BreadcrumbItem> items;

  const CustomBreadcrumb({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 4), // Aumentamos el margen superior
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerLeft, // Asegura alineación izquierda
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(items.length * 2 - 1, (index) {
            if (index.isOdd) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: Colors.grey.shade400,
                ),
              );
            }
            final item = items[index ~/ 2];
            return Text(
              item.label,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: item.isActive ? FontWeight.w600 : FontWeight.normal,
                color: item.isActive ? Colors.blue.shade700 : Colors.grey.shade600,
              ),
            );
          }),
        ),
      ),
    );
  }
}

class BreadcrumbItem {
  final String label;
  final bool isActive;

  const BreadcrumbItem({
    required this.label,
    this.isActive = false,
  });
}