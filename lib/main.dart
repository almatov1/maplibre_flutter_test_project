import 'package:flutter/material.dart';
import 'package:maplibre_gl/mapbox_gl.dart';
import 'package:three_dart/three_dart.dart' as three;

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

  _onMapCreated(MaplibreMapController controller) async {
    this.controller = controller;

    three.PerspectiveCamera camera = three.PerspectiveCamera(40, 1, 0.1, 10);
    camera.position.z = 3;

    three.Scene scene = three.Scene();
    camera.lookAt(scene.position);

    scene.background = three.Color(1.0, 1.0, 1.0);
    scene.add(three.AmbientLight(0x222244, null));

    var geometryCylinder = three.CylinderGeometry(0.5, 0.5, 1, 32);
    var materialCylinder = three.MeshPhongMaterial({"color": 0xff0000});

    three.Mesh mesh = three.Mesh(geometryCylinder, materialCylinder);
    scene.add(mesh);

    var object = LayerProperties().add();

    controller.addLayer('custom', '3d-model', mesh);
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
