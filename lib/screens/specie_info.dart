import 'package:ecoscan/data/species.dart';
import 'package:flutter/material.dart';
import 'package:ecoscan/utils/colors.dart';

class SpecieInfoScreen extends StatelessWidget {
  final Species species;

  const SpecieInfoScreen({super.key, required this.species});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    //final height = size.height;
    final isSmall = width < 360;
    final isLarge = width > 600;
    double imageHeight = isLarge ? 420 : (isSmall ? 220 : 320);
    double nameFontSize = isSmall ? 22 : (isLarge ? 38 : 30);
    double sciNameFontSize = isSmall ? 12 : (isLarge ? 24 : 18);
    double cardSpacing = isSmall ? 8 : 12;
    double descTitleFontSize = isSmall ? 16 : 22;
    double descFontSize = isSmall ? 12 : 16;
    double backBtnSize = isSmall ? 36 : 44;
    double backIconSize = isSmall ? 20 : 28;
    double stackLeft = isSmall ? 10 : 20;
    double stackBottom = isSmall ? 10 : 24;
    double betweenNames = isSmall ? 1 : 2;

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
                  child: speciesImageWidget(species, imageHeight),
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
                        species.nombreCientifico,
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
                        species.nombreComun,
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
                children: [
                  _dataCard('Peso', species.peso),
                  _dataCard('Longitud', species.longitud),
                  _dataCard('Origen', species.origen),
                  _dataCard(
                    'Amenaza',
                    species.peligroso ? 'Peligroso' : 'No peligroso',
                  ),
                ],
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
                    species.descripcion,
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

  Widget _dataCard(String label, String value) {
    final size = WidgetsBinding.instance.window.physicalSize;
    final width = size.width / WidgetsBinding.instance.window.devicePixelRatio;
    final isSmall = width < 360;
    double cardLabelFontSize = isSmall ? 12 : 14;
    double cardValueFontSize = isSmall ? 14 : 18;
    double cardPaddingV = isSmall ? 8 : 14;
    double cardPaddingH = isSmall ? 6 : 10;
    return Container(
      width: width / 2 - 24,
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
            label,
            style: TextStyle(
              color: colorsWhite,
              fontSize: cardLabelFontSize,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
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
  }

  Widget speciesImageWidget(Species species, double height) {
    // Usa la imagen específica si está disponible
    if (species.imagen.isNotEmpty) {
      return Image.asset(
        species.imagen,
        fit: BoxFit.cover,
        height: height,
        width: double.infinity,
        errorBuilder:
            (context, error, stackTrace) => Container(
              height: height,
              width: double.infinity,
              color: Colors.grey[300],
              child: Icon(
                Icons.image,
                size: height * 0.5,
                color: Colors.grey[600],
              ),
            ),
      );
    }
    // ...fallback anterior...
    String? asset;
    switch (species.clasificacion) {
      case 'mamífero':
        asset = 'assets/images/mamifero.png';
        break;
      case 'ave':
        asset = 'assets/images/ave.png';
        break;
      case 'reptil':
        asset = 'assets/images/reptiles.png';
        break;
      case 'pez':
        asset = 'assets/images/peces.png';
        break;
      case 'anfibio':
        asset = 'assets/images/anfibio.png';
        break;
      case 'insecto':
        asset = 'assets/images/insectos.png';
        break;
      case 'nativa':
        asset = 'assets/images/nativa.png';
        break;
      case 'agrícola':
        asset = 'assets/images/nativa.png';
        break;
      case 'arvense':
        asset = 'assets/images/nativa.png';
        break;
      default:
        asset = null;
    }
    if (asset != null && asset.isNotEmpty) {
      return Image.asset(
        asset,
        fit: BoxFit.cover,
        height: height,
        width: double.infinity,
      );
    } else {
      return Container(
        height: height,
        width: double.infinity,
        color: Colors.grey[300],
        child: Icon(Icons.image, size: height * 0.5, color: Colors.grey[600]),
      );
    }
  }
}
