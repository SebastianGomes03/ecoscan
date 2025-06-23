import 'package:ecoscan/screens/biopedia.dart';
import 'package:flutter/material.dart';
import 'package:ecoscan/widgets/card.dart';
import 'package:ecoscan/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int filter)? onCategorySelected;

  const HomeScreen({super.key, this.onCategorySelected});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final isSmall = width < 360;
    final isLarge = width > 600;
    // Responsive values
    double logoHeight = width * 0.13;
    double horizontalPadding = width * 0.03;
    double verticalPadding = height * 0.01;
    double cardSpacing = height * 0.02;
    double welcomeFontSize = isSmall ? 18 : (isLarge ? 30 : 24);
    double cardTitleFontSize = isSmall ? 18 : 24;

    return Scaffold(
      backgroundColor: colorsWhite,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Row(
                children: [
                  Image.asset('assets/images/logo.png', height: logoHeight),
                  SizedBox(width: width * 0.02),
                ],
              ),
              SizedBox(height: height * 0.02),
              // Welcome message
              Text(
                'Bienvenido, conozca la biodiversidad del Caroní.',
                style: TextStyle(
                  fontSize: welcomeFontSize,
                  color: colorsBlack,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: cardSpacing),
              // Flora card
              CategoryCard(
                imageUrl: 'assets/images/flora.png',
                title: 'FLORA',
                titleFontSize: cardTitleFontSize,
                onTap: () {
                  widget.onCategorySelected?.call(0);
                },
              ),
              SizedBox(height: cardSpacing),
              // Fauna card
              CategoryCard(
                imageUrl: 'assets/images/fauna.png',
                title: 'FAUNA',
                titleFontSize: cardTitleFontSize,
                onTap: () {
                  widget.onCategorySelected?.call(1);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
