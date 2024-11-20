class Restaurant {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final String ownerId;
  final String imageUrl;
  final double rating;
  final int reviewCount;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.ownerId,
    required this.imageUrl,
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  factory Restaurant.fromMap(Map<String, dynamic> map, String id) {
    return Restaurant(
      id: id,
      name: map['name'],
      description: map['description'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      ownerId: map['ownerId'],
      imageUrl: map['imageUrl'],
      rating: map['rating'] ?? 0.0,
      reviewCount: map['reviewCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'ownerId': ownerId,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }
}