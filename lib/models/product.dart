// ===================== models/product.dart (Complete) =====================
class Product {
  final String id;
  final String name;
  final double price;
  final String storeId;
  final String imageUrl;
  final String description;
  final double rating;
  final int reviewCount;
  final String category;
  final bool inStock;
  final String unit;
  final String brand;
  final String model;
  final String warranty;
  final List<String> images;
  final List<String> features;
  final String sellerName;
  final double sellerRating;
  final int sellerReviews;
  final String deliveryEstimate;
  final double deliveryFee;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.storeId,
    this.imageUrl = '',
    this.description = '',
    this.rating = 0.0,
    this.reviewCount = 0,
    this.category = 'General',
    this.inStock = true,
    this.unit = 'piece',
    this.brand = '',
    this.model = '',
    this.warranty = '',
    this.images = const [],
    this.features = const [],
    this.sellerName = '',
    this.sellerRating = 0.0,
    this.sellerReviews = 0,
    this.deliveryEstimate = '',
    this.deliveryFee = 0.0,
  });

  String get categoryIcon {
    switch (category.toLowerCase()) {
      case 'dairy':
        return '🥛';
      case 'bakery':
        return '🍞';
      case 'vegetables':
        return '🥬';
      case 'fruits':
        return '🍎';
      default:
        return '🛒';
    }
  }
}