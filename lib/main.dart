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
        <div id="map"></div>
        <script>
          var map = new maplibregl.Map({
              container: 'map',
              style: 'assets/empty_style (5).json',
              zoom: 15,
              center: [57.1667, 50.2833]
          });

          map.on('load', function () {
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

          map.addControl(
            new maplibregl.GeolocateControl({
            positionOptions: {
            enableHighAccuracy: true
            },
            trackUserLocation: true
            })
          );

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
