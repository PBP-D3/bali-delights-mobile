// order.dart

class OrderItem {
  final int id;
  final String productName;
  final int quantity;
  final double subtotal;

  OrderItem({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.subtotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      productName: json['product_name'],
      quantity: json['quantity'],
      subtotal: json['subtotal'].toDouble(),
    );
  }
}

class Order {
  final int id;
  final String userId;
  final List<OrderItem> items;
  final double totalPrice;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalPrice,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      totalPrice: json['total_price'].toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId, 
      'items': items.map((item) => {
        'id': item.id,
        'product_name': item.productName,
        'quantity': item.quantity,
        'subtotal': item.subtotal,
      }).toList(),
      'total_price': totalPrice,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
