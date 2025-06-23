import 'package:flutter/material.dart';
import 'package:ecoscan/utils/colors.dart';

class SpeciesCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String scientificName;
  final VoidCallback? onTap;

  const SpeciesCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.scientificName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorsWhite,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Image.asset(
                imageUrl,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 32,
                  color: colorsBlack,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins', // Optional: match your app font
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              child: Text(
                scientificName,
                style: TextStyle(
                  fontSize: 24,
                  color: colorsBlack.withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins', // Optional
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}