import 'package:bali_delights_mobile/constants.dart';
import 'package:flutter/material.dart';
import 'package:bali_delights_mobile/store/model/store.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bali_delights_mobile/store/screens/edit_store.dart';
import 'package:bali_delights_mobile/store/screens/store_page.dart';
import 'package:bali_delights_mobile/product/screens/add_product.dart';
import 'package:bali_delights_mobile/chats/screens/chat_detail_screen.dart';

class StoreDetailPage extends StatelessWidget {
  final Store store;
  final bool isMyStores;

  const StoreDetailPage(
      {super.key, required this.store, required this.isMyStores});

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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StorePage()),
      );
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete the store')),
      );
    }
  }

  Widget _buildImage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: 200,
        height: 200,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            store.fields.getImage(),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStoreDetails(BuildContext context, CookieRequest request) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            store.fields.name,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  store.fields.location,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            store.fields.description,
            style: const TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 24),
          if (isMyStores) ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => editStore(context, request),
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => deleteStore(context, request),
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddProductScreen(storeId: store.pk)),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Add Product'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            )
          ] else ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatDetailScreen(
                        storeId: store.pk,
                        storeName: store.fields.name,
                        storeImage: store.fields.getImage(),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.chat),
                label: const Text('Chat with Store'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Store Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const StorePage()),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            bool isWideScreen = constraints.maxWidth > 800;

            return Card(
              elevation: 3,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: isWideScreen
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildImage(),
                        Expanded(child: _buildStoreDetails(context, request)),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(child: _buildImage()),
                        _buildStoreDetails(context, request),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}
