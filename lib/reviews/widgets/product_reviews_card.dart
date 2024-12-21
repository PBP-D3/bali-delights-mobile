import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:bali_delights_mobile/reviews/models/reviews.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:bali_delights_mobile/constants.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  final bool liked;
  final int likeCount;
  final Function() onLikeToggle;

  ReviewCard({
    required this.review,
    required this.liked,
    required this.likeCount,
    required this.onLikeToggle,
  });

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
            Text(
              review.comment,
              // maxLines: 1,
              // overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
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
            SizedBox(height: 5),
            Text(
              'Reviewed on: ${review.createdAt.toLocal()}',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}