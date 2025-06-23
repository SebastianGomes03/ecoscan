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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
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
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                Image.asset(
                  imageUrl,
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: colorsWhite,
                      fontSize: 36,
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
        ),
      ),
    );
  }
}
