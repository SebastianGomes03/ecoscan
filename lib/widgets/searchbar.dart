import 'package:flutter/material.dart';
import 'package:ecoscan/utils/colors.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const CustomSearchBar({
    super.key,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      decoration: BoxDecoration(
        color: colorsWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorsBlack.withOpacity(0.5),
          width: 4,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(
              Icons.search,
              size: 40,
              color: colorsBlack.withOpacity(0.5),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: TextStyle(
                fontSize: 32,
                color: colorsBlack.withOpacity(0.5),
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Buscar',
                hintStyle: TextStyle(
                  fontSize: 32,
                  color: colorsBlack.withOpacity(0.5),
                  fontWeight: FontWeight.w400,
                ),
                isCollapsed: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}