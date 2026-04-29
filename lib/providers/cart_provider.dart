// ===================== providers/cart_provider.dart =====================
import 'package:flutter/material.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
}

class CartProvider extends ChangeNotifier {
  List<CartItem> _cart = [];
  List<Product> _savedForLater = [];

  List<CartItem> get cart => _cart;
  List<Product> get savedForLater => _savedForLater;

  double get subtotal => _cart.fold(0, (sum, item) => sum + item.totalPrice);
  double get deliveryFee => subtotal > 500 ? 0 : 59;
  double get tax => subtotal * 0.05; // 5% tax
  double get total => subtotal + deliveryFee + tax;
  int get itemCount => _cart.fold(0, (sum, item) => sum + item.quantity);

  void addToCart(Product product, {int quantity = 1}) {
    final existingIndex = _cart.indexWhere((item) => item.product.id == product.id);

    if (existingIndex != -1) {
      _cart[existingIndex].quantity += quantity;
    } else {
      _cart.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cart.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int newQuantity) {
    final index = _cart.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (newQuantity <= 0) {
        removeFromCart(productId);
      } else {
        _cart[index].quantity = newQuantity;
        notifyListeners();
      }
    }
  }

  void moveToSavedForLater(String productId) {
    final index = _cart.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      final product = _cart[index].product;
      _cart.removeAt(index);
      _savedForLater.add(product);
      notifyListeners();
    }
  }

  void moveToCart(Product product) {
    _savedForLater.removeWhere((p) => p.id == product.id);
    addToCart(product);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void applyCoupon(String code) {
    // Coupon logic can be implemented here
    notifyListeners();
  }
  void saveForLater(String productId) {
    final index = _cart.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      final product = _cart[index].product;
      _cart.removeAt(index);
      _savedForLater.add(product);
      notifyListeners();
    }
  }

  void moveToCartFromSaved(Product product) {
    _savedForLater.removeWhere((p) => p.id == product.id);
    addToCart(product);
    notifyListeners();
  }

  void removeSavedItem(String productId) {
    _savedForLater.removeWhere((p) => p.id == productId);
    notifyListeners();
  }
}
