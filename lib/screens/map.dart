import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final isSmall = width < 360;
    final isLarge = width > 600;
    double borderRadius = isSmall ? 12 : (isLarge ? 40 : 28);

    return Scaffold(
      body: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(
              8.331607929262454,
              -62.67086882654499,
            ), // Guayana City, near the river
            initialZoom: 13.5,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.ecoscan',
            ),
          ],
        ),
      ),
    );
  }
}
