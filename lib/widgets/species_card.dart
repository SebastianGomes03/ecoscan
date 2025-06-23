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
        decoration: BoxDecoration(
          color: colorsWhite,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imageUrl,
                width: double.infinity,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  color: colorsBlack,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Poppins', // Optional: match your app font
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              child: Text(
                scientificName,
                style: TextStyle(
                  fontSize: 13,
                  color: colorsBlack.withOpacity(0.7),
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins', // Optional
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
