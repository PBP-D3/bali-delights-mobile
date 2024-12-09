import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bali_delights_mobile/store/model/store.dart';
import 'package:bali_delights_mobile/store/screens/store_detail.dart';

class AllStores extends StatefulWidget {
  final bool isMyStores; // Add the indicator argument

  const AllStores({Key? key, required this.isMyStores}) : super(key: key);

  @override
  State<AllStores> createState() => _AllStoresState();
}

class _AllStoresState extends State<AllStores> {
  Future<List<Store>> fetchStores(CookieRequest request) async {
    // Fetch different endpoints based on the isMyStores flag
    final String endpoint = widget.isMyStores
        ? 'http://localhost:8000/stores/owner_json/'
        : 'http://localhost:8000/stores/json/';

    final response = await request.get(endpoint);
    var data = response;

    List<Store> listStores = [];
    for (var d in data) {
      if (d != null) {
        listStores.add(Store.fromJson(d));
      }
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
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoreDetailPage(
                            store: snapshot.data![index],
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
                ),
              );
            }
          }
        },
      ),
    );
  }
}
