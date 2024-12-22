import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:bali_delights_mobile/constants.dart';
import 'dart:convert';

class CreateReviewScreen extends StatefulWidget {
  final int productId;

  const CreateReviewScreen({super.key, required this.productId});

  @override
  CreateReviewScreenState createState() => CreateReviewScreenState();
}

class CreateReviewScreenState extends State<CreateReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  final _ratingController = TextEditingController();

  Future<void> _submitReview() async {
    final request = context.read<CookieRequest>();

    if (!request.loggedIn) {
      // Redirect to login page if not authenticated
      Navigator.pushNamed(context, '/login');
      return;
    }

    final response = await request.postJson(
      '${Constants.baseUrl}/reviews/create-review-json/${widget.productId}/',
      jsonEncode({
        'comment': _commentController.text,
        'rating': int.parse(_ratingController.text),
      }),
    );

    if (mounted) {
      if (response['success']) {
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to create review'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
                maxLines: 5, // Set maxLines to a higher value for a larger text box
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a comment';
                  }
                  return null;
                },
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a rating';
                  }
                  final rating = int.tryParse(value);
                  if (rating == null || rating < 1 || rating > 5) {
                    return 'Please enter a rating between 1 and 5';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _submitReview();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}