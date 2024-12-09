import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bali_delights_mobile/store/widgets/list_stores.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Store Page"),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  Container(
                    color: Colors.white, // Change this color as needed
                    child: const TabBar(
                      indicatorSize: TabBarIndicatorSize.label,
                      labelColor: Colors.purple,
                      unselectedLabelColor: Colors.grey,
                      tabs: _tabs,
                    ),
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: const TabBarView(
            children: [
              // Tab 1: All Stores
              AllStores(isMyStores: false),

              // Tab 2: My Stores
              AllStores(isMyStores: true),

              // Tab 3: Add Store
              AllStores(isMyStores: true),
            ],
          ),
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
