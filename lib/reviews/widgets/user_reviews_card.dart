import 'package:flutter/material.dart';
import 'package:bali_delights_mobile/reviews/models/reviews.dart';
import 'package:bali_delights_mobile/reviews/screens/list_reviews_product.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  final Function(int) onDelete;
  final Function() onEdit;

  ReviewCard({required this.review, required this.onDelete, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewScreen(productId: review.product.id),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage(review.product.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            // Product Name
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewScreen(productId: review.product.id),
                  ),
                );
              },
              child: Text(
                review.product.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Rating: ${review.rating} / 5',
              style: TextStyle(color: Colors.yellow[700]),
            ),
            SizedBox(height: 5),
            Text(review.comment),
            SizedBox(height: 5),
            Text(
              'Likes: ${review.totalLikes}',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 5),
            Text(
              'Reviewed on: ${review.createdAt.toLocal()}',
              style: TextStyle(color: Colors.grey),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    onDelete(review.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}