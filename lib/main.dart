import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemapsapp/map_screen.dart';

void main() {
  runApp(const GoogleMapsApp());
}

class GoogleMapsApp extends StatelessWidget {
  const GoogleMapsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home:  MapScreen(),
    );
  }
}
