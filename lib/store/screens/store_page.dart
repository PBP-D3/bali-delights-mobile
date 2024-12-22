import 'package:flutter/material.dart';
import 'package:bali_delights_mobile/store/screens/store_form.dart';
import 'package:bali_delights_mobile/store/widgets/list_stores.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Store Page"),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Colors.purple,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(icon: Icon(Icons.home_rounded), text: "All Stores"),
              Tab(icon: Icon(Icons.store), text: "My Stores"),
              Tab(icon: Icon(Icons.add), text: "Add Store"),
            ],
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
        body: Column(
          children: [
            if (_selectedIndex == 0 || _selectedIndex == 1)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search stores...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
            Expanded(
              child: TabBarView(
                children: [
                  AllStores(isMyStores: false, searchQuery: _searchQuery),
                  AllStores(isMyStores: true, searchQuery: _searchQuery),
                  const StoreFormPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


const _tabs = [
  Tab(icon: Icon(Icons.home_rounded), text: "All Stores"),
  Tab(icon: Icon(Icons.store), text: "My Stores"),
  Tab(icon: Icon(Icons.add), text: "Add Store"),
];

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._content);

  final Widget _content;

  @override
  double get minExtent => 56.0; // Fixed height for the header
  @override
  double get maxExtent => 56.0; // Fixed height for the header

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _content;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}