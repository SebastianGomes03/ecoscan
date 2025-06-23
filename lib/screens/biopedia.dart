import 'package:ecoscan/screens/specie_info.dart';
import 'package:ecoscan/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:ecoscan/widgets/searchbar.dart';
import 'package:ecoscan/widgets/filter.dart';
import 'package:ecoscan/widgets/flora_category.dart';
import 'package:ecoscan/widgets/category.dart';
import 'package:ecoscan/widgets/flora_filter.dart';
import 'package:ecoscan/widgets/fauna_filter.dart';
import 'package:ecoscan/widgets/species_card.dart';
import 'package:ecoscan/utils/colors.dart';

class BiopediaScreen extends StatefulWidget {
  final int initialFilter;

  const BiopediaScreen({super.key, this.initialFilter = 0});

  @override
  State<BiopediaScreen> createState() => _BiopediaScreenState();
}

class _BiopediaScreenState extends State<BiopediaScreen> {
  late int _selectedFilter = 0; // 0: Flora, 1: Fauna
  bool _showSpeciesList = false;
  int _selectedCategoryIndex = 0;

  // Ejemplo de categorías flora
  final List<Map<String, String>> floraCategories = [
    {'image': 'assets/images/nativabg.png', 'title': 'Nativa'},
    {'image': 'assets/images/agricolabg.png', 'title': 'Agrícola'},
    {'image': 'assets/images/arvensebg.png', 'title': 'Arvense'},
  ];

  // Ejemplo de categorías fauna
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

  // Ejemplo de especies por categoría (puedes reemplazar con tus datos reales)
  final Map<String, List<Map<String, String>>> floraSpecies = {
    'Nativa': [
      {
        'image': 'assets/images/nativa.png',
        'name': 'Orquídea',
        'scientific': 'Orchidaceae',
      },
      // ...más especies
    ],
    'Agrícola': [
      {
        'image': 'assets/images/nativa.png',
        'name': 'Maíz',
        'scientific': 'Zea mays',
      },
    ],
    'Arvense': [
      {
        'image': 'assets/images/nativa.png',
        'name': 'Diente de león',
        'scientific': 'Taraxacum officinale',
      },
    ],
  };

  final Map<String, List<Map<String, String>>> faunaSpecies = {
    'Mamíferos': [
      {
        'image': 'assets/images/mammal.png',
        'name': 'Mono capuchino',
        'scientific': 'Cebus capucinus',
      },
      {
        'image': 'assets/images/mammal.png',
        'name': 'Mono capuchino',
        'scientific': 'Cebus capucinus',
      },
      {
        'image': 'assets/images/mammal.png',
        'name': 'Mono capuchino',
        'scientific': 'Cebus capucinus',
      },
      // ...más especies
    ],
    'Aves': [
      {
        'image': 'assets/images/mammal.png',
        'name': 'Colibrí',
        'scientific': 'Trochilidae',
      },
    ],
    'Reptiles': [
      {
        'image': 'assets/images/mammal.png',
        'name': 'Iguana',
        'scientific': 'Iguana iguana',
      },
    ],
    'Peces': [
      {
        'image': 'assets/images/mammal.png',
        'name': 'Pez gato',
        'scientific': 'Siluriformes',
      },
    ],
    'Anfibios': [
      {
        'image': 'assets/images/mammal.png',
        'name': 'Rana verde',
        'scientific': 'Hyla cinerea',
      },
    ],
    'Insectos': [
      {
        'image': 'assets/images/mammal.png',
        'name': 'Mariposa',
        'scientific': 'Lepidoptera',
      },
    ],
  };

  // Para los filtros de flora/fauna
  int _selectedFloraFilter = 0;
  int _selectedFaunaFilter = 0;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialFilter; // Set from parameter
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final isSmall = width < 360;
    final isLarge = width > 600;
    double horizontalPadding = width * 0.015 + 4;
    double verticalPadding = width * 0.01 + 2;
    double filterSpacing = isSmall ? 6 : (isLarge ? 18 : 12);
    double categoryTitleFontSize = isSmall ? 18 : (isLarge ? 36 : 28);
    double gridSpacing = isSmall ? 8 : 16;
    int gridCount = isLarge ? 3 : 2;
    double gridAspectRatio = isLarge ? 1 : 0.8;

