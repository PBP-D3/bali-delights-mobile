import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bali_delights_mobile/reviews/models/reviews.dart';
import 'package:bali_delights_mobile/constants.dart';
import 'package:bali_delights_mobile/reviews/screens/edit_reviews.dart';
import 'package:bali_delights_mobile/reviews/widgets/user_reviews_card.dart';

class UserReviewScreen extends StatefulWidget {
  @override
  _UserReviewScreenState createState() => _UserReviewScreenState();
}

class _UserReviewScreenState extends State<UserReviewScreen> {
  late Future<List<Review>> futureReviews;
  final CookieRequest _cookieRequest = CookieRequest();

  @override
  void initState() {
    super.initState();
    futureReviews = fetchUserReviews();
  }

  Future<List<Review>> fetchUserReviews() async {
    await _cookieRequest.init();
    print(context.read<CookieRequest>().jsonData);
    print('Fetching user reviews');
    final response = await _cookieRequest.get('${Constants.baseUrl}/reviews/my-review/json');
    print(response);
    if (response is Map && response.containsKey('detail') && response['detail'] == 'Authentication credentials were not provided.') {
      // Handle not authenticated
      print('User is not authenticated');
      return [];
    }

    List jsonResponse = response;
    return jsonResponse.map((review) => Review.fromJson(review)).toList();
  }

  Future<void> deleteReview(int reviewId) async {
    final response = await _cookieRequest.post('${Constants.baseUrl}/reviews/delete-review/$reviewId/', {});
    if (response['success']) {
      setState(() {
        futureReviews = fetchUserReviews();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete review'),
        backgroundColor: Colors.red,
      ));
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
        title: Text('My Reviews'),
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
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

