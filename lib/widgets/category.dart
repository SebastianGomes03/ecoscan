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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1), // Reduced from 8 to 4
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Stack(
            children: [
              // Background image
              Image.asset(
                backgroundImageUrl,
                width: double.infinity,
                height: 90,
                fit: BoxFit.cover,
              ),
              // Overlay for better text visibility
              Container(
                width: double.infinity,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
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
                    // Representative image
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          representativeImageUrl,
                          width: 160,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Spacer
                    const SizedBox(width: 8),
                    // Title
                    Expanded(
                      child: Text(
                        title,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: colorsWhite,
                          fontSize: 24,
                          fontWeight: FontWeight.w900, // Black weight
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
                    const SizedBox(width: 24),
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
