import 'package:flutter/material.dart';
import 'package:bali_delights_mobile/reviews/models/reviews.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

// ReviewScreen widget
class ReviewScreen extends StatefulWidget {
  final int productId;

  ReviewScreen({required this.productId});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late Future<List<Review>> futureReviews;
  final CookieRequest _cookieRequest = CookieRequest();

  @override
  void initState() {
    super.initState();
    futureReviews = fetchReviews(widget.productId);
  }

  Future<List<Review>> fetchReviews(int productId) async {
    await _cookieRequest.init();
    final response = await _cookieRequest.get('http://localhost:8000/reviews/$productId/json');

    List jsonResponse = response;
    return jsonResponse.map((review) => Review.fromJson(review)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Reviews'),
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