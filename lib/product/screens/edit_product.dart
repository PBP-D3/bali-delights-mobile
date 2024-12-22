import 'package:bali_delights_mobile/constants.dart';
import 'package:bali_delights_mobile/product/models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  EditProductScreen({required this.product});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  String? _selectedCategory;
  File? _image;
  String? _imageUrl;
  bool _isUploading = false;
  String _imageChoice = 'upload'; 

    final List<String> categories = [
    'Clothes', 'Jewelries', 'Crafts', 'Arts', 'Snacks', 'Drinks'
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _descriptionController = TextEditingController(text: widget.product.description);
    _priceController = TextEditingController(text: widget.product.price.toString());
    _stockController = TextEditingController(text: widget.product.stock.toString());
    _selectedCategory = widget.product.category;
    _imageUrl = widget.product.photoUrl;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imageUrl = null; // Clear URL if a new image is picked
      });
    }
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final url = Uri.parse('${Constants.baseUrl}/products/api/products/${widget.product.id}/edit/');
      final request = http.MultipartRequest('POST', url)
        ..fields['name'] = _nameController.text
        ..fields['description'] = _descriptionController.text
        ..fields['price'] = _priceController.text
        ..fields['stock'] = _stockController.text
        ..fields['category'] = _selectedCategory!;

      if (_image != null) {
        request.files.add(
          await http.MultipartFile.fromPath('photo_upload', _image!.path),
        );
      } else if (_imageUrl != null) {
        request.fields['photo_url'] = _imageUrl!;
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product updated successfully!')),
        );
        Navigator.pop(context, true);
      } else {
        final responseBody = await response.stream.bytesToString();
        throw Exception('Failed to update product: $responseBody');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _deleteProduct() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Product'),
        content: Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final response = await http.delete(
        Uri.parse('${Constants.baseUrl}/products/api/products/${widget.product.id}/delete/'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product deleted successfully!')),
        );
        Navigator.pop(context, true);
      } else {
        throw Exception('Failed to delete product');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteProduct,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a name' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a description' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a price' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _stockController,
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter stock quantity' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(labelText: 'Category'),
                items: categories.map((String category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() => _selectedCategory = value);
                },
                validator: (value) => value == null ? 'Please select a category' : null,
              ),
              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Image Option",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: "upload",
                        groupValue: _imageChoice,
                        onChanged: (value) {
                          setState(() {
                            _imageChoice = value!;
                            _imageUrl = null;
                            _image = null;
                          });
                        },
                      ),
                      const Text("Upload Image"),
                      Radio<String>(
                        value: "url",
                        groupValue: _imageChoice,
                        onChanged: (value) {
                          setState(() {
                            _imageChoice = value!;
                            _image = null;
                            _imageUrl = null;
                          });
                        },
                      ),
                      const Text("Image URL"),
                    ],
                  ),
                ],
              ),
              if (_imageChoice == "upload")
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Pick Image'),
                ),
              if (_imageChoice == "upload" && _image != null)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Image.file(_image!, height: 200),
                ),
              if (_imageChoice == "url")
                TextFormField(
                  initialValue: _imageUrl,
                  decoration: InputDecoration(labelText: 'Image URL'),
                  onChanged: (value) {
                    setState(() {
                      _imageUrl = value;
                    });
                  },
                ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isUploading ? null : _updateProduct,
                child: _isUploading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text('Update Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
