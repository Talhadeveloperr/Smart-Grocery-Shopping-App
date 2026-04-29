import 'package:flutter/material.dart';
import 'product_list_screen.dart';
import 'cart_screen.dart';
import '../seller/add_product_screen.dart'; // 👈 IMPORTANT

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Grocery'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // 👇 BUYER FLOW
            ElevatedButton(
              child: Text('Browse Products'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductListScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              child: Text('View Cart'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CartScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            Divider(),

            const SizedBox(height: 20),

            // 👇 SELLER FLOW (THIS IS WHAT YOU WANT)
            ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Add New Product (Seller)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddProductScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}