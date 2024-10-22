import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(
    Constants.defaultLatitude,
    Constants.defaultLongitude,
  );

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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
          ),
          _buildSearchBar(),
          _buildFilterChips(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Positioned(
      top: 50,
      left: Constants.defaultPadding,
      right: Constants.defaultPadding,
      child: SearchBar(
        leading: const Icon(Icons.search),
        trailing: const [Icon(Icons.tune)],
        hintText: 'Search location',
        backgroundColor: WidgetStateProperty.all(AppColors.white),
      ),
    );
  }

  Widget _buildFilterChips() {
    return const Positioned(
      top: 110,
      left: Constants.defaultPadding,
      right: Constants.defaultPadding,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _FilterChip(label: 'Price'),
            SizedBox(width: 8),
            _FilterChip(label: 'Location'),
            SizedBox(width: 8),
            _FilterChip(label: 'Infrastructure'),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;

  const _FilterChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      onSelected: (bool selected) {},
      backgroundColor: AppColors.white,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}