    // Determina la categoría y especies seleccionadas
    final isFlora = _selectedFilter == 0;
    final categories = isFlora ? floraCategories : faunaCategories;
    final selectedCategory = categories[_selectedCategoryIndex]['title']!;

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
              const CustomSearchBar(),
              FilterSelector(
                selectedIndex: _selectedFilter,
                onChanged: (index) {
                  setState(() {
                    _selectedFilter = index;
                    _showSpeciesList = false;
                    _selectedCategoryIndex = 0;
                  });
                },
              ),
              SizedBox(height: filterSpacing),
              if (_showSpeciesList)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: filterSpacing / 2),
                  child:
                      isFlora
                          ? FloraFilterBar(
                            selectedIndex: _selectedFloraFilter,
                            imageUrls:
                                floraCategories
                                    .map((c) => c['image']!)
                                    .toList(),
                            onChanged: (i) {
                              setState(() {
                                _selectedFloraFilter = i;
                                _selectedCategoryIndex = i;
                              });
                            },
                          )
                          : FaunaFilterBar(
                            selectedIndex: _selectedFaunaFilter,
                            items: faunaCategories,
                            onChanged: (i) {
                              setState(() {
                                _selectedFaunaFilter = i;
                                _selectedCategoryIndex = i;
                              });
                            },
                          ),
                ),
              if (_showSpeciesList)
                Padding(
                  padding: EdgeInsets.only(bottom: filterSpacing / 2),
                  child: Text(
                    selectedCategory,
                    style: TextStyle(
                      fontSize: categoryTitleFontSize,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              SizedBox(height: filterSpacing / 2),
              Expanded(
                child:
                    !_showSpeciesList
                        // Vista de categorías
                        ? ListView(
                          children:
                              categories.asMap().entries.map((entry) {
                                final i = entry.key;
                                final cat = entry.value;
                                return isFlora
                                    ? FloraCategoryCard(
                                      imageUrl: cat['image']!,
                                      title: cat['title']!,
                                      onTap: () {
                                        setState(() {
                                          _showSpeciesList = true;
                                          _selectedCategoryIndex = i;
                                          _selectedFloraFilter = i;
                                        });
                                      },
                                    )
                                    : CategoryButton(
                                      backgroundImageUrl: cat['bg']!,
                                      representativeImageUrl: cat['icon']!,
                                      title: cat['title']!,
                                      onTap: () {
                                        setState(() {
                                          _showSpeciesList = true;
                                          _selectedCategoryIndex = i;
                                          _selectedFaunaFilter = i;
                                        });
                                      },
                                    );
                              }).toList(),
                        )
                        // Vista de especies de la categoría seleccionada
                        : GridView.count(
                          crossAxisCount: gridCount,
                          childAspectRatio: gridAspectRatio,
                          mainAxisSpacing: gridSpacing,
                          crossAxisSpacing: gridSpacing,
                          children:
                              (isFlora
                                      ? floraSpecies[selectedCategory]
                                      : faunaSpecies[selectedCategory])!
                                  .map(
                                    (sp) => SpeciesCard(
                                      imageUrl: sp['image']!,
                                      name: sp['name']!,
                                      scientificName: sp['scientific']!,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => SpecieInfoScreen(
                                                  imageUrl: sp['image']!,
                                                  name: sp['name']!,
                                                  scientificName:
                                                      sp['scientific']!,
                                                  description:
                                                      'Aquí va la descripción de la especie.',
                                                  dataCards: [
                                                    {
                                                      'label': 'Peso',
                                                      'value': '1.7kg - 4.7kg',
                                                    },
                                                    {
                                                      'label': 'Longitud',
                                                      'value': '35cm - 50cm',
                                                    },
                                                    {
                                                      'label': 'Origen',
                                                      'value': 'Nativa',
                                                    },
                                                    {
                                                      'label': 'Amenaza',
                                                      'value': 'No peligroso',
                                                    },
                                                  ],
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                  .toList(),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
