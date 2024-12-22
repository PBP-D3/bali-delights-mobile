import 'package:flutter/material.dart';

class RatingDisplay extends StatelessWidget {
  final double? rating;

  const RatingDisplay({
    Key? key,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (rating == null) {
      return Text(
        'No ratings yet',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      );
    }

    return Row(
      children: [
        Icon(
          Icons.star,
          size: 16,
          color: Colors.amber,
        ),
        SizedBox(width: 4),
        Text(
          rating!.toStringAsFixed(1),
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}