import 'package:flutter/material.dart';
import 'package:bali_delights_mobile/reviews/models/reviews.dart';


// ReviewCard widget
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
            Text(
              review.user.username,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 5),
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