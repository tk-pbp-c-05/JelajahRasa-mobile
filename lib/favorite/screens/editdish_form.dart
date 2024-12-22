import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:jelajah_rasa_mobile/favorite/models/favdish_entry.dart';

class EditFavDishFormPage extends StatefulWidget {
  final FavoriteDishEntry dish;

  const EditFavDishFormPage({super.key, required this.dish});

  @override
  State<EditFavDishFormPage> createState() => _EditFavDishFormPageState();
}

class _EditFavDishFormPageState extends State<EditFavDishFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Declare controllers for the form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _vendorNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mapLinkController = TextEditingController();

  // Store selected values for dropdown fields
  String? _selectedFlavor;
  String? _selectedCategory;

  final List<String> _flavorOptions = ['Sweet', 'Salty'];
  final List<String> _categoryOptions = ['Food', 'Beverage'];

  @override
  void initState() {
    super.initState();

    // Pre-fill the form fields with the current values from the dish
    _nameController.text = widget.dish.fields.name;
    _vendorNameController.text = widget.dish.fields.vendorName;
    _priceController.text = widget.dish.fields.price.toString();
    _imageController.text = widget.dish.fields.image;
    _addressController.text = widget.dish.fields.address;
    _mapLinkController.text = widget.dish.fields.mapLink;

    // Pre-select dropdown values
    _selectedFlavor = widget.dish.fields.flavor;
    _selectedCategory = widget.dish.fields.category;
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the widget tree
    _nameController.dispose();
    _vendorNameController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    _addressController.dispose();
    _mapLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Edit Your Favorite Dish",
          style: TextStyle(
            color: Color(0xFFAB4A2F),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Wrap the body content with SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter Dish Details",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFAB4A2F),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: "Food/Drink Name",
                  labelText: "Food/Drink Name",
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Food/Drink cannot be empty!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedFlavor,
                items: _flavorOptions.map((flavor) {
                  return DropdownMenuItem(
                    value: flavor,
                    child: Text(flavor),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: "Flavor",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedFlavor = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Flavor cannot be empty!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categoryOptions.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Category cannot be empty!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _vendorNameController,
                decoration: const InputDecoration(
                  hintText: "Restaurant Name",
                  labelText: "Restaurant",
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Restaurant cannot be empty!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  hintText: "Price",
                  labelText: "Price",
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Price cannot be empty!";
                  }
                  if (int.tryParse(value) == null) {
                    return "Price must be a number!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Address cannot be empty!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _mapLinkController,
                decoration: const InputDecoration(
                  labelText: "Map Link",
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Map Link cannot be empty!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  hintText: "Optional: Image URL",
                  labelText: "Image URL",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAB4A2F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final response = await request.postJson(
                        "https://daffa-desra-jelajahrasa.pbp.cs.ui.ac.id/MyFavoriteDishes/edit-flutter/${widget.dish.pk}/",
                        jsonEncode(<String, String>{
                          'name': _nameController.text,
                          'price': _priceController.text,
                          'vendor_name': _vendorNameController.text,
                          'image': _imageController.text,
                          'flavor': _selectedFlavor ?? '',
                          'category': _selectedCategory ?? '',
                          'address': _addressController.text,
                          'map_link': _mapLinkController.text,
                        }),
                      );

                      if (context.mounted) {
                        if (response['status'] == 'success') {
                          // Update dish object with new data
                          widget.dish.fields.name = _nameController.text;
                          widget.dish.fields.price =
                              int.tryParse(_priceController.text) ?? 0;
                          widget.dish.fields.vendorName =
                              _vendorNameController.text;
                          widget.dish.fields.image = _imageController.text;
                          widget.dish.fields.flavor = _selectedFlavor ?? '';
                          widget.dish.fields.category = _selectedCategory ?? '';
                          widget.dish.fields.address = _addressController.text;
                          widget.dish.fields.mapLink = _mapLinkController.text;

                          // Pass updated dish back to previous screen
                          Navigator.pop(context, widget.dish);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Error updating dish")),
                          );
                        }
                      }
                    }
                  },
                  child: const Text(
                    "SUBMIT",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
