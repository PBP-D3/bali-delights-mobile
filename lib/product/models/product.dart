// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
    String model;
    int pk;
    Fields fields;

    Product({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String name;
    double price;
    String photoUrl;
    String description;
    String category;
    int stock;
    int storeId;
    String createdAt;
    String updatedAt;

    Fields({
        required this.name,
        required this.price,
        required this.photoUrl,
        required this.description,
        required this.category,
        required this.stock,
        required this.storeId,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        name: json["name"],
        price: json["price"]?.toDouble(),
        photoUrl: json["photo_url"],
        description: json["description"],
        category: json["category"],
        stock: json["stock"],
        storeId: json["store_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "photo_url": photoUrl,
        "description": description,
        "category": category,
        "stock": stock,
        "store_id": storeId,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
