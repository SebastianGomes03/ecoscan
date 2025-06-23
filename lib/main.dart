import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ecoscan/utils/colors.dart';
import 'package:ecoscan/widgets/navbar.dart';
import 'package:ecoscan/screens/home.dart';
import 'package:ecoscan/screens/biopedia.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoScan',
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (_selectedIndex) {
      case 0:
        body = const HomeScreen();
        break;
      case 2:
        body = const BiopediaScreen();
        break;
      default:
        body = const HomeScreen(); // fallback
    }

    return Scaffold(
      backgroundColor: colorsWhite,
      body: body,
      bottomNavigationBar: CustomNavbar(
        selectedIndex: _selectedIndex,
        onTabSelected: (index) {
          if (index == 0 || index == 2) {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
    );
  }
}
