import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bali_delights_mobile/constants.dart';
import 'package:bali_delights_mobile/store/model/store.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class StoreDetailScreen extends StatefulWidget {
  final int storeId;

  const StoreDetailScreen({required this.storeId, Key? key}) : super(key: key);

  @override
  _StoreDetailScreenState createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  bool _loading = true;
  Store? _store;

  @override
  void initState() {
    super.initState();
    fetchStoreDetails();
  }

  Future<void> fetchStoreDetails() async {
    final request = context.read<CookieRequest>();
    try {
      final response =
          await request.get('${Constants.baseUrl}/stores/${widget.storeId}/');
      setState(() {
        _store = Store.fromJson(response);
        _loading = false;
      });
    } catch (e) {
      debugPrint('Error fetching store details: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Details'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _store == null
              ? const Center(child: Text('Store not found'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "hi",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "hi",
                        style: const TextStyle(fontSize: 16),
                      ),
                      // Add more store details here
                    ],
                  ),
                ),
    );
  }
}
