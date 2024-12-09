import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bali_delights_mobile/reviews/models/reviews.dart';
import 'package:bali_delights_mobile/constants.dart';

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
                return ReviewCard(review: snapshot.data![index]);
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

// ReviewCard widget
class ReviewCard extends StatelessWidget {
  final Review review;

  ReviewCard({required this.review});

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
          ],
        ),
      ),
    );
  }
}