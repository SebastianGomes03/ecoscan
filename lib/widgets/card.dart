import 'package:flutter/material.dart';
import 'package:ecoscan/utils/colors.dart';

class CategoryCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Image.asset(
              imageUrl,
              width: double.infinity,
              height: 260,
              fit: BoxFit.cover,
            ),
            Positioned(
              left: 16,
              bottom: 16,
              child: Text(
                title,
                style: TextStyle(
                  color: colorsWhite,
                  fontSize: 32,
                  fontWeight: FontWeight.w900, // Black weight
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