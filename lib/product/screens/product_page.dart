import 'package:bali_delights_mobile/constants.dart';
import 'package:bali_delights_mobile/product/models/product.dart';
import 'package:bali_delights_mobile/reviews/screens/list_reviews_product.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get('${Constants.baseUrl}/api/products/');

      if (response['status'] == 'success') {
        setState(() {
          products = productFromJson(response['data']);
          isLoading = false;
        });
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching products: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? Center(child: Text('No products available'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Card(
                        child: Column(
                          children: [
                            Text(
                              product.fields.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (product.fields.photoUrl.isNotEmpty)
                              Image.network(
                                product.fields.photoUrl,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            else
                              Container(
                                height: 100,
                                color: Colors.grey[200],
                                child: Center(child: Text('No image available')),
                              ),
                            Text('Price: \$${product.fields.price}'),
                            Text('Stock: ${product.fields.stock}'),
                            Text('Category: ${product.fields.category}'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Add product to cart
                                  },
                                  child: Text('Add to Cart'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Navigate to reviews
                                  },
                                  child: Text('Reviews'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
