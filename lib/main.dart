import 'package:flutter/material.dart';
import 'package:webviewx/webviewx.dart';

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
  late WebViewXController webviewController;

  String bodyHtml = '''
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="utf-8" />
        <title>View local GeoJSON</title>
        <meta name="viewport" content="initial-scale=1,maximum-scale=1,user-scalable=no" />
        <script src="https://unpkg.com/maplibre-gl@2.4.0/dist/maplibre-gl.js"></script>
        <link href="https://unpkg.com/maplibre-gl@2.4.0/dist/maplibre-gl.css" rel="stylesheet" />

        <style>
          body { margin: 0; padding: 0; }
          #map { position: absolute; top: 0; bottom: 0; width: 100%; }
        </style>
    </head>

    <body>
        <script src="https://unpkg.com/three@0.106.2/build/three.min.js"></script>
        <script src="https://unpkg.com/three@0.106.2/examples/js/loaders/GLTFLoader.js"></script>
        <div id="map"></div>
        <script>
          var map = new maplibregl.Map({
              container: 'map',
              style: 'assets/demo.json',
              zoom: 15,
              center: [57.1667, 50.2833]
          });

          // parameters to ensure the model is georeferenced correctly on the map
          var modelOrigin = [57.1667, 50.2833];
          var modelAltitude = 0;
          var modelRotate = [Math.PI / 2, 0, 0];

          var modelAsMercatorCoordinate = maplibregl.MercatorCoordinate.fromLngLat(
              modelOrigin,
              modelAltitude
          );

          // transformation parameters to position, rotate and scale the 3D model onto the map
          var modelTransform = {
              translateX: modelAsMercatorCoordinate.x,
              translateY: modelAsMercatorCoordinate.y,
              translateZ: modelAsMercatorCoordinate.z,
              rotateX: modelRotate[0],
              rotateY: modelRotate[1],
              rotateZ: modelRotate[2],
              /* Since our 3D model is in real world meters, a scale transform needs to be
              * applied since the CustomLayerInterface expects units in MercatorCoordinates.
              */
              scale: modelAsMercatorCoordinate.meterInMercatorCoordinateUnits()
          };

          var THREE = window.THREE;

          var customLayer = {
              id: '3d-model',
              type: 'custom',
              renderingMode: '3d',
              "minzoom": 20,
              onAdd: function (map, gl) {
                  this.camera = new THREE.Camera();
                  this.scene = new THREE.Scene();

                  // create two three.js lights to illuminate the model
                  var directionalLight = new THREE.DirectionalLight(0xffffff);
                  directionalLight.position.set(0, -70, 100).normalize();
                  this.scene.add(directionalLight);

                  var directionalLight2 = new THREE.DirectionalLight(0xffffff);
                  directionalLight2.position.set(0, 70, 100).normalize();
                  this.scene.add(directionalLight2);

                  // use the three.js GLTF loader to add the 3D model to the three.js scene
                  var loader = new THREE.GLTFLoader();
                  loader.load(
                      'https://maplibre.org/maplibre-gl-js-docs/assets/34M_17/34M_17.gltf',
                      function (gltf) {
                          this.scene.add(gltf.scene);
                      }.bind(this)
                  );
                  this.map = map;

                  // use the MapLibre GL JS map canvas for three.js
                  this.renderer = new THREE.WebGLRenderer({
                      canvas: map.getCanvas(),
                      context: gl,
                      antialias: true
                  });

                  this.renderer.autoClear = false;
              },
              render: function (gl, matrix) {
                  var rotationX = new THREE.Matrix4().makeRotationAxis(
                      new THREE.Vector3(1, 0, 0),
                      modelTransform.rotateX
                  );
                  var rotationY = new THREE.Matrix4().makeRotationAxis(
                      new THREE.Vector3(0, 1, 0),
                      modelTransform.rotateY
                  );
                  var rotationZ = new THREE.Matrix4().makeRotationAxis(
                      new THREE.Vector3(0, 0, 1),
                      modelTransform.rotateZ
                  );

                  var m = new THREE.Matrix4().fromArray(matrix);
                  var l = new THREE.Matrix4()
                      .makeTranslation(
                          modelTransform.translateX,
                          modelTransform.translateY,
                          modelTransform.translateZ
                      )
                      .scale(
                          new THREE.Vector3(
                              modelTransform.scale,
                              -modelTransform.scale,
                              modelTransform.scale
                          )
                      )
                      .multiply(rotationX)
                      .multiply(rotationY)
                      .multiply(rotationZ);

                  this.camera.projectionMatrix = m.multiply(l);
                  this.renderer.state.reset();
                  this.renderer.render(this.scene, this.camera);
                  this.map.triggerRepaint();
              }
          };

          map.on('load', function () {
                    map.addLayer(customLayer);
                    let fHover;

                    map.on('mousemove', function (e) {
                        var features = map.queryRenderedFeatures(e.point, {
                            layers: ['building-3d']
                        });
                        if (features[0]) {
                            mouseout();
                            mouseover(features[0]);
                        } else {
                            mouseout();
                        }

                    });

                    map.on('mouseout', function (e) {
                        mouseout();
                    });

                    function mouseout() {
                        if (!fHover) return;
                        map.getCanvasContainer().style.cursor = 'default';
                        map.setFeatureState({
                            source: fHover.source,
                            sourceLayer: fHover.sourceLayer,
                            id: fHover.id
                        }, {
                            hover: false
                        });

                    }

                    function mouseover(feature) {
                        fHover = feature;
                        map.getCanvasContainer().style.cursor = 'pointer';

                        map.setFeatureState({
                            source: fHover.source,
                            sourceLayer: fHover.sourceLayer,
                            id: fHover.id
                        }, {
                            hover: true
                        });
                    }

                    
                    map.on('click', 'building-3d', function (e) {
                        new maplibregl.Popup()
                            .setLngLat(e.lngLat)
                            .setHTML(e.features[0].properties.name)
                            .addTo(map);
                    });

                    map.on('mouseenter', 'states-layer', function () {
                        map.getCanvas().style.cursor = 'pointer';
                    });

                    map.on('mouseleave', 'states-layer', function () {
                        map.getCanvas().style.cursor = '';
                    });

          });
        </script>
    </body>

    </html>
  ''';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewX(
        initialContent: bodyHtml,
        initialSourceType: SourceType.html,
        onWebViewCreated: (controller) => webviewController = controller,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}
