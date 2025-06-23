import 'package:flutter/material.dart';
import 'package:ecoscan/utils/colors.dart';

class FloraFilterBar extends StatelessWidget {
  final int selectedIndex;
  final List<String> imageUrls;
  final void Function(int) onChanged;

  const FloraFilterBar({
    super.key,
    required this.selectedIndex,
    required this.imageUrls,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final selected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onChanged(index),
            child: Column(
              children: [
                Container(
                  width: 118,
                  height: 80,
                  decoration: BoxDecoration(
                    color: colorsWhite,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          selected ? colorsGreen : colorsBlack.withOpacity(0.7),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorsBlack.withOpacity(0.08),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(imageUrls[index], fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: selected ? 48 : 0,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colorsGreen,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
