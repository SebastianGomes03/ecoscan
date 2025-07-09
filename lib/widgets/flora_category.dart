import 'package:flutter/material.dart';
import 'package:ecoscan/utils/colors.dart';

class FloraCategoryCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final VoidCallback? onTap;

  const FloraCategoryCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 360;
    final isLarge = width > 600;
    double borderRadius = isSmall ? 14 : (isLarge ? 36 : 24);
    double outerPad = isSmall ? 3 : 6;
    double imgHeight = isSmall ? 90 : (isLarge ? 200 : 160);
    double titleFontSize = isSmall ? 18 : (isLarge ? 44 : 36);
    double titleRight = isSmall ? 8 : 20;
    double titleBottom = isSmall ? 8 : 20;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: outerPad),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius + 4),
            border: Border.all(color: colorsBlack.withOpacity(0.85), width: 4),
            boxShadow: [
              BoxShadow(
                color: colorsBlack.withOpacity(0.15),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Stack(
              children: [
                Image.asset(
                  imageUrl,
                  width: double.infinity,
                  height: imgHeight,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  right: titleRight,
                  bottom: titleBottom,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: colorsWhite,
                      fontSize: titleFontSize,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(
                          blurRadius: 8,
                          color: colorsBlack.withOpacity(0.7),
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
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
