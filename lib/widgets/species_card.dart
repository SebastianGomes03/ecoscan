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
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 360;
    final isLarge = width > 600;
    double imgHeight = isSmall ? 120 : (isLarge ? 260 : 180);
    double nameFontSize = isSmall ? 14 : (isLarge ? 26 : 20);
    double sciFontSize = isSmall ? 10 : (isLarge ? 18 : 13);
    double borderRadius = isSmall ? 10 : (isLarge ? 24 : 16);
    double padH = isSmall ? 2 : 4;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colorsWhite,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Image.asset(
                imageUrl,
                width: double.infinity,
                height: imgHeight,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padH, vertical: 0),
              child: Text(
                name,
                style: TextStyle(
                  fontSize: nameFontSize,
                  color: colorsBlack,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padH, vertical: 0),
              child: Text(
                scientificName,
                style: TextStyle(
                  fontSize: sciFontSize,
                  color: colorsBlack.withOpacity(0.7),
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
