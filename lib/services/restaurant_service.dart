import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/restaurant.dart';
import '../models/review.dart';

class RestaurantService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Restaurant>> getRestaurants() {
    return _firestore.collection('restaurants').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Restaurant.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> addRestaurant(Restaurant restaurant) {
    return _firestore.collection('restaurants').add(restaurant.toMap());
  }

  Future<void> addReview(Review review) async {
    final batch = _firestore.batch();
    
    // Add the review
    final reviewRef = _firestore.collection('reviews').doc();
    batch.set(reviewRef, review.toMap());

    // Update restaurant rating
    final restaurantRef = _firestore
        .collection('restaurants')
        .doc(review.restaurantId);
    
    final restaurantDoc = await restaurantRef.get();
    final currentRating = restaurantDoc.data()?['rating'] ?? 0.0;
    final currentCount = restaurantDoc.data()?['reviewCount'] ?? 0;
    
    final newCount = currentCount + 1;
    final newRating = ((currentRating * currentCount) + review.rating) / newCount;
    
    batch.update(restaurantRef, {
      'rating': newRating,
      'reviewCount': newCount,
    });

    return batch.commit();
  }

  Stream<List<Review>> getRestaurantReviews(String restaurantId) {
    return _firestore
        .collection('reviews')
        .where('restaurantId', isEqualTo: restaurantId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Review.fromMap(doc.data(), doc.id))
          .toList();
    });
  }
}