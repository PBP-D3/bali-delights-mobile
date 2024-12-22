import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:bali_delights_mobile/reviews/models/reviews.dart';
import 'package:bali_delights_mobile/constants.dart';
import 'package:bali_delights_mobile/reviews/screens/edit_reviews.dart';
import 'package:bali_delights_mobile/reviews/widgets/user_reviews_card.dart';

class UserReviewScreen extends StatefulWidget {
  const UserReviewScreen({super.key});

  @override
  UserReviewScreenState createState() => UserReviewScreenState();
}

class UserReviewScreenState extends State<UserReviewScreen> {
  late Future<List<Review>> futureReviews;
  final CookieRequest _cookieRequest = CookieRequest();

  @override
  void initState() {
    super.initState();
    futureReviews = fetchUserReviews();
  }

  Future<List<Review>> fetchUserReviews() async {
    await _cookieRequest.init();
    final response = await _cookieRequest.get('${Constants.baseUrl}/reviews/my-review/json');
    if (response is Map && response.containsKey('detail') && response['detail'] == 'Authentication credentials were not provided.') {
      // Handle not authenticated
      return [];
    }

    List jsonResponse = response;
    return jsonResponse.map((review) => Review.fromJson(review)).toList();
  }

  Future<void> deleteReview(int reviewId) async {
    final response = await _cookieRequest.post('${Constants.baseUrl}/reviews/delete-review/$reviewId/', {});
    if (mounted) {
      if (response['success']) {
        setState(() {
          futureReviews = fetchUserReviews();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to delete review'),
          backgroundColor: Colors.red,
        ));
      }
    }
    
  }

  Future<void> refreshReviews() async {
    setState(() {
      futureReviews = fetchUserReviews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reviews'),
      ),
      body: FutureBuilder<List<Review>>(
        future: futureReviews,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ReviewCard(
                  review: snapshot.data![index],
                  onDelete: deleteReview,
                  onEdit: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditReviewScreen(review: snapshot.data![index]),
                      ),
                    );
                    if (result == true) {
                      refreshReviews();
                    }
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

