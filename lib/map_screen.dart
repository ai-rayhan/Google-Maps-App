
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  Location location = Location();
  LocationData? currentLocation;
  Set<Marker> markers = {};
  List<LatLng> polylineCoordinates = [];
  Polyline? polyline;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    startLocationUpdates();
  }

  void getCurrentLocation() async {
    try {
      currentLocation = await location.getLocation();
      updateMarkerAndPolyline(LatLng(currentLocation!.latitude!, currentLocation!.longitude!));
      mapController!.animateCamera(CameraUpdate.newLatLng(LatLng(currentLocation!.latitude!, currentLocation!.longitude!)));
    } catch (e) {
      print("Error: $e");
    }
  }

  void startLocationUpdates() {
    location.onLocationChanged.listen((LocationData locationData) {
      updateMarkerAndPolyline(LatLng(locationData.latitude!, locationData.longitude!));
    });
  }

  void updateMarkerAndPolyline(LatLng latLng) {
    setState(() {
      markers.clear();
      markers.add(
        Marker(
          markerId: const MarkerId("myLocation"),
          position: latLng,
          onTap: () {
            showInfoWindow(latLng);
          },
        ),
      );

      if (currentLocation != null) {
        polylineCoordinates.add(LatLng(currentLocation!.latitude!, currentLocation!.longitude!));
        polyline = Polyline(
          polylineId: const PolylineId("poly"),
          points: polylineCoordinates,
          color: Colors.blue,
          width: 5,
        );
      }
      currentLocation = LocationData.fromMap({'latitude': latLng.latitude, 'longitude': latLng.longitude});
    });
  }

  void showInfoWindow(LatLng latLng) {
    mapController!.showMarkerInfoWindow(const MarkerId("myLocation"));
  }

  InfoWindow myInfoWindow(BuildContext context, LatLng latLng) {
    return InfoWindow(
      title: 'My current location',
      snippet: 'Latitude: ${latLng.latitude}, Longitude: ${latLng.longitude}',
      onTap: () {
        // Handle onTap for the info window if needed
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map with Location Updates'),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(0.0, 0.0),
          zoom: 15.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        markers: markers,
        polylines: Set<Polyline>.of(polyline != null ? [polyline!] : []),
       
      ),
    );
  }
}