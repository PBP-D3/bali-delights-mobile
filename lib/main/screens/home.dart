import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../widgets/navbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bali Delights'),
      ),
      drawer: const NavBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ...existing sections...
            if (!request.loggedIn)
              // Show sections for guests
              Container(
                  // ...existing code...
                  ),
            if (request.loggedIn)
              // Show sections for logged-in users
              Container(
                  // ...existing code...
                  ),
          ],
        ),
      ),
    );
  }
}
