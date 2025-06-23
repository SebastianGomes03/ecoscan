import 'package:flutter/material.dart';
import 'package:ecoscan/utils/colors.dart';

class CategoryCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double? titleFontSize;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.titleFontSize,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 360;
    final isLarge = width > 600;
    double borderRadius = isSmall ? 12 : (isLarge ? 36 : 24);
    double imgHeight = isSmall ? 120 : (isLarge ? 320 : 220);
    double titleFont = titleFontSize ?? (isSmall ? 18 : (isLarge ? 44 : 32));
    double pad = isSmall ? 8 : 16;

    return GestureDetector(
      onTap: onTap,
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
              left: pad,
              bottom: pad,
              child: Text(
                title,
                style: TextStyle(
                  color: colorsWhite,
                  fontSize: titleFont,
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
    );
  }
}
