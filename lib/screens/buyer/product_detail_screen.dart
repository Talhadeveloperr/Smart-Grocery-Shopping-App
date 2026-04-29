// ===================== screens/buyer/product_detail_screen.dart =====================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  ProductDetailScreen(this.product);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final cart = Provider.of<CartProvider>(context);

    final comparisons = provider.getProductsByName(product.name);

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Column(
        children: [
          Text('Price Comparison', style: TextStyle(fontSize: 20)),
          Expanded(
            child: ListView.builder(
              itemCount: comparisons.length,
              itemBuilder: (ctx, i) {
                final item = comparisons[i];
                return ListTile(
                  title: Text(item.storeId),
                  subtitle: Text('Rs. ${item.price}'),
                  trailing: IconButton(
                    icon: Icon(Icons.add_shopping_cart),
                    onPressed: () {
                      cart.addToCart(item);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
