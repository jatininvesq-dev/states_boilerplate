import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Map tab using OpenStreetMap tiles (no native Google Maps Gradle deps).
class MapView extends StatelessWidget {
  const MapView({super.key});

  static const _initialCenter = LatLng(37.7749, -122.4194);
  static const _initialZoom = 12.0;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: _initialCenter,
        initialZoom: _initialZoom,
        interactionOptions: InteractionOptions(
          flags: InteractiveFlag.all,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.states_app',
        ),
        const MarkerLayer(
          markers: [
            Marker(
              point: _initialCenter,
              width: 40,
              height: 40,
              child: Icon(
                Icons.location_pin,
                color: Color.fromARGB(255, 64, 14, 150),
                size: 40,
              ),
            ),
          ],
        ),
      ],  
    );
  }
}
