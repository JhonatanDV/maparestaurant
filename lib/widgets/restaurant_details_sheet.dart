import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../models/review.dart';
import '../services/restaurant_service.dart';
import 'add_review_dialog.dart';

class RestaurantDetailsSheet extends StatelessWidget {
  final Restaurant restaurant;
  final RestaurantService _restaurantService = RestaurantService();

  RestaurantDetailsSheet({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                restaurant.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  Text('${restaurant.rating.toStringAsFixed(1)} (${restaurant.reviewCount} reviews)'),
                ],
              ),
              const SizedBox(height: 16),
              Text(restaurant.description),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _showAddReviewDialog(context),
                child: const Text('Add Review'),
              ),
              const SizedBox(height: 16),
              const Text('Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Expanded(
                child: StreamBuilder<List<Review>>(
                  stream: _restaurantService.getRestaurantReviews(restaurant.id),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView.builder(
                      controller: scrollController,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final review = snapshot.data![index];
                        return Card(
                          child: ListTile(
                            title: Row(
                              children: [
                                Text(review.userName),
                                const SizedBox(width: 8),
                                Row(
                                  children: List.generate(
                                    5,
                                    (index) => Icon(
                                      Icons.star,
                                      size: 16,
                                      color: index < review.rating
                                          ? Colors.amber
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(review.comment),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddReviewDialog(restaurantId: restaurant.id),
    );
  }
}