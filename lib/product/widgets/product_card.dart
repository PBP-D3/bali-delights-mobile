import 'package:flutter/material.dart';
import 'package:bali_delights_mobile/product/models/product.dart';
import 'package:bali_delights_mobile/product/screens/product_detail.dart';
import 'package:bali_delights_mobile/reviews/screens/list_reviews_product.dart';
import 'product_image.dart';
import 'rating_display.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                product: {
                  'id': product.id,
                  'name': product.name,
                  'description': product.description,
                  'price': product.price,
                  'stock': product.stock,
                  'category': product.category,
                  'get_image': product.getImage(),
                },
                isAuthenticated: true,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
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
                  Text('Price: \$${product.price.toStringAsFixed(2)}'),
                  Text('Stock: ${product.stock}'),
                  Text('Category: ${product.category}'),
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
                  ElevatedButton(
                    onPressed: () {
                      // Add product to cart logic
                    },
                    child: Text('Add to Cart'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ReviewScreen(productId: product.id),
                        ),
                      );
                    },
                    child: Text('Reviews'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}