class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String category;
  final String photoUrl;
  final double? averageRating;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.photoUrl,
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
      photoUrl: json['photo_url'],
      averageRating: json['average_rating'] != null
          ? double.parse(json['average_rating'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'category': category,
      'photo_url': photoUrl,
      'average_rating': averageRating,
    };
  }

  String getImage() {
    if (photoUrl.isNotEmpty) {
      return photoUrl;
    }
    return "https://img.freepik.com/premium-vector/shop-vector-design-white-background_917213-257003.jpg?semt=ais_hybrid";
  }
}