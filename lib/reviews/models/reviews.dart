import 'dart:convert';

List<ReviewResponse> reviewResponseFromJson(String str) => List<ReviewResponse>.from(json.decode(str).map((x) => ReviewResponse.fromJson(x)));

String reviewResponseToJson(List<ReviewResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReviewResponse {
  Product product;
  List<Review> reviews;
  bool userReviewExists;

  ReviewResponse({
    required this.product,
    required this.reviews,
    required this.userReviewExists,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) => ReviewResponse(
    product: Product.fromJson(json["product"]),
    reviews: List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
    userReviewExists: json["user_review_exists"],
  );

  Map<String, dynamic> toJson() => {
    "product": product.toJson(),
    "reviews": List<dynamic>.from(reviews.map((x) => x.toJson())),
    "user_review_exists": userReviewExists,
  };
}

class TopReviewsResponse {
  List<Review> reviews;

  TopReviewsResponse({
    required this.reviews,
  });

  factory TopReviewsResponse.fromJson(Map<String, dynamic> json) => TopReviewsResponse(
    reviews: List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "reviews": List<dynamic>.from(reviews.map((x) => x.toJson())),
  };
}

class Review {
  int id;
  String comment;
  int rating;
  User user;
  Product product;
  DateTime createdAt;
  DateTime updatedAt;
  int totalLikes;
  bool likedByUser;

  Review({
    required this.id,
    required this.comment,
    required this.rating,
    required this.user,
    required this.product,
    required this.createdAt,
    required this.updatedAt,
    required this.totalLikes,
    required this.likedByUser,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json["id"],
    comment: json["comment"],
    rating: json["rating"],
    user: User.fromJson(json["user"]),
    product: Product.fromJson(json["product"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    totalLikes: json["total_likes"],
    likedByUser: json["liked_by_user"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "comment": comment,
    "rating": rating,
    "user": user.toJson(),
    "product": product.toJson(),
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "total_likes": totalLikes,
    "liked_by_user": likedByUser,
  };
}

class Product {
  int id;
  String name;
  String image;

  Product({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
  };
}

class User {
  int id;
  String username;

  User({
    required this.id,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
  };
}