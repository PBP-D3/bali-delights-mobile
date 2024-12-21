import 'dart:convert';
import 'package:flutter/material.dart';
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
    _photoUpload = widget.store.fields.photoUpload;
    _photo = widget.store.fields.photo;
    _choice = _photoUpload != null && _photoUpload!.isNotEmpty ? "upload" : "url";
  }

  Future<void> _submitForm(CookieRequest request) async {
    if (_formKey.currentState!.validate()) {
      final response = await request.postJson(
        '${Constants.baseUrl}/stores/edit-flutter/${widget.store.pk}/',
        jsonEncode({
          'name': _name,
          'location': _location,
          'description': _description,
          'photo_upload': _photoUpload,
          'photo': _photo,
        }),
      );

      if (!mounted) return;

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Store successfully updated!"),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const StorePage(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to update the store. Try again."),
          ),
        );
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
              // Input Name
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

              // Input Location
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

              // Input Description
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

              // Image Selection Option
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
                            });
                          },
                        ),
                        const Text("Image URL"),
                      ],
                    ),
                  ],
                ),
              ),

              // Input Photo Upload
              if (_choice == "upload")
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: _photoUpload,
                    decoration: InputDecoration(
                      hintText: "Photo Upload",
                      labelText: "Photo Upload",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _photoUpload = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Photo Upload cannot be empty!";
                      }
                      return null;
                    },
                  ),
                ),

              // Input Photo URL
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Photo URL cannot be empty!";
                      }
                      return null;
                    },
                  ),
                ),

              // Submit Button
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
                        await _submitForm(request);
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