import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _stockController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _imageUrlController = TextEditingController();

  bool isUploadingImage = true;
  bool isUrlOptionSelected = false;

  Future<void> addProduct() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final response = await http.post(
          Uri.parse('https://your-api-url.com/products/add'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': _nameController.text,
            'description': _descriptionController.text,
            'price': double.tryParse(_priceController.text),
            'stock': int.tryParse(_stockController.text),
            'category': _categoryController.text,
            'photo_url': isUrlOptionSelected ? _imageUrlController.text : null,
            'photo_upload': isUrlOptionSelected ? null : _imageUrlController.text,
          }),
        );

        final data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['success']) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product added successfully')));
          Navigator.pop(context); // Close the page
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add product')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void toggleFields(bool isUrlSelected) {
    setState(() {
      isUrlOptionSelected = isUrlSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Add New Product', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(labelText: 'Name'),
                                  validator: (value) => value!.isEmpty ? 'Please enter a product name' : null,
                                ),
                                TextFormField(
                                  controller: _descriptionController,
                                  decoration: InputDecoration(labelText: 'Description'),
                                  validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
                                ),
                                TextFormField(
                                  controller: _priceController,
                                  decoration: InputDecoration(labelText: 'Price'),
                                  keyboardType: TextInputType.number,
                                  validator: (value) => value!.isEmpty ? 'Please enter a price' : null,
                                ),
                                TextFormField(
                                  controller: _stockController,
                                  decoration: InputDecoration(labelText: 'Stock'),
                                  keyboardType: TextInputType.number,
                                  validator: (value) => value!.isEmpty ? 'Please enter stock' : null,
                                ),
                                TextFormField(
                                  controller: _categoryController,
                                  decoration: InputDecoration(labelText: 'Category'),
                                  validator: (value) => value!.isEmpty ? 'Please enter a category' : null,
                                ),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    Text('Upload Image:'),
                                    SizedBox(width: 16),
                                    Radio(
                                      value: true,
                                      groupValue: isUploadingImage,
                                      onChanged: (value) {
                                        toggleFields(false);
                                      },
                                    ),
                                    Text('Upload Image'),
                                    SizedBox(width: 16),
                                    Radio(
                                      value: false,
                                      groupValue: isUploadingImage,
                                      onChanged: (value) {
                                        toggleFields(true);
                                      },
                                    ),
                                    Text('Image URL'),
                                  ],
                                ),
                                if (isUploadingImage)
                                  TextFormField(
                                    controller: _imageUrlController,
                                    decoration: InputDecoration(labelText: 'Upload Image'),
                                    validator: (value) => value!.isEmpty ? 'Please upload an image' : null,
                                    keyboardType: TextInputType.url,
                                  )
                                else
                                  TextFormField(
                                    controller: _imageUrlController,
                                    decoration: InputDecoration(labelText: 'Enter Image URL'),
                                    validator: (value) => value!.isEmpty ? 'Please enter a URL' : null,
                                    keyboardType: TextInputType.url,
                                  ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context); // Close modal
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    SizedBox(width: 16),
                                    ElevatedButton(
                                      onPressed: addProduct,
                                      child: Text('Add Product'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Text('Add New Product'),
            ),
          ],
        ),
      ),
    );
  }
}
