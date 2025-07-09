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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: colorsGreen, // Fondo principal del navbar
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: colorsGreen.withOpacity(0.15),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final selected = index == selectedIndex;
            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTabSelected(index),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                  decoration:
                      selected
                          ? BoxDecoration(
                            color: colorsWhite,
                            borderRadius: BorderRadius.circular(16),
                          )
                          : BoxDecoration(color: Colors.transparent),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        items[index].icon,
                        size: 25,
                        color:
                            selected
                                ? colorsGreen
                                : colorsWhite.withOpacity(0.7),
                      ),
                      if (selected) ...[
                        SizedBox(width: 2),
                        Text(
                          items[index].label,
                          style: TextStyle(
                            color: colorsGreen,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavbarItem {
  final IconData icon;
  final String label;

  _NavbarItem({required this.icon, required this.label});
}
