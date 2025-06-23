import 'package:ecoscan/screens/specie_info.dart';
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
  const BiopediaScreen({super.key});

  @override
  State<BiopediaScreen> createState() => _BiopediaScreenState();
}

class _BiopediaScreenState extends State<BiopediaScreen> {
  int _selectedFilter = 0; // 0: Flora, 1: Fauna
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
  Widget build(BuildContext context) {
    // Determina la categoría y especies seleccionadas
    final isFlora = _selectedFilter == 0;
    final categories = isFlora ? floraCategories : faunaCategories;
    final selectedCategory = categories[_selectedCategoryIndex]['title']!;

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
                    _showSpeciesList = false;
                    _selectedCategoryIndex = 0;
                  });
                },
              ),
              const SizedBox(height: 12),
              // Mostrar el título de la categoría debajo de los filtros cuando se muestran especies
              if (_showSpeciesList)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
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
                            items:
                                faunaCategories, // <-- Cambia imageUrls por items
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
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    selectedCategory,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              const SizedBox(height: 8),
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
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
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
      // Aquí iría tu navbar si lo tienes como bottomNavigationBar
    );
  }
}
