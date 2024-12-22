// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bali_delights_mobile/store/screens/store_page.dart';
import 'package:bali_delights_mobile/constants.dart';

class StoreFormPage extends StatefulWidget {
  const StoreFormPage({super.key});

  @override
  State<StoreFormPage> createState() => _StoreFormPageState();
}



class _StoreFormPageState extends State<StoreFormPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  Uint8List? _webImage;

  String _name = "";
  String _location = "";
  String _description = "";
  String? _photo;
  String _choice = "upload";


  Future<void> _pickImage() async {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        if (kIsWeb) {
          var bytes = await pickedFile.readAsBytes();
          setState(() {
            _webImage = bytes;
          });
        } else {
          setState(() {
            _imageFile = File(pickedFile.path);
          });
        }
      }
    } 

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Store Name",
                    labelText: "Store Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Store Name cannot be empty!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Location",
                    labelText: "Location",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _location = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Location cannot be empty!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Description",
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _description = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Description cannot be empty!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Store Image Option",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: "upload",
                          groupValue: _choice,
                          onChanged: (value) {
                            setState(() {
                              _choice = value!;
                              _photo = null;
                              _imageFile = null;
                              _webImage = null;
                            });
                          },
                        ),
                        const Text("Upload Image"),
                        Radio<String>(
                          value: "url",
                          groupValue: _choice,
                          onChanged: (value) {
                            setState(() {
                              _choice = value!;
                              _imageFile = null;
                              _webImage = null;
                              _photo = null;
                            });
                          },
                        ),
                        const Text("Image URL"),
                      ],
                    ),
                  ],
                ),
              ),
              if (_choice == "upload")
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: const Text("Pick Image"),
                      ),
                      if (_imageFile != null || _webImage != null)
                        Container(
                          width: 200,
                          height: 200,
                          margin: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: kIsWeb
                              ? Image.memory(_webImage!)
                              : Image.file(_imageFile!),
                        ),
                    ],
                  ),
                ),
              if (_choice == "url")
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Photo URL",
                      labelText: "Photo URL",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _photo = value;
                      });
                    },
                    // Remove validator or make it always return null
                    validator: (value) => null, // This allows empty/null values
                  ),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String? base64Image;
                        if (_choice == "upload") {
                          if (kIsWeb && _webImage != null) {
                            base64Image = base64Encode(_webImage!);
                          } else if (_imageFile != null) {
                            final bytes = await _imageFile!.readAsBytes();
                            base64Image = base64Encode(bytes);
                          }
                        }

                        final requestBody = {
                          'name': _name,
                          'location': _location,
                          'description': _description,
                          'photo': _photo,
                          'photo_upload': base64Image != null ? 'data:image/png;base64,$base64Image' : null,
                        };

                        try {
                          final response = await request.postJson(
                            "${Constants.baseUrl}/stores/register-store-flutter/",
                            jsonEncode(requestBody),
                          );
                          
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Store successfully registered!")),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const StorePage()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Failed to register store")),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error: $e")),
                          );
                        }
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}