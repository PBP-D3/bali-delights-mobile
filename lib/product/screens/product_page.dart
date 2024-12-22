import 'package:bali_delights_mobile/constants.dart';
import 'package:bali_delights_mobile/product/models/product.dart';
import 'package:bali_delights_mobile/reviews/screens/list_reviews_product.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../widgets/filter_bar.dart';
import '../widgets/product_card.dart';
import '../widgets/rating_display.dart';
import '../widgets/product_image.dart';
import 'product_detail.dart';

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
    fetchProducts(request);
  }

  Future<void> fetchProducts(CookieRequest request) async {
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
        return Product.fromJson(item);
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

  void onCategoryChanged(String? category) {
    setState(() {
      selectedCategory = category;
    });
    final request = Provider.of<CookieRequest>(context, listen: false);
    fetchProducts(request);
  }

  void onSortOrderChanged(String order) {
    setState(() {
      sortOrder = order;
    });
    final request = Provider.of<CookieRequest>(context, listen: false);
    fetchProducts(request);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: Column(
        children: [
          FilterBar(
            selectedCategory: selectedCategory,
            sortOrder: sortOrder,
            categories: categories,
            onCategoryChanged: onCategoryChanged,
            onSortOrderChanged: onSortOrderChanged,
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : products.isEmpty
                    ? Center(child: Text('No products available'))
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8.0,
                            crossAxisSpacing: 8.0,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ProductCard(product: product);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}