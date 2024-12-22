import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:bali_delights_mobile/reviews/models/reviews.dart';
import 'package:bali_delights_mobile/constants.dart';

class EditReviewScreen extends StatefulWidget {
  final Review review;

  EditReviewScreen({required this.review});

  @override
  _EditReviewScreenState createState() => _EditReviewScreenState();
}

class _EditReviewScreenState extends State<EditReviewScreen> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final CookieRequest _cookieRequest = CookieRequest();

  @override
  void initState() {
    super.initState();
    _commentController.text = widget.review.comment;
    _ratingController.text = widget.review.rating.toString();
  }

  Future<void> editReview() async {
    final response = await _cookieRequest.postJson(
      '${Constants.baseUrl}/reviews/edit-review/${widget.review.id}/',
      jsonEncode({
        'comment': _commentController.text,
        'rating': int.parse(_ratingController.text),
      }),
    );
    if (response['success']) {
      Navigator.pop(context, true); // Return true to indicate success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Failed to edit review'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: 'Comment',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
              ),
              maxLines: 5, // Set the maxLines to make the input form bigger
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _ratingController,
              decoration: InputDecoration(
                labelText: 'Rating',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: editReview,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}