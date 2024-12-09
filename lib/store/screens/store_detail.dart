import 'package:flutter/material.dart';
import 'package:bali_delights_mobile/store/model/store.dart';

class StoreDetailPage extends StatelessWidget {
  final Store store; 

  const StoreDetailPage({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
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
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              child: const Text('Back to Store Page'),
            ),
          ],
        ),
      ),
    );
  }
}
