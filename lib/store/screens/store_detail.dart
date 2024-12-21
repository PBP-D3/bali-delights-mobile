import 'package:bali_delights_mobile/constants.dart';
import 'package:flutter/material.dart';
import 'package:bali_delights_mobile/store/model/store.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bali_delights_mobile/store/screens/edit_store.dart';
import 'package:bali_delights_mobile/store/screens/store_page.dart';

class StoreDetailPage extends StatelessWidget {
  final Store store;
  final bool isMyStores;

  const StoreDetailPage({super.key, required this.store, required this.isMyStores});

  Future<void> editStore(BuildContext context, CookieRequest request) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EditStorePage(store: store),
      ),
    );
  }

  Future<void> deleteStore(BuildContext context, CookieRequest request) async {
    final response = await request.get(
      '${Constants.baseUrl}/stores/delete-flutter/${store.pk}/',
    );

    if (response['status'] == 'success' && context.mounted) {
      // Successfully deleted the store
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const StorePage(),
        ),
      );
    } else if (context.mounted) {
      // Failed to delete the store
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete the store')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: Text(store.fields.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name: ${store.fields.name}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Description: ${store.fields.description}"),
            const Spacer(),
            if (isMyStores) ...[
              ElevatedButton(
                onPressed: () => editStore(context, request),
                child: const Text('Edit Store'),
              ),
              ElevatedButton(
                onPressed: () => deleteStore(context, request),
                child: const Text('Delete Store'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add your add product logic here
                },
                child: const Text('Add Product'),
              ),
            ] else ...[
              ElevatedButton(
                onPressed: () {
                  // Add your chat store logic here
                },
                child: const Text('Chat with Store'),
              ),
            ],
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StorePage(),
                  ),
                );
              },
              child: const Text('Back to Store Page'),
            ),
          ],
        ),
      ),
    );
  }
}