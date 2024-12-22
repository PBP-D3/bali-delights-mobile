import 'package:flutter/material.dart';
import 'package:bali_delights_mobile/reviews/models/reviews.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  final bool liked;
  final int likeCount;
  final Function() onLikeToggle;

  const ReviewCard({super.key, 
    required this.review,
    required this.liked,
    required this.likeCount,
    required this.onLikeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              review.user.username,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              'Rating: ${review.rating} / 5',
              style: TextStyle(color: Colors.yellow[700]),
            ),
            const SizedBox(height: 5),
            Text(
              review.comment,
              // maxLines: 1,
              // overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    liked ? Icons.favorite : Icons.favorite_border,
                    color: liked ? Colors.red : Colors.grey,
                  ),
                  onPressed: onLikeToggle,
                ),
                Text('$likeCount likes'),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              'Reviewed on: ${review.createdAt.toLocal()}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}