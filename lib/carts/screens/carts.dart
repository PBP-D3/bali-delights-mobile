import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:bali_delights_mobile/constants.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _passwordController = TextEditingController();

  Future<Map<String, dynamic>> fetchCart(CookieRequest request) async {
    final response = await request.get('${Constants.baseUrl}/carts/api/cart/');
    return response;
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Processing order..."),
            ],
          ),
        );
      },
    );
  }

  void _showResultDialog(bool success, String message,
      {String? remainingBalance}) {
    Navigator.of(context).pop(); // Dismiss loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(success ? 'Success!' : 'Error'),
          content: Text(message),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss result dialog
                if (success) {
                  Navigator.pushReplacementNamed(context, '/');
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _processCheckout(
      BuildContext context, CookieRequest request) async {
    _showLoadingDialog();

    try {
      final response = await request.post(
        '${Constants.baseUrl}/carts/api/submit-order/',
        {'password': _passwordController.text},
      );

      if (response['success'] == true) {
        _showResultDialog(
          true,
          'Order placed successfully!\nRemaining balance: \$${response['remaining_balance']}',
          remainingBalance: response['remaining_balance'],
        );
      } else {
        _showResultDialog(
          false,
          response['message'] ?? 'Failed to place order',
        );
      }
    } catch (e) {
      _showResultDialog(false, 'Error: ${e.toString()}');
    } finally {
      _passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchCart(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final cart = snapshot.data?['cart'];
          if (cart == null || cart['items'].isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart['items'].length,
                  itemBuilder: (context, index) {
                    final item = cart['items'][index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            item['image'] ??
                                "https://img.freepik.com/premium-vector/shop-vector-design-white-background_917213-257003.jpg?semt=ais_hybrid",
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported,
                                  size: 50);
                            },
                          ),
                        ),
                        title: Text(item['product_name']),
                        subtitle: Text('Price: \$${item['price']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () async {
                                await request.post(
                                  '${Constants.baseUrl}/carts/api/update-item/',
                                  {
                                    'item_id': item['id'].toString(),
                                    'quantity':
                                        (item['quantity'] - 1).toString(),
                                  },
                                );
                                setState(() {});
                              },
                            ),
                            Text('${item['quantity']}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () async {
                                await request.post(
                                  '${Constants.baseUrl}/carts/api/update-item/',
                                  {
                                    'item_id': item['id'].toString(),
                                    'quantity':
                                        (item['quantity'] + 1).toString(),
                                  },
                                );
                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                await request.post(
                                  '${Constants.baseUrl}/carts/api/remove-item/',
                                  {'item_id': item['id'].toString()},
                                );
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Total: \$${cart['total_price']}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Confirm Order'),
                            content: TextField(
                              controller: _passwordController,
                              decoration: const InputDecoration(
                                labelText: 'Enter your password',
                              ),
                              obscureText: true,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              FilledButton(
                                onPressed: () {
                                  Navigator.pop(
                                      context); // Close password dialog
                                  _processCheckout(context, request);
                                },
                                child: const Text('Confirm'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text('Checkout'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
