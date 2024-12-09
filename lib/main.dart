import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'main/screens/login.dart';
import 'main/screens/register.dart';
import 'main/widgets/navbar.dart';
// import cart from screen
import 'package:bali_delights_mobile/carts/screens/carts.dart';
// import 'main/screens/home.dart'; // Ensure you have a HomePage widget
import 'package:bali_delights_mobile/chats/screens/chat_list_screen.dart';

void main() {
  runApp(
    Provider(
      create: (_) => CookieRequest(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bali Delights',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFBD9F7E),
          primary: const Color(0xFFBD9F7E),
        ),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/cart': (context) => const CartScreen(),
        '/chat': (context) => ChatListScreen(), // Add this line
      },
    );
  }
}

class HomePage extends StatelessWidget {
  // Ensure HomePage is defined
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
            // Hero Section with increased height
            Container(
              height: Constants.heroSectionHeight,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFEAE0D5),
                    const Color(0xFFBD9F7E),
                  ],
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Bali Delights',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Discover the best local products from the heart of Bali. From handmade crafts to exotic snacks, we bring the island\'s charm right to your doorstep.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            // Products Section with increased height
            Container(
              height: Constants.productsSectionHeight,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Explore Over 100 Products',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Discover the best of Bali with our curated selection of local products.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Store Owner Section with increased height
            Container(
              height: Constants.storeOwnerSectionHeight,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFEAE0D5), Colors.white],
                ),
              ),
              child: const Column(
                children: [
                  Text(
                    'Become a Store Owner and Start Earning!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('• Turn your passion into profit'),
                      Text('• Easily manage your products'),
                      Text('• Dedicated chat channels for each user'),
                      Text('• And many more benefits!'),
                    ],
                  ),
                ],
              ),
            ),

            // Join Now Section - Only show if not logged in
            if (!request.loggedIn)
              Container(
                height: Constants.joinNowSectionHeight,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Join the Bali Delights Community',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Sign up to enjoy a personalized shopping experience and exclusive offers.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/login'),
                          child: const Text('Login'),
                        ),
                        const SizedBox(width: 10),
                        FilledButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/register'),
                          child: const Text('Register'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
