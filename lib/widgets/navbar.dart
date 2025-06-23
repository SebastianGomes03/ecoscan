import 'package:flutter/material.dart';
import 'package:ecoscan/utils/colors.dart';

class CustomNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const CustomNavbar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavbarItem(icon: Icons.home_outlined, label: 'Home'),
      _NavbarItem(icon: Icons.camera_alt_outlined, label: 'Camera'),
      _NavbarItem(icon: Icons.menu_book_outlined, label: 'Biopedia'),
      _NavbarItem(icon: Icons.map_outlined, label: 'Map'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: colorsWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: colorsBlack.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final selected = index == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(index),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(horizontal: 4),
                padding: EdgeInsets.symmetric(vertical: 6),
                decoration:
                    selected
                        ? BoxDecoration(
                          color: colorsGreen,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: colorsGreen.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        )
                        : null,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      items[index].icon,
                      size: 32,
                      color: selected ? colorsWhite: colorsBlack,
                    ),
                    SizedBox(height: 4),
                    Text(
                      items[index].label,
                      style: TextStyle(
                        color: selected ? colorsWhite : colorsBlack,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavbarItem {
  final IconData icon;
  final String label;

  _NavbarItem({required this.icon, required this.label});
}
