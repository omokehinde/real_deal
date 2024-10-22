class Offer {
  final String id;
  final String address;
  final double price;
  final String imageUrl;
  final double distance;
  final bool isForRent;
  final double latitude;
  final double longitude;

  Offer({
    required this.id,
    required this.address,
    required this.price,
    required this.imageUrl,
    required this.distance,
    required this.isForRent,
    required this.latitude,
    required this.longitude,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'],
      address: json['address'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      distance: json['distance'].toDouble(),
      isForRent: json['isForRent'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
    );
  }
}