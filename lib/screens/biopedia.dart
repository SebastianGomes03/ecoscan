import 'package:flutter/material.dart';
import 'package:ecoscan/widgets/searchbar.dart';
import 'package:ecoscan/widgets/filter.dart';
import 'package:ecoscan/widgets/flora_category.dart';
import 'package:ecoscan/widgets/category.dart';
import 'package:ecoscan/widgets/navbar.dart';
import 'package:ecoscan/utils/colors.dart';

class BiopediaScreen extends StatefulWidget {
  const BiopediaScreen({super.key});

  @override
  State<BiopediaScreen> createState() => _BiopediaScreenState();
}

class _BiopediaScreenState extends State<BiopediaScreen> {
  int _selectedFilter = 0; // 0: Flora, 1: Fauna

  // Example flora categories
  final List<Map<String, String>> floraCategories = [
    {'image': 'assets/images/nativabg.png', 'title': 'Nativa'},
    {'image': 'assets/images/agricolabg.png', 'title': 'Agrícola'},
    {'image': 'assets/images/arvensebg.png', 'title': 'Arvense'},
  ];

  // Example fauna categories
  final List<Map<String, String>> faunaCategories = [
    {
      'bg': 'assets/images/mamiferobg.png',
      'icon': 'assets/images/mamifero.png',
      'title': 'Mamíferos',
    },
    {
      'bg': 'assets/images/avebg.png',
      'icon': 'assets/images/ave.png',
      'title': 'Aves',
    },
    {
      'bg': 'assets/images/reptilesbg.png',
      'icon': 'assets/images/reptiles.png',
      'title': 'Reptiles',
    },
    {
      'bg': 'assets/images/pecesbg.png',
      'icon': 'assets/images/peces.png',
      'title': 'Peces',
    },
    {
      'bg': 'assets/images/anfibiobg.png',
      'icon': 'assets/images/anfibio.png',
      'title': 'Anfibios',
    },
    {
      'bg': 'assets/images/insectosbg.png',
      'icon': 'assets/images/insectos.png',
      'title': 'Insectos',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorsWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              const CustomSearchBar(),
              // Flora/Fauna filter
              FilterSelector(
                selectedIndex: _selectedFilter,
                onChanged: (index) {
                  setState(() {
                    _selectedFilter = index;
                  });
                },
              ),
              const SizedBox(height: 6),
              // Categories (not scrollable)
              ...(_selectedFilter == 0
                  ? floraCategories
                      .map(
                        (cat) => FloraCategoryCard(
                          imageUrl: cat['image']!,
                          title: cat['title']!,
                          onTap: () {},
                        ),
                      )
                      .toList()
                  : faunaCategories
                      .map(
                        (cat) => CategoryButton(
                          backgroundImageUrl: cat['bg']!,
                          representativeImageUrl: cat['icon']!,
                          title: cat['title']!,
                          onTap: () {},
                        ),
                      )
                      .toList()),
            ],
          ),
        ),
      ),
    );
  }
}
