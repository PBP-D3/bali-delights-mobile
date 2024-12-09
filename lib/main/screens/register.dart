import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../constants.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String username = "";
  String password = "";
  String confirmPassword = "";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Username'),
                onChanged: (value) => username = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (value) => password = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                onChanged: (value) => confirmPassword = value,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (password != confirmPassword) {
                    ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(
                        content: Text("Passwords don't match!"),
                        backgroundColor: Colors.red,
                    ));
                    return;
                  }
                  
                  if (_formKey.currentState!.validate()) {
                    try {
                      final response = await request.post(
                        Constants.registerUrl,
                        jsonEncode({
                          'username': username,
                          'password': password,
                          'password_confirm': confirmPassword,
                        }),
                      );
                      
                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(response['message']),
                          backgroundColor: Colors.green,
                        ));
                        Navigator.pushReplacementNamed(context, '/login');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(response['message']),
                          backgroundColor: Colors.red,
                        ));
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Error: ${e.toString()}"),
                        backgroundColor: Colors.red,
                      ));
                    }
                  }
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
