// ===================== providers/product_provider.dart =====================
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/dummy_data.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = dummyProducts;

  List<Product> get products => _products;

  List<Product> getProductsByName(String name) {
    return _products.where((p) => p.name == name).toList();
  }
}

