import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';

class OrderReceiptScreen extends StatelessWidget {
  final int orderId;

  const OrderReceiptScreen({super.key, required this.orderId});

  Future<Map<String, dynamic>> fetchReceipt(CookieRequest request) async {
    final response = await request.get(
      '${Constants.baseUrl}/carts/api/receipt/$orderId/',
    );
    return response;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Receipt'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchReceipt(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final order = snapshot.data?['order'];
          if (order == null) {
            return const Center(child: Text('Receipt not found'));
          }

          final createdAt = DateTime.parse(order['created_at']);
          final formattedDate = DateFormat('MMM d, y HH:mm').format(createdAt);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date: $formattedDate',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Divider(),
                ...order['items']
                    .map<Widget>((item) => Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                item['image'] ??
                                    'https://via.placeholder.com/50',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.image_not_supported,
                                      size: 50);
                                },
                              ),
                            ),
                            title: Text(item['product']),
                            subtitle: Text('Quantity: ${item['quantity']}'),
                            trailing: Text('\$${item['subtotal']}'),
                          ),
                        ))
                    .toList(),
                const Divider(thickness: 2),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Total: \$${order['total_price']}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
