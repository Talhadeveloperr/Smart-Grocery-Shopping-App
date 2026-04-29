// ===================== providers/product_provider.dart =====================
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/dummy_data.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = dummyProducts;

  List<Product> get products => _products;

  // Updated logic to find other sellers/similar products
  List<Product> getComparisons(Product currentProduct) {
    // 1. Get keywords from the name (ignore short words like 'and', 'the')
    List<String> keywords = currentProduct.name
        .toLowerCase()
        .split(' ')
        .where((word) => word.length > 3)
        .toList();

    return _products.where((p) {
      // 2. Don't compare to itself
      if (p.id == currentProduct.id) return false;

      // 3. Must be in the same category to be a valid comparison
      if (p.category != currentProduct.category) return false;

      // 4. Check if the product name contains any of our main keywords
      return keywords.any((key) => p.name.toLowerCase().contains(key));
    }).toList();
  }
}

