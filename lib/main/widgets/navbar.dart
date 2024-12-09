import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert'; // Add this import
import '../../constants.dart';
import '../../main/models/user_model.dart'; // Add this import

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  Future<void> _showLogoutDialog(
      BuildContext context, CookieRequest request) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final response = await request.post(
                  Constants.logoutUrl,
                  {},
                );
                if (response['status'] == 'success' && context.mounted) {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Close drawer
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Successfully logged out!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pushReplacementNamed(context, '/');
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(response['message'] ?? 'Logout failed'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFBD9F7E),
            ),
            child: Text(
              'Bali Delights',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          if (!request.loggedIn) ...[
            // Login & Register options for logged out users
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              onTap: () => Navigator.pushNamed(context, '/login'),
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Register'),
              onTap: () => Navigator.pushNamed(context, '/register'),
            ),
          ] else ...[
            // Options for logged in users
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'), // User info section
              subtitle: const Text('Welcome back!'),
              enabled: false,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => _showLogoutDialog(context, request),
            ),
          ],
        ],
      ),
    );
  }
}
