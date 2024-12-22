import 'package:flutter/material.dart';
import 'package:bali_delights_mobile/reviews/screens/list_reviews_product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;
  final bool isAuthenticated;

  ProductDetailPage({required this.product, required this.isAuthenticated});

  void addToCart(BuildContext context, int productId, int stock) async {
    if (stock == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("This item is out of stock.")),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('https://your-api-url.com/carts/add_to_cart/'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'product_id': productId.toString()},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success']) {
      Navigator.pushNamed(context, '/cart');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${data['message']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (product['get_image'] != null)
                Center(
                  child: Image.network(
                    product['get_image'],
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 16),
              Text(
                product['name'],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Price: \$${product['price']}'),
              SizedBox(height: 8),
              Text('Stock: ${product['stock']}'),
              SizedBox(height: 8),
              Text('Category: ${product['category']}'),
              SizedBox(height: 8),
              Text('Description: ${product['description']}'),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewScreen(
                            productId: product['id'], // Pass the product ID here
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: Text('Check Reviews'),
                  ),
                  if (isAuthenticated)
                    ElevatedButton(
                      onPressed: () => addToCart(
                        context,
                        product['id'],
                        product['stock'],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: Text('Add to Cart'),
                    ),
                ],
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text('Back'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
