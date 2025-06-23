import 'package:flutter/material.dart';
import 'package:ecoscan/utils/colors.dart';

class FaunaFilterBar extends StatelessWidget {
  final int selectedIndex;
  final List<Map<String, String>> items; // Each item: {'bg': ..., 'icon': ...}
  final void Function(int) onChanged;

  const FaunaFilterBar({
    super.key,
    required this.selectedIndex,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 360;
    final isLarge = width > 600;
    double barHeight = isSmall ? 60 : (isLarge ? 130 : 100);
    double cardW = isSmall ? 50 : (isLarge ? 100 : 80);
    double cardH = isSmall ? 50 : (isLarge ? 100 : 80);
    double borderRadius = isSmall ? 10 : (isLarge ? 28 : 20);
    double indicatorW = isSmall ? 24 : (isLarge ? 60 : 48);
    double indicatorH = isSmall ? 4 : 8;
    double sepW = isSmall ? 2 : 4;

    return SizedBox(
      height: barHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: sepW),
        itemBuilder: (context, index) {
          final selected = index == selectedIndex;
          final bg = items[index]['bg']!;
          final icon = items[index]['icon']!;
          return GestureDetector(
            onTap: () => onChanged(index),
            child: Column(
              children: [
                Container(
                  width: cardW,
                  height: cardH,
                  decoration: BoxDecoration(
                    color: colorsWhite,
                    borderRadius: BorderRadius.circular(borderRadius),
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
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(borderRadius - 4),
                        child: Image.asset(
                          bg,
                          fit: BoxFit.cover,
                          width: cardW,
                          height: cardH,
                        ),
                      ),
                      Center(
                        child: Image.asset(icon, width: cardW, height: cardH),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isSmall ? 4 : 8),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: selected ? indicatorW : 0,
                  height: indicatorH,
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
