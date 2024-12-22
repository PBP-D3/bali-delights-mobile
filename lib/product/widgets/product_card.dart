import 'package:flutter/material.dart';
import 'package:bali_delights_mobile/product/models/product.dart';
import 'package:bali_delights_mobile/product/screens/edit_product.dart';
import 'package:bali_delights_mobile/product/screens/product_detail.dart';
import 'package:bali_delights_mobile/reviews/screens/list_reviews_product.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'product_image.dart';
import 'rating_display.dart';
import 'package:http/http.dart' as http;
import 'package:bali_delights_mobile/constants.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isEditable;

  const ProductCard({
    Key? key,
    required this.product,
    this.isEditable = false,
  }) : super(key: key);

  Future<void> deleteProduct(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Product'),
        content: Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final response = await http.delete(
        Uri.parse('${Constants.baseUrl}/products/api/products/${product.id}/delete/'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product deleted successfully!')),
        );
        Navigator.pop(context, true);
      } else {
        throw Exception('Failed to delete product');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> addToCart(BuildContext context, CookieRequest request) async {
    try {
      final response = await request.post(
        '${Constants.baseUrl}/carts/api/add-to-cart/',
        {'product_id': product.id.toString()},
      );

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added to cart successfully!')),
        );
      } else {
        throw Exception(response['message'] ?? 'Failed to add product to cart');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(
                product: product.toJson(),
                isAuthenticated: false, // Ignoring isAuthenticated for now
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: ProductImage(product: product),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Price: \$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Stock: ${product.stock}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Category: ${product.category}',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  RatingDisplay(rating: product.averageRating),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (isEditable) ...[
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProductScreen(product: product),
                            ),
                          );
                        },
                        child: Text('Edit'),
                      ),
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () => deleteProduct(context),
                        child: Text('Delete'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ] else ...[
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () => addToCart(context, request),
                        child: Text('Add to Cart'),
                      ),
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewScreen(productId: product.id),
                            ),
                          );
                        },
                        child: Text('Reviews'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}