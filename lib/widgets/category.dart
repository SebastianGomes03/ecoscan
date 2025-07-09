import 'package:flutter/material.dart';
import 'package:ecoscan/utils/colors.dart';

class CategoryButton extends StatelessWidget {
  final String backgroundImageUrl;
  final String representativeImageUrl;
  final String title;
  final VoidCallback? onTap;

  const CategoryButton({
    super.key,
    required this.backgroundImageUrl,
    required this.representativeImageUrl,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 360;
    final isLarge = width > 600;
    double borderRadius = isSmall ? 8 : (isLarge ? 24 : 16);
    double imgW = isSmall ? 60 : (isLarge ? 180 : 120);
    double imgH = isSmall ? 40 : (isLarge ? 120 : 90);
    double titleFontSize = isSmall ? 14 : (isLarge ? 32 : 24);
    double padH = isSmall ? 4 : 12;
    double padW = isSmall ? 4 : 24;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: isSmall ? 0.5 : 1),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            children: [
              // Background image
              Image.asset(
                backgroundImageUrl,
                width: double.infinity,
                height: imgH,
                fit: BoxFit.cover,
              ),
              // Overlay for better text visibility
              Container(
                width: double.infinity,
                height: imgH,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  color: colorsBlack.withOpacity(0.15),
                  border: Border.all(
                    color: colorsBlack.withOpacity(0.4),
                    width: 4,
                  ),
                ),
              ),
              // Content row
              Positioned.fill(
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: padH),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(borderRadius + 8),
                        child: Image.asset(
                          representativeImageUrl,
                          width: imgW,
                          height: imgH,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: isSmall ? 4 : 8),
                    Expanded(
                      child: Text(
                        title,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: colorsWhite,
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w900,
                          shadows: [
                            Shadow(
                              blurRadius: 8,
                              color: colorsBlack,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: padW),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
