import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/restaurant.dart';

class RestaurantMarker extends Marker {
  RestaurantMarker({
    required Restaurant restaurant,
    required VoidCallback onTap,
  }) : super(
          point: LatLng(restaurant.latitude, restaurant.longitude),
          width: 40,
          height: 40,
          builder: (context) => GestureDetector(
            onTap: onTap,
            child: Column(
              children: [
                Icon(
                  Icons.restaurant,
                  color: Colors.red,
                  size: 30,
                ),
                Text(
                  restaurant.name,
                  style: TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
}