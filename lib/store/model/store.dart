// To parse this JSON data, do
//
//     final store = storeFromJson(jsonString);

import 'dart:convert';

import 'package:bali_delights_mobile/constants.dart';

List<Store> storeFromJson(String str) => List<Store>.from(json.decode(str).map((x) => Store.fromJson(x)));

String storeToJson(List<Store> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Store {
    String model;
    int pk;
    Fields fields;

    Store({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Store.fromJson(Map<String, dynamic> json) => Store(
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
  String location;
  String description;
  int ownerId;
  DateTime createdAt;
  DateTime updatedAt;
  String? photoUpload;
  String? photo;

  Fields({
    required this.name,
    required this.location,
    required this.description,
    required this.ownerId,
    required this.createdAt,
    required this.updatedAt,
    this.photoUpload,
    this.photo,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
    name: json["name"],
    location: json["location"],
    description: json["description"],
    ownerId: json["owner_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    photoUpload: json["photo_upload"],
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "location": location,
    "description": description,
    "owner_id": ownerId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "photo_upload": photoUpload,
    "photo": photo,
  };

  String getImage() {
    if (photo != null && photo!.isNotEmpty) {
      return photo!;
    } else if (photoUpload != null && photoUpload!.isNotEmpty) {
      return '${Constants.baseUrl}/media/$photoUpload';
    }
    return "https://img.freepik.com/premium-vector/shop-vector-design-white-background_917213-257003.jpg?semt=ais_hybrid";
  }
}