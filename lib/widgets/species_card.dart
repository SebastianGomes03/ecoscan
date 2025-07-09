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
    double imgHeight = isSmall ? 90 : (isLarge ? 230 : 150);
    double nameFontSize = isSmall ? 12 : (isLarge ? 24 : 18);
    double sciFontSize = isSmall ? 8 : (isLarge ? 16 : 10);
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
              child:
                  imageUrl.isNotEmpty
                      ? Image.asset(
                        imageUrl,
                        width: double.infinity,
                        height: imgHeight,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              width: double.infinity,
                              height: imgHeight,
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.image_not_supported,
                                size: imgHeight * 0.5,
                                color: Colors.grey[600],
                              ),
                            ),
                      )
                      : Container(
                        width: double.infinity,
                        height: imgHeight,
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.image,
                          size: imgHeight * 0.5,
                          color: Colors.grey[600],
                        ),
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
