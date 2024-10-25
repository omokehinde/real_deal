import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;
import '../utils/app_colors.dart';
import '../utils/constants.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  final Set<TileOverlay> _heatmapOverlay = {};
  bool _showHeatmap = false;
  bool _showViewOptions = false;
  bool _isSelected = false;
  String _selectedView = '';
  List<HeatmapPoint> _heatmapPoints = [];

  final LatLng _center = const LatLng(
    Constants.defaultLatitude,
    Constants.defaultLongitude,
  );

  @override
  void initState() {
    super.initState();
    _loadRealEstateOffers();
    _loadHeatmapData();
  }

  void _toggleSelection() {
    setState(() {
      _isSelected = !_isSelected;
      _showViewOptions = !_showViewOptions;
    });
  }

  void _loadRealEstateOffers() {
    final offers = [
      {'position': const LatLng(45.521563, -122.677433), 'price': '11 млн ₽'},
      {'position': const LatLng(45.525563, -122.687433), 'price': '7,8 млн ₽'},
      {'position': const LatLng(45.518563, -122.667433), 'price': '19,3 млн ₽'},
      {'position': const LatLng(45.528563, -122.657433), 'price': '6,5 млн ₽'},
      {'position': const LatLng(45.515563, -122.697433), 'price': '6,95 млн ₽'},
    ];

    setState(() {
      _markers.addAll(offers.map((offer) => Marker(
            markerId: MarkerId(offer['price'] as String),
            position: offer['position'] as LatLng,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
            infoWindow: InfoWindow(
              title: offer['price'] as String,
            ),
          )));
    });
  }

  void _loadHeatmapData() {
    _heatmapPoints = [
      HeatmapPoint(const LatLng(45.521563, -122.677433), 0.8),
      HeatmapPoint(const LatLng(45.525563, -122.687433), 0.9),
      HeatmapPoint(const LatLng(45.518563, -122.667433), 0.7),
      HeatmapPoint(const LatLng(45.528563, -122.657433), 0.85),
      HeatmapPoint(const LatLng(45.515563, -122.697433), 0.75),
    ];
    _updateHeatmapOverlay();
  }

  void _updateHeatmapOverlay() {
    if (_showHeatmap) {
      setState(() {
        _heatmapOverlay.add(
          TileOverlay(
            tileOverlayId: const TileOverlayId('heatmap'),
            tileProvider: HeatmapTileProvider(
              points: _heatmapPoints,
              radius: 40,
              startColor: Colors.orange.shade300,
              endColor: Colors.orange.shade700,
            ),
          ),
        );
      });
    } else {
      setState(() {
        _heatmapOverlay.clear();
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _setMapStyle(controller);
  }

  Future<void> _setMapStyle(GoogleMapController controller) async {
    const String mapStyle = '''
      [
        {
          "elementType": "geometry",
          "stylers": [{"color": "#242f3e"}]
        },
        {
          "elementType": "labels.text.stroke",
          "stylers": [{"color": "#242f3e"}]
        },
        {
          "elementType": "labels.text.fill",
          "stylers": [{"color": "#746855"}]
        },
        {
          "featureType": "water",
          "elementType": "geometry",
          "stylers": [{"color": "#17263c"}]
        },
        {
          "featureType": "water",
          "elementType": "labels.text.fill",
          "stylers": [{"color": "#515c6d"}]
        }
      ]
    ''';
    await controller.setMapStyle(mapStyle);
  }

  Widget _buildViewOption(String label, IconData icon) {
  final isSelected = _selectedView == label;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: GestureDetector(
      onTap: () {
        setState(() {
          _selectedView = label;
          _showHeatmap = label != 'Without any layer';
          _updateHeatmapOverlay();
          _showViewOptions = false;
          _isSelected = false;
        });
      },
      child: Row(
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primary : Colors.grey[600],
            size: 22,
          ),
          const SizedBox(width: 15),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.primary : Colors.grey[800],
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildTopBar() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search location',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.tune, color: Colors.grey),
              onPressed: () {
                setState(() {
                  _showViewOptions = !_showViewOptions;
                });
              },
            ),
          ),
        ],
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: Constants.defaultMapZoom,
            ),
            markers: _markers,
            tileOverlays: _heatmapOverlay,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            zoomControlsEnabled: false,
          ),
          _buildTopBar(),
          // Bottom controls
          Positioned(
            bottom: 90, 
            left: 15,
            right: 15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Circular button on the left
                GestureDetector(
                  onTap: _toggleSelection,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color:  AppColors.subtext,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.filter_alt,
                      color: AppColors.white,
                    ),
                  ),
                ),
                // Button for "List of variants"
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.subtext,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.list,
                        color: AppColors.white,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'List of variants',
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // View options when circular button is selected
          if (_showViewOptions)
            Positioned(
              bottom: 150,
              left: 25, 
              child: Container(
                width: 200,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildViewOption('Cosy areas', Icons.home),
                    _buildViewOption('Price', Icons.attach_money),
                    _buildViewOption('Infrastructure', Icons.location_city),
                    _buildViewOption('Without any layer', Icons.layers_clear),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
  }

class HeatmapPoint {
  final LatLng location;
  final double intensity;

  HeatmapPoint(this.location, this.intensity);
}

class HeatmapTileProvider implements TileProvider {
  final List<HeatmapPoint> points;
  final int radius;
  final int tileSize;
  final Color startColor;
  final Color endColor;

  HeatmapTileProvider({
    required this.points,
    this.radius = 30,
    this.tileSize = 256,
    required this.startColor,
    required this.endColor,
  });

  @override
  Future<Tile> getTile(int x, int y, int? zoom) async {
    if (zoom == null) return TileProvider.noTile;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final tileBounds = _getTileBounds(x, y, zoom);
    final relevantPoints = _getPointsInTile(tileBounds);

    for (final point in relevantPoints) {
      final pixelPoint = _latLngToPixel(point.location, tileBounds);
      _drawHeatmapPoint(canvas, pixelPoint, point.intensity);
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(tileSize, tileSize);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    if (bytes == null) return TileProvider.noTile;
    return Tile(tileSize, tileSize, bytes.buffer.asUint8List());
  }

  void _drawHeatmapPoint(Canvas canvas, Offset position, double intensity) {
    final paint = Paint()
      ..shader = ui.Gradient.radial(
        position,
        radius.toDouble(),
        [
          startColor.withOpacity(intensity * 0.7),
          endColor.withOpacity(0),
        ],
      );

    canvas.drawCircle(position, radius.toDouble(), paint);
  }

  LatLngBounds _getTileBounds(int x, int y, int zoom) {
    final n = math.pow(2.0, zoom).toDouble();
    final tileX = x / n;
    final tileY = y / n;
    
    final sw = LatLng(
      _tileY2Lat(tileY + 1, n),
      _tileX2Lng(tileX, n),
    );
    final ne = LatLng(
      _tileY2Lat(tileY, n),
      _tileX2Lng(tileX + 1, n),
    );
    
    return LatLngBounds(southwest: sw, northeast: ne);
  }

  double _tileX2Lng(double x, double n) => x * 360.0 / n - 180.0;
  
  double _tileY2Lat(double y, double n) {
    final latRad = math.atan(math.exp(math.pi * (1 - 2 * y / n)));
    return (2 * latRad - math.pi/2) * 180.0 / math.pi;
  }

  List<HeatmapPoint> _getPointsInTile(LatLngBounds bounds) {
    return points.where((point) => bounds.contains(point.location)).toList();
  }

  Offset _latLngToPixel(LatLng latLng, LatLngBounds bounds) {
    final double x = (latLng.longitude - bounds.southwest.longitude) /
        (bounds.northeast.longitude - bounds.southwest.longitude) *
        tileSize;
    final double y = (latLng.latitude - bounds.northeast.latitude) /
        (bounds.southwest.latitude - bounds.northeast.latitude) *
        tileSize;
    return Offset(x, y);
  }
}



