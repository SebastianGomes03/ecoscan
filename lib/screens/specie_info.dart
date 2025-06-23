import 'package:flutter/material.dart';
import 'package:ecoscan/utils/colors.dart';

class SpecieInfoScreen extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String scientificName;
  final String description;
  final List<Map<String, String>>
  dataCards; // [{'label': 'Peso', 'value': '1.7kg - 4.7kg'}, ...]

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
    return Scaffold(
      backgroundColor: colorsWhite,
      body: SafeArea(
        top: false, // <-- Esto permite que la imagen llegue hasta arriba
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 220,
                  child: Image.asset(imageUrl, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 32,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: colorsWhite.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: colorsWhite.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: colorsWhite,
                        size: 28,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  bottom: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scientificName,
                        style: const TextStyle(
                          color: colorsWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        name,
                        style: const TextStyle(
                          color: colorsWhite,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Tarjetas de datos
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    dataCards.map((card) {
                      return Container(
                        width: MediaQuery.of(context).size.width / 2 - 24,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 10,
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
                              style: const TextStyle(
                                color: colorsWhite,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              card['value']!,
                              style: const TextStyle(
                                color: colorsWhite,
                                fontSize: 18,
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
            const SizedBox(height: 18),
            // Descripción
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                "Descripción",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Poppins',
                  color: colorsBlack,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: SingleChildScrollView(
                  child: Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
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
