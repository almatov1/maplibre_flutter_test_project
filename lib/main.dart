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
              style:
                  'https://api.maptiler.com/maps/streets/style.json?key=get_your_own_OpIi9ZULNHzrESv6T2vL',
              center: [57.1667, 50.2833],
              zoom: 15.5,
              pitch: 45,
              bearing: -17.6,
              container: 'map',
              antialias: true
          });

          var hoveredStateId = null;
          map.on('load', function () {
              // Insert the layer beneath any symbol layer.
              var layers = map.getStyle().layers;

              var labelLayerId;
              for (var i = 0; i < layers.length; i++) {
                  if (layers[i].type === 'symbol' && layers[i].layout['text-field']) {
                      labelLayerId = layers[i].id;
                      break;
                  }
              }

              map.addLayer(
                  {
                      'id': '3d-buildings',
                      'source': 'openmaptiles',
                      'source-layer': 'building',
                      'filter': ['==', 'extrude', 'true'],
                      'type': 'fill-extrusion',
                      'minzoom': 15,
                      'paint': {
                          'fill-extrusion-color': '#aaa',

                          // use an 'interpolate' expression to add a smooth transition effect to the
                          // buildings as the user zooms in
                          'fill-extrusion-height': [
                              'interpolate',
                              ['linear'],
                              ['zoom'],
                              15,
                              0,
                              15.05,
                              ['get', 'height']
                          ],
                          'fill-extrusion-base': [
                              'interpolate',
                              ['linear'],
                              ['zoom'],
                              15,
                              0,
                              15.05,
                              ['get', 'min_height']
                          ],
                          'fill-extrusion-opacity': 0.6
                      }
                  },
                  labelLayerId
              );

              map.on('mousemove', '3d-buildings', function (e) {
                 document.getElementById('info').innerHTML =
                  // e.point is the x, y coordinates of the mousemove event relative
                  // to the top-left corner of the map
                  JSON.stringify(e.point) +
                  '<br />' +
                  // e.lngLat is the longitude, latitude geographical position of the event
                  JSON.stringify(e.lngLat.wrap());
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
