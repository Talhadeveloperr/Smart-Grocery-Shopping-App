// ===================== models/product.dart =====================
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
  });

  // Helper method to get category icon
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