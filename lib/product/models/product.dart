import 'dart:convert';

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String category;
  final int storeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? photoUrl;
  final String? photoUpload;
  final double? averageRating;  // New field

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.storeId,
    required this.createdAt,
    required this.updatedAt,
    this.photoUrl,
    this.photoUpload,
    this.averageRating,  
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      stock: json['stock'],
      category: json['category'],
      storeId: json['store_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      photoUrl: json['photo_url'],
      photoUpload: json['photo_upload'],
      averageRating: json['average_rating'] != null 
          ? double.parse(json['average_rating'].toString()) 
          : null,  
    );
  }

  String getImage() {
    if (photoUrl != null) {
      return photoUrl!;
    } else if (photoUpload != null) {
      return photoUpload!;
    }
    return "https://img.freepik.com/premium-vector/shop-vector-design-white-background_917213-257003.jpg?semt=ais_hybrid";
  }
}