import 'package:ecoscan/screens/camera.dart';
import 'package:ecoscan/screens/map.dart';
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
  int? _biopediaInitialFilter;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
      if (index != 2) {
        _biopediaInitialFilter = null; // Reset when leaving Biopedia
      }
    });
  }

  void _goToBiopedia({int initialFilter = 0}) {
    setState(() {
      _selectedIndex = 2;
      _biopediaInitialFilter = initialFilter;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (_selectedIndex) {
      case 0:
        body = HomeScreen(
          onCategorySelected: (filter) => _goToBiopedia(initialFilter: filter),
        );
        break;
      case 1:
        body = const CameraScreen();
        break;
      case 2:
        body = BiopediaScreen(initialFilter: _biopediaInitialFilter ?? 0);
        break;
      case 3:
        body = const MapScreen();
        break;
      default:
        body = HomeScreen(
          onCategorySelected: (filter) => _goToBiopedia(initialFilter: filter),
        );
    }

    return Scaffold(
      backgroundColor: colorsWhite,
      body: body,
      bottomNavigationBar: CustomNavbar(
        selectedIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
