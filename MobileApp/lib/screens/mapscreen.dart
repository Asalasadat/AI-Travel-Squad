import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


import '../models/place_model.dart';

class MapScreen extends StatefulWidget {
  final PlaceModel place;

  const MapScreen({
    super.key,
    required this.place,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  late final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(
      widget.place.latitude,
      widget.place.longitude,
    ),
    zoom: 15,
  );

  late final Set<Marker> _markers = {
    Marker(
      markerId: MarkerId(widget.place.name),
      position: LatLng(
        widget.place.latitude,
        widget.place.longitude,
      ),
      infoWindow: InfoWindow(
        title: widget.place.name,
        snippet: widget.place.city,
      ),
    ),
  };

  Future<void> openGoogleMaps() async {
    final url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=${widget.place.latitude},${widget.place.longitude}",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Future<void> openDirections() async {
    final url = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&destination=${widget.place.latitude},${widget.place.longitude}&travelmode=driving",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.place.name),
        centerTitle: true,
      ),
      body: Column(
        children: [

          Expanded(
            child: GoogleMap(
              initialCameraPosition: _initialPosition,
              markers: _markers,
              myLocationEnabled: true,
              zoomControlsEnabled: true,
              mapToolbarEnabled: true,
              compassEnabled: true,
              onMapCreated: (controller) {
                mapController = controller;
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.navigation),
                    label: const Text("الاتجاهات"),
                    onPressed: openDirections,
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.map),
                    label: const Text("افتح في خرائط Google"),
                    onPressed: openGoogleMaps,
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}