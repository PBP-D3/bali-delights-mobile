import 'package:bali_delights_mobile/constants.dart';
import 'package:bali_delights_mobile/product/models/product.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../widgets/filter_bar.dart';
import '../widgets/product_card.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Product> products = [];
  bool isLoading = true;
  String? error;
  String? selectedCategory;
  String sortOrder = 'asc';
  
  final List<Map<String, String>> categories = [
    {'value': 'Clothes', 'display': 'Clothes'},
    {'value': 'Jewelries', 'display': 'Jewelries'},
    {'value': 'Crafts', 'display': 'Crafts'},
    {'value': 'Arts', 'display': 'Arts'},
    {'value': 'Snacks', 'display': 'Snacks'},
    {'value': 'Drinks', 'display': 'Drinks'},
  ];

  @override
  void initState() {
    super.initState();
    final request = Provider.of<CookieRequest>(context, listen: false);
    _loadProducts(request);
  }

  Future<void> _loadProducts(CookieRequest request) async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      String url = '${Constants.baseUrl}/products/api/products/?sort=$sortOrder';
      if (selectedCategory != null) {
        url += '&category=$selectedCategory';
      }

      final response = await request.get(url);

      if (response == null) {
        throw Exception('No response from server');
      }

      if (response is! Map || !response.containsKey('products')) {
        throw Exception('Invalid response format: missing products key');
      }

      final productsList = (response['products'] as List).map((item) {
        final Map<String, dynamic> modifiedItem = {
          'id': item['id'],
          'name': item['name'],
          'description': item['description'],
          'price': item['price'],
          'stock': item['stock'],
          'category': item['category'],
          'store_id': 1,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
          'photo_url': item['image_url'],
          'photo_upload': null,
          'average_rating': item['average_rating'],
        };

        return Product.fromJson(modifiedItem);
      }).toList();

      setState(() {
        products = productsList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          if (error != null || products.isEmpty)
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                final request = Provider.of<CookieRequest>(context, listen: false);
                _loadProducts(request);
              },
            ),
        ],
      ),
      body: Column(
        children: [
          FilterBar(
            selectedCategory: selectedCategory,
            sortOrder: sortOrder,
            categories: categories,
            onCategoryChanged: (value) {
              setState(() {
                selectedCategory = value;
              });
              final request = Provider.of<CookieRequest>(context, listen: false);
              _loadProducts(request);
            },
            onSortOrderChanged: (value) {
              setState(() {
                sortOrder = value;
              });
              final request = Provider.of<CookieRequest>(context, listen: false);
              _loadProducts(request);
            },
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : error != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Error loading products',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(error!, style: TextStyle(color: Colors.red)),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  final request = Provider.of<CookieRequest>(context, listen: false);
                                  _loadProducts(request);
                                },
                                child: Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : products.isEmpty
                        ? Center(child: Text('No products available'))
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 8.0,
                                crossAxisSpacing: 8.0,
                                childAspectRatio: 0.65,
                              ),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                return ProductCard(product: products[index]);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}