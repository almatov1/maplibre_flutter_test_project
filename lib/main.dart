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
                style:
                    'https://api.maptiler.com/maps/streets/style.json?key=get_your_own_OpIi9ZULNHzrESv6T2vL',
                zoom: 12,
                center: [-87.622088, 41.878781]
            });

            map.on('load', function () {
                map.addSource('planet_osm_line', {
                    'type': 'vector',
                    'tiles': [
                        'http://localhost:7800/public.planet_osm_line/{z}/{x}/{y}.pbf'
                    ],
                    'minzoom': 6,
                    'maxzoom': 14
                });
                map.addLayer(
                    {
                        'id': 'public.planet_osm_line-data',
                        'type': 'line',
                        'source': 'planet_osm_line',
                        'source-layer': 'public.planet_osm_line',
                        'layout': {
                            'line-cap': 'round',
                            'line-join': 'round'
                        },
                        'paint': {
                          'line-opacity': 0.6,
                          'line-color': 'rgb(53, 175, 109)',
                          'line-width': 2
                        }
                    },
                    'water_name_line'
                );
            });

            map.addControl(new maplibregl.NavigationControl());
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
