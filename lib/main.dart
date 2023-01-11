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
                style: {
                    'version': 8,
                    'sources': {
                        'raster-tiles': {
                            'type': 'raster',
                            'tiles': [
                                'https://stamen-tiles.a.ssl.fastly.net/watercolor/{z}/{x}/{y}.jpg'
                            ],
                            'tileSize': 256,
                            'attribution':
                                'Map tiles by <a target="_top" rel="noopener" href="http://stamen.com">Stamen Design</a>, under <a target="_top" rel="noopener" href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a>. Data by <a target="_top" rel="noopener" href="http://openstreetmap.org">OpenStreetMap</a>, under <a target="_top" rel="noopener" href="http://creativecommons.org/licenses/by-sa/3.0">CC BY SA</a>'
                        }
                    },
                    'layers': [
                        {
                            'id': 'simple-tiles',
                            'type': 'raster',
                            'source': 'raster-tiles',
                            'minzoom': 0,
                            'maxzoom': 22
                        }
                    ]
                },
                zoom: 15,
                center: [57.1667, 50.2833]
            });

                map.on('load', function () {
                  map.addSource('openmaptiles', {
                      'type': 'geojson',
                      'data': {
                        "type": "Feature",
                        "properties": {
                          "@id": "way/231206673",
                          "addr:city": "Актобе",
                          "addr:housenumber": "111",
                          "addr:street": "11-й микрорайон",
                          "building": "apartments",
                          "building:levels": "9"
                        },
                        "geometry": {
                          "type": "Polygon",
                          "coordinates": [
                            [
                              [
                                57.1953803,
                                50.2818373
                              ],
                              [
                                57.1953489,
                                50.2817299
                              ],
                              [
                                57.1954685,
                                50.2817156
                              ],
                              [
                                57.1957286,
                                50.2816844
                              ],
                              [
                                57.1960724,
                                50.2816433
                              ],
                              [
                                57.1960642,
                                50.2816154
                              ],
                              [
                                57.1960032,
                                50.2814072
                              ],
                              [
                                57.1959802,
                                50.2813286
                              ],
                              [
                                57.1961734,
                                50.2813055
                              ],
                              [
                                57.196297,
                                50.2817277
                              ],
                              [
                                57.1953803,
                                50.2818373
                              ]
                            ]
                          ]
                        },
                        "id": "way/231206673"
                      }
                  });
                  map.addLayer({
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
