import 'package:flutter/material.dart';
import 'package:ecoscan/utils/colors.dart';

class SpecieInfoScreen extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String scientificName;
  final String description;
  final List<Map<String, String>> dataCards;

  const SpecieInfoScreen({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.scientificName,
    required this.description,
    required this.dataCards,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final isSmall = width < 360;
    final isLarge = width > 600;
    double imageHeight = isLarge ? 420 : (isSmall ? 220 : 320);
    double nameFontSize = isSmall ? 28 : (isLarge ? 48 : 40);
    double sciNameFontSize = isSmall ? 16 : (isLarge ? 28 : 22);
    double cardLabelFontSize = isSmall ? 12 : 14;
    double cardValueFontSize = isSmall ? 14 : 18;
    double cardPaddingV = isSmall ? 8 : 14;
    double cardPaddingH = isSmall ? 6 : 10;
    double cardSpacing = isSmall ? 8 : 12;
    double descTitleFontSize = isSmall ? 16 : 22;
    double descFontSize = isSmall ? 12 : 16;
    double backBtnSize = isSmall ? 36 : 44;
    double backIconSize = isSmall ? 20 : 28;
    double stackLeft = isSmall ? 10 : 20;
    double stackBottom = isSmall ? 10 : 24;
    double betweenNames = isSmall ? 2 : 6;

    return Scaffold(
      backgroundColor: colorsWhite,
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: imageHeight,
                  child: Image.asset(imageUrl, fit: BoxFit.cover),
                ),
                Positioned(
                  top: backBtnSize / 2,
                  left: backBtnSize / 2,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: backBtnSize,
                      height: backBtnSize,
                      decoration: BoxDecoration(
                        color: colorsWhite.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(backBtnSize / 2),
                        border: Border.all(
                          color: colorsWhite.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: colorsWhite,
                        size: backIconSize,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: stackLeft,
                  bottom: stackBottom,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scientificName,
                        style: TextStyle(
                          color: colorsWhite.withOpacity(0.8),
                          fontSize: sciNameFontSize,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                          shadows: [
                            Shadow(
                              blurRadius: 16,
                              color: colorsBlack,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: betweenNames),
                      Text(
                        name,
                        style: TextStyle(
                          color: colorsWhite,
                          fontSize: nameFontSize,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Poppins',
                          shadows: [
                            Shadow(
                              blurRadius: 16,
                              color: colorsBlack,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: cardSpacing),
            // Tarjetas de datos
            Padding(
              padding: EdgeInsets.symmetric(horizontal: cardSpacing),
              child: Wrap(
                spacing: cardSpacing,
                runSpacing: cardSpacing,
                children:
                    dataCards.map((card) {
                      return Container(
                        width: width / 2 - cardSpacing * 2,
                        padding: EdgeInsets.symmetric(
                          vertical: cardPaddingV,
                          horizontal: cardPaddingH,
                        ),
                        decoration: BoxDecoration(
                          color: colorsGreen,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              card['label']!,
                              style: TextStyle(
                                color: colorsWhite,
                                fontSize: cardLabelFontSize,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              card['value']!,
                              style: TextStyle(
                                color: colorsWhite,
                                fontSize: cardValueFontSize,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ),
            SizedBox(height: cardSpacing + 2),
            // Descripción
            Padding(
              padding: EdgeInsets.symmetric(horizontal: cardSpacing + 4),
              child: Text(
                "Descripción",
                style: TextStyle(
                  fontSize: descTitleFontSize,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Poppins',
                  color: colorsBlack,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: cardSpacing + 4,
                  vertical: 4,
                ),
                child: SingleChildScrollView(
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: descFontSize,
                      color: colorsBlack,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
