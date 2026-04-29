// ===================== screens/buyer/cart_screen.dart =====================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context).cart;

    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: ListView.builder(
        itemCount: cart.length,
        itemBuilder: (ctx, i) {
          final item = cart[i];
          return ListTile(
            title: Text(item.name),
            subtitle: Text('Rs. ${item.price}'),
          );
        },
      ),
    );
  }
}
