import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;
import '../utils/app_colors.dart';
import '../utils/constants.dart';

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
    this.startColor = Colors.green,
    this.endColor = Colors.red,
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
          startColor.withOpacity(intensity * 0.6),
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
  String _selectedView = 'price'; // 'price', 'location', 'infrastructure'
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

  void _loadRealEstateOffers() {
    // Simulated real estate data
    final offers = [
      {'position': const LatLng(45.521563, -122.677433), 'price': '\$450,000'},
      {'position': const LatLng(45.525563, -122.687433), 'price': '\$380,000'},
      {'position': const LatLng(45.518563, -122.667433), 'price': '\$520,000'},
    ];

    setState(() {
      _markers.addAll(offers.map((offer) => Marker(
            markerId: MarkerId(offer['price'] as String),
            position: offer['position'] as LatLng,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
            infoWindow: InfoWindow(title: offer['price'] as String),
          )));
    });
  }

  void _loadHeatmapData() {
    // Simulated safety and convenience data points
    _heatmapPoints = [
      HeatmapPoint(const LatLng(45.521563, -122.677433), 0.8),
      HeatmapPoint(const LatLng(45.525563, -122.687433), 0.9),
      HeatmapPoint(const LatLng(45.518563, -122.667433), 0.7),
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
              radius: 30,
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
          "elementType": "labels.text.fill",
          "stylers": [{"color": "#746855"}]
        }
      ]
    ''';
    
    await controller.setMapStyle(mapStyle);
  }

  void _updateView(String view) {
    setState(() {
      _selectedView = view;
      // Here you would implement the logic to update markers based on the selected view
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          ),
          _buildTopControls(),
          _buildBottomControls(),
        ],
      ),
    );
  }

  Widget _buildTopControls() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSearchBar(),
          const SizedBox(height: 12),
          _buildFilterChips(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SearchBar(
        leading: const Icon(Icons.search, color: AppColors.text),
        trailing: [
          IconButton(
            icon: const Icon(Icons.tune, color: AppColors.text),
            onPressed: () {
              // Show filters dialog
            },
          ),
        ],
        hintText: 'Search location',
        backgroundColor: MaterialStateProperty.all(AppColors.white),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            label: 'Price',
            selected: _selectedView == 'price',
            onSelected: (selected) => _updateView('price'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Location',
            selected: _selectedView == 'location',
            onSelected: (selected) => _updateView('location'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Infrastructure',
            selected: _selectedView == 'infrastructure',
            onSelected: (selected) => _updateView('infrastructure'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 32,
      right: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'heatmap',
            onPressed: () {
              setState(() {
                _showHeatmap = !_showHeatmap;
                _updateHeatmapOverlay();
              });
            },
            backgroundColor: _showHeatmap ? AppColors.primary : AppColors.white,
            child: Icon(
              Icons.layers,
              color: _showHeatmap ? AppColors.white : AppColors.text,
            ),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'location',
            onPressed: () {
              mapController.animateCamera(
                CameraUpdate.newLatLng(_center),
              );
            },
            backgroundColor: AppColors.white,
            child: const Icon(
              Icons.my_location,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: selected ? AppColors.white : AppColors.text,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: AppColors.white,
      selectedColor: AppColors.primary,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
    );
  }
}