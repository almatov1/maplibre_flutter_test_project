import 'package:flutter/material.dart';
import 'package:maplibre_gl/mapbox_gl.dart';

void main() => runApp(
      const MaterialApp(
        home: FullMap(),
      ),
    );

class FullMap extends StatefulWidget {
  const FullMap({super.key});

  @override
  State createState() => FullMapState();
}

class FullMapState extends State<FullMap> {
  MaplibreMapController? mapController;

  _onMapCreated(MaplibreMapController controller) {
    mapController = controller;
  }

  @override
  void dispose() {
    mapController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MaplibreMap(
      onMapCreated: _onMapCreated,
      onStyleLoadedCallback: () {},
      initialCameraPosition:
          const CameraPosition(target: LatLng(50.26979, 57.21211), zoom: 0),
    ));
  }
}
