import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:marche/splashscreen.dart'; 

class MapPage extends StatefulWidget {
  final String selectedLocation;

  const MapPage({super.key, required this.selectedLocation});

  @override
  // ignore: library_private_types_in_public_api
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with AutomaticKeepAliveClientMixin {
  GoogleMapController? _mapController;

  final Map<String, LatLng> _locationCoordinates = {
    'Saket Select Walk': const LatLng(28.528358849356113, 77.21895107745588),
    'Ansal Plaza': const LatLng(28.51157923525707, 77.04187826482054),
    'Ambience Mall, Gurgaon': const LatLng(28.505664254896967, 77.09608474153308),
  };

  Set<Marker> _markers = {};
  List<String> _suggestions = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateMarkers();
      _centerMapOnSelectedLocation();
    });
  }

    @override
  void dispose() {
    _mapController?.dispose();
    _controller.dispose(); 
    super.dispose();
  }
    @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PageViewScreen()),
        );
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              indoorViewEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                _updateMarkers();
                _centerMapOnSelectedLocation();
              },
              initialCameraPosition: const CameraPosition(
                target: LatLng(28.528358849356113, 77.21895107745588),
                zoom: 14.0,
              ),
              markers: _markers,
            ),
            Positioned(
              top: 55.0,
              left: 16.0,
              right: 16.0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(45.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'Enter location',
                              border: InputBorder.none,
                              prefixIcon: const Icon(Icons.search, color: Colors.grey),
                              hintStyle: const TextStyle(color: Colors.grey), // Hint text color
                              contentPadding: const EdgeInsets.all(10.0),
                              suffixIcon: _controller.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, color: Colors.grey),
                                      onPressed: () {
                                        _controller.clear();
                                        setState(() {
                                          _suggestions = [];
                                          _updateMarkers(); // Reset markers when clearing the search
                                        });
                                      },
                                    )
                                  : null,
                            ),
                            style: const TextStyle(color: Colors.black), // Text color
                            cursorColor: Colors.grey,
                            onChanged: (value) {
                              _getSuggestions(value);
                            },
                            onSubmitted: (value) {
                              _searchLocation(value);
                            },
                            textInputAction: TextInputAction.done, 
                            onEditingComplete: () {
                              _searchLocation(_controller.text);
                            },
                          ),
                        ),
                      ],
                    ),
                    if (_suggestions.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.only(top: 8.0),
                        height: 200, 
                        child: Scrollbar(
                          child: ListView.builder(
                            itemCount: _suggestions.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.zero, 
                                child: ListTile(
                                  title: Text(
                                    _suggestions[index],
                                    style: const TextStyle(color: Colors.black), 
                                  ),
                                  onTap: () {
                                    _searchLocation(_suggestions[index]);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateMarkers() {
    setState(() {
      _markers = _locationCoordinates.values.map((location) {
        return Marker(
          markerId: MarkerId(location.toString()),
          position: location,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        );
      }).toSet();
    });
  }

  Future<void> _getSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }

    try {
      final places = await locationFromAddress(query);
      if (places.isNotEmpty) {
        final placemarks = await placemarkFromCoordinates(
          places.first.latitude,
          places.first.longitude,
        );

        setState(() {
          _suggestions = placemarks
              .map((placemark) =>
                  '${placemark.name}, ${placemark.locality}, ${placemark.country}')
              .toList();
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error getting suggestions: $e');
      setState(() {
        _suggestions = [];
      });
    }
  }

  Future<void> _searchLocation(String query) async {
    try {
      final places = await locationFromAddress(query);
      if (places.isNotEmpty) {
        final place = places.first;
        final latLng = LatLng(place.latitude, place.longitude);

        final placemarks = await placemarkFromCoordinates(
          place.latitude,
          place.longitude,
        );
        final locationName = '${placemarks.first.name}, ${placemarks.first.locality}, ${placemarks.first.country}';

        setState(() {
          _markers = {
            ..._markers,
            Marker(
              markerId: const MarkerId('searched_location'),
              position: latLng,
              infoWindow: InfoWindow(title: locationName),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            ),
          };
        });

        _mapController?.animateCamera(
          CameraUpdate.newLatLng(latLng),
        );

        // Close the keyboard and suggestions
        // ignore: use_build_context_synchronously
        FocusScope.of(context).unfocus();
        setState(() {
          _suggestions = [];
        });
      } else {
        _showErrorDialog('No locations found for the search query.');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error searching location: $e');
      _showErrorDialog('Error searching location. Please try again.');
    }
  }

  void _centerMapOnSelectedLocation() {
    if (_mapController == null) return;

    // Get the coordinates for the selected location
    final LatLng? selectedLatLng = _locationCoordinates[widget.selectedLocation];

    if (selectedLatLng != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(selectedLatLng),
      );
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
