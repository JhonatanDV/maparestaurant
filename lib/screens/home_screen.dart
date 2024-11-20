import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/restaurant_details_sheet.dart';
import '../widgets/restaurant_marker.dart';
import '../screens/add_restaurant_screen.dart';
import '../models/restaurant.dart';
import '../services/restaurant_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MapController _mapController = MapController();
  final RestaurantService _restaurantService = RestaurantService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_business),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddRestaurantScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Restaurant>>(
        stream: _restaurantService.getRestaurants(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: LatLng(0, 0),
              zoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'restaurant_map_reviews',
              ),
              MarkerLayer(
                markers: snapshot.data!
                    .map((restaurant) => RestaurantMarker(
                          restaurant: restaurant,
                          onTap: () => _showRestaurantDetails(restaurant),
                        ))
                    .toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showRestaurantDetails(Restaurant restaurant) {
    showModalBottomSheet(
      context: context,
      builder: (context) => RestaurantDetailsSheet(restaurant: restaurant),
    );
  }
}