import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bali_delights_mobile/reviews/models/reviews.dart';
import 'package:bali_delights_mobile/reviews/widgets/product_reviews_card.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bali_delights_mobile/constants.dart';
import 'create_reviews.dart';

// ReviewScreen widget
class ReviewScreen extends StatefulWidget {
  final int productId;

  ReviewScreen({required this.productId});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late Future<ReviewResponse> futureReviews;
  final CookieRequest _cookieRequest = CookieRequest();
  int? selectedRating;
  bool sortByLikes = false;

  @override
  void initState() {
    super.initState();
    futureReviews = fetchReviews(widget.productId);
  }

  Future<ReviewResponse> fetchReviews(int productId) async {
    await _cookieRequest.init();
    final response = await _cookieRequest.get('${Constants.baseUrl}/reviews/$productId/json');

    return ReviewResponse.fromJson(response);
  }

  void applyFilters() {
    setState(() {
      futureReviews = fetchReviews(widget.productId);
    });
  }

  Future<void> toggleLike(Review review) async {
    final request = context.read<CookieRequest>();

    if (!request.loggedIn) {
      // Redirect to login page if not authenticated
      Navigator.pushNamed(context, '/login');
      return;
    }

    final response = await request.postJson(
      '${Constants.baseUrl}/reviews/toggle-like/${review.id}/',
      jsonEncode({}),
    );

    if (response['liked'] != null && response['like_count'] != null) {
      setState(() {
        review.likedByUser = response['liked'];
        review.totalLikes = response['like_count'];
      });
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to like/unlike review'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Reviews'),
      ),
      body: FutureBuilder<ReviewResponse>(
        future: futureReviews,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final product = snapshot.data!.product;
            final reviews = snapshot.data!.reviews;
            final userReviewExists = snapshot.data!.userReviewExists;
            // print(snapshot.data!.userReviewExists);
            List<Review> filteredReviews = reviews;
            if (selectedRating != null && selectedRating != 0) {
              filteredReviews = reviews.where((review) => review.rating == selectedRating).toList();
            }

            if (sortByLikes) {
              filteredReviews.sort((a, b) => b.totalLikes.compareTo(a.totalLikes));
            } else {
              filteredReviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            }

            return Column(
              children: [
                // Product Image and Name
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Image.network(product.image, height: 100, fit: BoxFit.cover),
                      const SizedBox(height: 10),
                      Text(
                        product.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                // Create Review and View Product Buttons
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!userReviewExists)
                        ElevatedButton(
                          onPressed: () async {
                            final request = context.read<CookieRequest>();
                            if (!request.loggedIn) {
                              // Redirect to login page if not authenticated
                              Navigator.pushNamed(context, '/login');
                              return;
                            }
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateReviewScreen(productId: widget.productId),
                              ),
                            );
                            if (result == true) {
                              setState(() {
                                futureReviews = fetchReviews(widget.productId);
                              });
                            }
                          },
                          child: const Text('Create Review'),
                        ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: routing to product detail screen
                        },
                        child: const  Text('View Product'),
                      ),
                    ],
                  ),
                ),
                // Filter and Sort Options
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Filter by Rating
                      DropdownButton<int>(
                        hint: const Text('Filter by Rating'),
                        value: selectedRating,
                        items: [
                          const  DropdownMenuItem(value: 0, child: Text('Show All')),
                          ...List.generate(5, (index) => index + 1)
                              .map((rating) => DropdownMenuItem(
                                    value: rating,
                                    child: Text('$rating Stars'),
                                  ))
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedRating = value;
                          });
                          applyFilters();
                        },
                      ),
                      const SizedBox(width: 10),
                      // Sort by Likes
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            sortByLikes = !sortByLikes;
                          });
                          applyFilters();
                        },
                        child: Text(sortByLikes ? 'Sort by Most Recent' : 'Sort by Most Likes'),
                      ),
                    ],
                  ),
                ),
                // Reviews List
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredReviews.length,
                    itemBuilder: (context, index) {
                      final review = filteredReviews[index];
                      return ReviewCard(
                        review: review,
                        liked: review.likedByUser,
                        likeCount: review.totalLikes,
                        onLikeToggle: () => toggleLike(review),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          return const  Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}