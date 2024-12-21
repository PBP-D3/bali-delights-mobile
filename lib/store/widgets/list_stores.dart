import 'package:bali_delights_mobile/constants.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bali_delights_mobile/store/model/store.dart';
import 'package:bali_delights_mobile/store/screens/store_detail.dart';

class AllStores extends StatefulWidget {
  final bool isMyStores;
  final String searchQuery;

  const AllStores({super.key, required this.isMyStores, required this.searchQuery});

  @override
  State<AllStores> createState() => _AllStoresState();
}

class _AllStoresState extends State<AllStores> {
  Future<List<Store>> fetchStores(CookieRequest request) async {
    final String endpoint = widget.isMyStores
        ? '${Constants.baseUrl}/stores/owner_json/'
        : '${Constants.baseUrl}/stores/json/';

    final response = await request.get(endpoint);
    var data = response;

    List<Store> listStores = [];
    for (var d in data) {
      if (d != null) {
        listStores.add(Store.fromJson(d));
      }
    }

    if (widget.searchQuery.isNotEmpty) {
      listStores = listStores.where((store) {
        return store.fields.name.toLowerCase().contains(widget.searchQuery.toLowerCase());
      }).toList();
    }

    return listStores;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      body: FutureBuilder(
        future: fetchStores(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    'No data available.',
                    style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              // Determine the number of columns based on screen width
              double screenWidth = MediaQuery.of(context).size.width;
              int crossAxisCount = screenWidth < 600 ? 1 : 2;

              return GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoreDetailPage(
                          store: snapshot.data![index],
                          isMyStores: widget.isMyStores,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  splashColor: Colors.blueAccent.withOpacity(0.2),
                  highlightColor: Colors.blueAccent.withOpacity(0.1),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            snapshot.data![index].fields.getImage(),
                            width: double.infinity,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${snapshot.data![index].fields.name}",
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text("${snapshot.data![index].fields.description}"),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}