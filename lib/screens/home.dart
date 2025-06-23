import 'package:flutter/material.dart';
import 'package:ecoscan/widgets/card.dart';
import 'package:ecoscan/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorsWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png', // Place your logo in assets and update path if needed
                    height: 48,
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 16),
              // Welcome message
              const Text(
                'Bienvenido, conozca la biodiversidad del Caroní.',
                style: TextStyle(
                  fontSize: 24,
                  color: colorsBlack,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),
              // Flora card
              CategoryCard(
                imageUrl: 'assets/images/flora.png', // Use your flora image asset
                title: 'FLORA',
                onTap: () {
                  // Navigate to flora section
                },
              ),
              const SizedBox(height: 16),
              // Fauna card
              CategoryCard(
                imageUrl: 'assets/images/fauna.png', // Use your fauna image asset
                title: 'FAUNA',
                onTap: () {
                  // Navigate to fauna section
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}