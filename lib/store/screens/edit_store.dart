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
import 'package:bali_delights_mobile/store/model/store.dart';

class EditStorePage extends StatefulWidget {
  final Store store;

  const EditStorePage({super.key, required this.store});

  @override
  EditStorePageState createState() => EditStorePageState();
}

class EditStorePageState extends State<EditStorePage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  Uint8List? _webImage;

  late String _name;
  late String _location;
  late String _description;
  late String? _photoUpload;
  late String? _photo;
  String _choice = "upload";

  @override
  void initState() {
    super.initState();
    _name = widget.store.fields.name;
    _location = widget.store.fields.location;
    _description = widget.store.fields.description;
    _photoUpload = widget.store.fields.photoUpload != null && widget.store.fields.photoUpload!.isNotEmpty
        ? '${Constants.baseUrl}/media/${widget.store.fields.photoUpload}'
        : null;
    _photo = widget.store.fields.photo;

    if (widget.store.fields.photo != null && widget.store.fields.photo!.isNotEmpty) {
      _choice = "url";
    }
  }

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
      appBar: AppBar(
        title: const Text('Edit Store'),
      ),
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
                  initialValue: _name,
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
                  initialValue: _location,
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
                  initialValue: _description,
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
                              _photoUpload = null;
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
                      const SizedBox(height:
                      8),
                      if (_imageFile != null || _webImage != null)
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: kIsWeb
                              ? (_webImage != null 
                                  ? Image.memory(_webImage!)
                                  : const Center(child: Text("No image selected")))
                              : (_imageFile != null
                                  ? Image.file(_imageFile!)
                                  : const Center(child: Text("No image selected"))),
                        ),
                      if (_imageFile == null && 
                          _webImage == null && 
                          widget.store.fields.photoUpload != null && 
                          widget.store.fields.photoUpload!.isNotEmpty &&
                          _photoUpload != null)
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Image.network(
                            _photoUpload!,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Text("Failed to load existing image"),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              if (_choice == "url")
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: _photo,
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
                    validator: (value) => null,
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
                          'photo_upload': base64Image != null ? 'data:image/png;base64,$base64Image' : _photoUpload,
                        };

                        try {
                          final response = await request.postJson(
                            "${Constants.baseUrl}/stores/edit-flutter/${widget.store.pk}/",
                            jsonEncode(requestBody),
                          );
                          
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Store successfully updated!")),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const StorePage()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Failed to update store")),
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