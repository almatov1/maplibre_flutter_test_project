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
  late MaplibreMapController controller;

  _onMapCreated(MaplibreMapController controller) {
    this.controller = controller;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MaplibreMap(
      onMapClick: (point, coordinates) {
        controller
            .moveCamera(CameraUpdate.newCameraPosition(const CameraPosition(
          target: LatLng(50.2833322, 57.166666),
          tilt: 30.0,
          zoom: 15.0,
        )));
      },
      styleString: 'assets/demo.json',
      onMapCreated: _onMapCreated,
      onStyleLoadedCallback: () {},
      initialCameraPosition:
          const CameraPosition(target: LatLng(50.2833322, 57.166666), zoom: 0),
    ));
  }
}
