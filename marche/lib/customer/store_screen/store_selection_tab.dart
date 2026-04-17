import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StoreSelectionScreen extends StatefulWidget {
  const StoreSelectionScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StoreSelectionScreenState createState() => _StoreSelectionScreenState();
}

class _StoreSelectionScreenState extends State<StoreSelectionScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};

  // Sample list of stores with addresses
  final List<Store> stores = [
    Store(
      name: 'Store A',
      address: '123 Main St, City, Country',
      latitude: 37.42796133580664,
      longitude: -122.085749655962,
    ),
    Store(
      name: 'Store B',
      address: '456 Market St, City, Country',
      latitude: 37.4219999,
      longitude: -122.0840575,
    ),
    Store(
      name: 'Store C',
      address: '789 Broadway Ave, City, Country',
      latitude: 37.4300,
      longitude: -122.0840,
    ),
    Store(
      name: 'Store D',
      address: '101 First Ave, City, Country',
      latitude: 37.4350,
      longitude: -122.0855,
    ),
    Store(
      name: 'Store E',
      address: '202 Elm St, City, Country',
      latitude: 37.4370,
      longitude: -122.0860,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Add markers for each store
    for (var store in stores) {
      _markers.add(Marker(
        markerId: MarkerId(store.name),
        position: LatLng(store.latitude, store.longitude),
        infoWindow: InfoWindow(title: store.name),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Store Selection"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          // Top Section - Google Map
          Container(
            height: MediaQuery.of(context).size.height /
                2, // Make map half the screen
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(37.42796133580664, -122.085749655962),
                  zoom: 14.0,
                ),
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                markers: _markers,
              ),
            ),
          ),

          // Bottom Section - Store List
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    "Available Stores",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: stores.length,
                    itemBuilder: (context, index) {
                      final store = stores[index];
                      return GestureDetector(
                        onTap: () {
                          // Handle store tap, navigate to details
                          if (kDebugMode) {
                            print('Tapped on ${store.name}');
                          }
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  store.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple,
                                      ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  store.address,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Colors.grey[600],
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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

class Store {
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  Store({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}