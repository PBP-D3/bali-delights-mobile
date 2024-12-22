import 'package:flutter/material.dart';
import 'package:bali_delights_mobile/product/models/product.dart';
import 'package:bali_delights_mobile/product/widgets/placeholder_image.dart';

class ProductImage extends StatelessWidget {
  final Product product;

  const ProductImage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.getImage();
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: imageUrl.startsWith('http')
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return PlaceholderImage();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              )
            : PlaceholderImage(),
      ),
    );
  }
}