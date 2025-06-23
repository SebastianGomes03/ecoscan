import 'package:flutter/material.dart';
import 'package:ecoscan/utils/colors.dart';

class FilterSelector extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onChanged;

  const FilterSelector({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _FilterButton(
            icon: Icons.local_florist,
            label: 'Flora',
            selected: selectedIndex == 0,
            onTap: () => onChanged(0),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _FilterButton(
            icon: Icons.pets,
            label: 'Fauna',
            selected: selectedIndex == 1,
            onTap: () => onChanged(1),
          ),
        ),
      ],
    );
  }
}

class _FilterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: 56,
        decoration: BoxDecoration(
          color: selected ? colorsGreen : colorsWhite,
          borderRadius: BorderRadius.circular(16),
          border:
              selected ? null : Border.all(color: Color(0xFF707070), width: 4),
          boxShadow:
              selected
                  ? [
                    BoxShadow(
                      color: colorsGreen.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ]
                  : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: selected ? colorsBlack : Color(0xFF707070),
            ),
            SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 24,
                color: selected ? colorsBlack : Color(0xFF707070),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
