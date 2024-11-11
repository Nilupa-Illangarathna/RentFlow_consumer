import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart'; // Add this import
import '../../../data_classes/stations_class.dart';
import '../../../global/api_caller.dart';
import '../../../global/global_settings.dart';
import '../../../widgets/common/elevated_button.dart';
import '../../../widgets/common/loading_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  late BitmapDescriptor customIcon;
  LatLng _currentLocation = const LatLng(7.2539, 80.5244); // Kadugannawa, Sri Lanka
  List<Station> _locations = [];
  bool _isLoading = true;
  bool _showAll = false;
  bool _showModal = true;
  Station? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  void _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        _showErrorSnackbar(context, 'Location permissions are denied');
        return;
      }
    }
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        print('Current Position: ${position.latitude}, ${position.longitude}');
      });
    } catch (e) {
      _showErrorSnackbar(context, 'Failed to get current location');
    }
    _setCustomMapPin();
    _fetchStations();
  }

  void _setCustomMapPin() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(150, 150)), // 5 times larger
      'assets/images/homepage/pinLarge.png',
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _toggleShowAll() {
    setState(() {
      _showAll = !_showAll;
    });
  }

  void _onStationSelected(LatLng position) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 17.0),
      ),
    );
  }

  void _showDetails(Station location) {
    setState(() {
      _selectedLocation = location;
      _onStationSelected(LatLng(location.latitude, location.longitude)); // Focus map on selected location
    });
  }

  void _hideDetails() {
    setState(() {
      _selectedLocation = null;
    });
  }

  double _calculateDistance(LatLng start, LatLng end) {
    var earthRadius = 6371000; // radius in meters
    var dLat = _deg2rad(end.latitude - start.latitude);
    var dLng = _deg2rad(end.longitude - start.longitude);
    var a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_deg2rad(start.latitude)) *
            math.cos(_deg2rad(end.latitude)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    var distance = earthRadius * c; // Distance in meters
    return distance;
  }

  double _deg2rad(double deg) {
    return deg * (math.pi / 180);
  }

  void _fetchStations() async {
    Map<String, dynamic> body = {};

    try {
      Map<String, dynamic>? response = await apiCaller.callApi(
        sessionToken: globalData.sessionToken,
        route: '/consumer/get_stations',
        body: body,
      );

      if (response?['is_success']) {
        setState(() {
          _locations = (response?['stations'] as List)
              .map((station) => Station.fromJson(station))
              .toList();
          _isLoading = false;
        });
      } else {
        _showErrorSnackbar(context, 'Failed to fetch stations.');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      _showErrorSnackbar(context, 'Failed to fetch stations.');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: LoadingScreen())
          : Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 2 / 3,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentLocation,
                zoom: 15.0, // Increased zoom level
              ),
              markers: _locations
                  .map((location) => Marker(
                markerId: MarkerId(location.name),
                position: LatLng(location.latitude, location.longitude),
                icon: customIcon,
                infoWindow: InfoWindow(title: location.name),
              ))
                  .toSet(),
            ),
          ),
          if (_showModal)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: StationListModal(
                currentLocation: _currentLocation,
                locations: _locations,
                onStationSelected: _onStationSelected,
                showAll: _showAll,
                toggleShowAll: _toggleShowAll,
                showDetails: _showDetails,
              ),
            ),
          if (_selectedLocation != null)
            DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.1,
              maxChildSize: 1.0,
              builder: (BuildContext context, ScrollController scrollController) {
                return StationDetailsModal(
                  location: _selectedLocation!,
                  onClose: _hideDetails,
                  scrollController: scrollController,
                  distance: _calculateDistance(_currentLocation, LatLng(_selectedLocation!.latitude, _selectedLocation!.longitude)),
                );
              },
            ),
        ],
      ),
    );
  }
}

class StationListModal extends StatefulWidget {
  final LatLng currentLocation;
  final List<Station> locations;
  final Function(LatLng) onStationSelected;
  final bool showAll;
  final VoidCallback toggleShowAll;
  final Function(Station) showDetails;

  const StationListModal({
    Key? key,
    required this.currentLocation,
    required this.locations,
    required this.onStationSelected,
    required this.showAll,
    required this.toggleShowAll,
    required this.showDetails,
  }) : super(key: key);

  @override
  _StationListModalState createState() => _StationListModalState();
}

