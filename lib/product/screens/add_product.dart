import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:bali_delights_mobile/constants.dart';

class AddProductScreen extends StatefulWidget {
  final int storeId;

  const AddProductScreen({super.key, required this.storeId});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  String? _selectedCategory;
  File? _imageFile;
  Uint8List? _webImage;
  String? _imageUrl;
  bool _isUploading = false;
  String _choice = "upload"; // "upload" or "url"
  
  final List<String> categories = [
    'Clothes', 'Jewelries', 'Crafts', 'Arts', 'Snacks', 'Drinks'
  ];

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (kIsWeb) {
        var bytes = await image.readAsBytes();
        setState(() {
          _webImage = bytes;
          _imageFile = null; // Reset the image file if using web image
        });
      } else {
        setState(() {
          _imageFile = File(image.path);
          _webImage = null; // Reset the web image if using file upload
        });
      }
    }
  }

  Future<void> _addProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isUploading = true);

    try {
      final url = Uri.parse('${Constants.baseUrl}/products/api/store/${widget.storeId}/add-product/');
      final request = http.MultipartRequest('POST', url)
        ..fields['name'] = _nameController.text
        ..fields['description'] = _descriptionController.text
        ..fields['price'] = _priceController.text
        ..fields['stock'] = _stockController.text
        ..fields['category'] = _selectedCategory!
        ..fields['store_id'] = widget.storeId.toString();

      if (_choice == "upload") {
        String? base64Image;
        if (kIsWeb && _webImage != null) {
          base64Image = base64Encode(_webImage!);
        } else if (_imageFile != null) {
          final bytes = await _imageFile!.readAsBytes();
          base64Image = base64Encode(bytes);
        }
        if (base64Image != null) {
          request.fields['photo_upload'] = 'data:image/png;base64,$base64Image';
        }
      } else if (_choice == "url" && _imageUrl != null) {
        request.fields['photo_url'] = _imageUrl!;
      }

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);

      if (response.statusCode == 200 && jsonResponse['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added successfully!'))
        );
        Navigator.pop(context, true);
      } else {
        throw Exception(jsonResponse['message'] ?? 'Failed to add product');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}'))
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) => 
                  value?.isEmpty ?? true ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) => 
                  value?.isEmpty ?? true ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) => 
                  value?.isEmpty ?? true ? 'Please enter a price' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (value) => 
                  value?.isEmpty ?? true ? 'Please enter stock quantity' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: categories.map((String category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() => _selectedCategory = value);
                },
                validator: (value) => 
                  value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Image Option"),
                  Row(
                    children: [
                      Radio<String>(
                        value: "upload",
                        groupValue: _choice,
                        onChanged: (value) {
                          setState(() {
                            _choice = value!;
                            _imageFile = null;
                            _webImage = null;
                            _imageUrl = null;
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
                          });
                        },
                      ),
                     const  Text("Image URL"),
                    ],
                  ),
                ],
              ),
              if (_choice == "upload")
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Pick Image'),
                ),
              if (_choice == "upload" && (_imageFile != null || _webImage != null))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: kIsWeb
                      ? Image.memory(_webImage!, height: 200)
                      : Image.file(_imageFile!, height: 200),
                ),
              if (_choice == "url")
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Photo URL",
                    labelText: "Photo URL",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _imageUrl = value;
                    });
                  },
                  validator: (value) => null, // No validation for URL field
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isUploading ? null : _addProduct,
                child: _isUploading 
                  ? const CircularProgressIndicator() 
                  : const Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
