class Review {
  final String id;
  final String restaurantId;
  final String userId;
  final String userName;
  final String comment;
  final double rating;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.restaurantId,
    required this.userId,
    required this.userName,
    required this.comment,
    required this.rating,
    required this.createdAt,
  });

  factory Review.fromMap(Map<String, dynamic> map, String id) {
    return Review(
      id: id,
      restaurantId: map['restaurantId'],
      userId: map['userId'],
      userName: map['userName'],
      comment: map['comment'],
      rating: map['rating'].toDouble(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'restaurantId': restaurantId,
      'userId': userId,
      'userName': userName,
      'comment': comment,
      'rating': rating,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}