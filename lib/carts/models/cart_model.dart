class CartItem {
  final int id;
  final String productName;
  final int quantity;
  final double price;
  final double subtotal;

  CartItem(
      {required this.id,
      required this.productName,
      required this.quantity,
      required this.price,
      required this.subtotal});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productName: json['product_name'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      subtotal: json['subtotal'].toDouble(),
    );
  }
}

class Cart {
  final int id;
  final double totalPrice;
  final List<CartItem> items;
  final String user;

  Cart(
      {required this.id,
      required this.totalPrice,
      required this.items,
      required this.user});

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
        id: json['id'],
        totalPrice: json['total_price'].toDouble(),
        items: (json['items'] as List)
            .map((item) => CartItem.fromJson(item))
            .toList(),
        user: json['user']);
  }
}
