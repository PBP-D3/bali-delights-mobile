import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../../constants.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  String sortBy = 'created_at';
  String sortDirection = 'desc';

  Future<Map<String, dynamic>> fetchOrderHistory(CookieRequest request) async {
    final response = await request.get(
      '${Constants.baseUrl}/carts/api/history/?sort_by=$sortBy&sort_direction=$sortDirection',
    );
    return response;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                if (value == sortBy) {
                  // Toggle direction if same sort field is selected
                  sortDirection = sortDirection == 'asc' ? 'desc' : 'asc';
                } else {
                  // New sort field, default to descending
                  sortBy = value;
                  sortDirection = 'desc';
                }
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'created_at',
                child: Row(
                  children: [
                    const Icon(Icons.access_time),
                    const SizedBox(width: 8),
                    Text(
                      'Sort by Date ${sortBy == 'created_at' ? (sortDirection == 'asc' ? '↑' : '↓') : ''}',
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'total_price',
                child: Row(
                  children: [
                    const Icon(Icons.attach_money),
                    const SizedBox(width: 8),
                    Text(
                      'Sort by Price ${sortBy == 'total_price' ? (sortDirection == 'asc' ? '↑' : '↓') : ''}',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchOrderHistory(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final orders = snapshot.data?['orders'] as List<dynamic>? ?? [];

          if (orders.isEmpty) {
            return const Center(child: Text('No orders found'));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final createdAt = DateTime.parse(order['created_at']);
              final formattedDate =
                  DateFormat('MMM d, y HH:mm').format(createdAt);

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(formattedDate),
                  subtitle: Text('\$${order['total_price']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.receipt_long),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/order-receipt',
                        arguments: order['id'],
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
