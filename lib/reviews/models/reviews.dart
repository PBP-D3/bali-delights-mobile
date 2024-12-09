// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

List<Review> reviewFromJson(String str) => List<Review>.from(json.decode(str).map((x) => Review.fromJson(x)));

String reviewToJson(List<Review> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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

    Product({
        required this.id,
        required this.name,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
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