class _StationListModalState extends State<StationListModal> {
  late List<Station> filteredLocations;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredLocations = widget.locations;
    searchController.addListener(_filterLocations);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterLocations);
    searchController.dispose();
    super.dispose();
  }

  void _filterLocations() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredLocations = widget.locations.where((location) => location.name.toLowerCase().contains(query)).toList();
    });
  }

  double _calculateDistance(LatLng start, LatLng end) {
    var earthRadius = 6371000; // radius in meters
    var dLat = _deg2rad(end.latitude - start.latitude);
    var dLng = _deg2rad(end.longitude - start.longitude);
    var a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_deg2rad(start.latitude)) * math.cos(_deg2rad(end.latitude)) * math.sin(dLng / 2) * math.sin(dLng / 2);
    var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    var distance = earthRadius * c; // Distance in meters
    return distance;
  }

  double _deg2rad(double deg) {
    return deg * (math.pi / 180);
  }

  String _formatDistance(double distance) {
    if (distance < 1000) {
      return '${distance.toStringAsFixed(0)} meters';
    } else {
      return '${(distance / 1000).toStringAsFixed(2)} kilometers';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.showAll ? 367 : 292,
      margin: EdgeInsets.only(left: 0, right: 0, bottom: 0),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 4,
            margin: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Color(0xFF717972),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          if (widget.showAll)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search Stations',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredLocations.length,
              itemBuilder: (context, index) {
                final location = filteredLocations[index];
                final distance = _calculateDistance(widget.currentLocation, LatLng(location.latitude, location.longitude));
                return StationCard(
                  name: location.name,
                  distance: distance,
                  onTap: () {
                    widget.onStationSelected(LatLng(location.latitude, location.longitude));
                    widget.showDetails(location);
                  },
                );
              },
            ),
          ),
          TextButton(
            onPressed: widget.toggleShowAll,
            child: Text('Show All'),
          ),
        ],
      ),
    );
  }
}

class StationCard extends StatelessWidget {
  final String name;
  final double distance;
  final VoidCallback onTap;

  const StationCard({
    Key? key,
    required this.name,
    required this.distance,
    required this.onTap,
  }) : super(key: key);

  String _formatDistance(double distance) {
    if (distance < 1000) {
      return '${distance.toStringAsFixed(0)} meters';
    } else {
      return '${(distance / 1000).toStringAsFixed(2)} kilometers';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFADF2C6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(7),
          topRight: Radius.circular(7),
          bottomLeft: Radius.circular(7),
          bottomRight: Radius.circular(7),
        ),
      ),
      child: Container(
        height: 57,
        child: ListTile(
          onTap: onTap,
          title: Text(
            name,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
              color: Color(0xFF1D1B20),
            ),
          ),
          trailing: Text(
            _formatDistance(distance),
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color: Color(0xFF49454F),
            ),
          ),
        ),
      ),
    );
  }
}

class StationDetailsModal extends StatefulWidget {
  final Station location;
  final VoidCallback onClose;
  final ScrollController scrollController;
  final double distance;

  const StationDetailsModal({
    Key? key,
    required this.location,
    required this.onClose,
    required this.scrollController,
    required this.distance,
  }) : super(key: key);

  @override
  _StationDetailsModalState createState() => _StationDetailsModalState();
}

class _StationDetailsModalState extends State<StationDetailsModal> {
  bool _isLoadingImage = true;
  List<Widget> _imageContainers = [];

  @override
  void initState() {
    super.initState();
    _initializeImageContainers(); // Initialize empty image containers
    _fetchStationImages(); // Fetch images sequentially
  }

  void _initializeImageContainers() {
    for (int i = 0; i < widget.location.imageCount; i++) {
      _imageContainers.add(
        Container(
          width: 207,
          height: 77,
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            color: Colors.grey[300], // Placeholder color
          ),
          child: Center(child: Text('Image not available', style: TextStyle(color: Colors.grey))),
        ),
      );
    }
  }

  void _fetchStationImages() async {
    for (int i = 1; i <= widget.location.imageCount; i++) {
      try {
        final imageUrl = '${globalData.baseUrl}/images/stations/${widget.location.stationId}/$i';
        setState(() {
          _imageContainers[i - 1] = Container(
            width: 207,
            height: 77,
            margin: EdgeInsets.only(right: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          );
        });
      } catch (e) {
        print('Failed to load image $i: $e');
        setState(() {
          _imageContainers[i - 1] = Text('Error loading image');
        });
      }
    }

    setState(() {
      _isLoadingImage = false;
    });
  }

  void _openGoogleMaps(double latitude, double longitude) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 0, right: 0, bottom: 0),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 4,
            margin: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Color(0xFF717972),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.location.name,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: widget.onClose,
              ),
            ],
          ),
          SizedBox(height: 8),
          Container(
            height: 77,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _imageContainers.length,
              itemBuilder: (context, index) {
                return _imageContainers[index];
              },
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Text(
              widget.location.description,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.25,
                color: Color(0xFF61646B),
              ),
            ),
          ),
          SizedBox(height: 16),
          WillowElevatedButton(
            onPressed: () {
              _openGoogleMaps(widget.location.latitude, widget.location.longitude);
            },
            buttonText: 'Directions',
            icon: Icons.directions, // Optional icon
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  String _formatDistance(double distance) {
    if (distance < 1000) {
      return '${distance.toStringAsFixed(0)} meters';
    } else {
      return '${(distance / 1000).toStringAsFixed(2)} kilometers';
    }
  }
}

class Station {
  int stationId;
  String name;
  double latitude;
  double longitude;
  String address;
  String description;
  int imageCount;

  Station({
    required this.stationId,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.description,
    required this.imageCount,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      stationId: json['station_id'],
      name: json['name'],
      latitude: double.parse(json['latitiude']), // Corrected key here
      longitude: double.parse(json['longitude']),
      address: json['address'],
      description: json['description'],
      imageCount: json['imageCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'station_id': stationId,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'description': description,
      'imageCount': imageCount,
    };
  }
}
