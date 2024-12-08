import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jelajah_rasa_mobile/add_dish/screens/menu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddDish extends StatefulWidget {
  const AddDish({super.key});

  @override
  State<AddDish> createState() => _AddDishState();
}

class _AddDishState extends State<AddDish> {
  final _formKey = GlobalKey<FormState>();

  // Form field variables
  String dishName = '';
  String flavor = 'Salty';
  String category = 'Food';
  String vendorName = '';
  double price = 0.0;
  String mapLink = '';
  String address = '';
  String imageUrl = '';

  // Default values for Map Link and Image URL
  final String defaultMapLink = 'https://www.google.com/';
  final String defaultImageUrl = 'https://i.imgur.com/8j7wC8j.jpeg';

  // Dropdown options
  final List<String> flavors = ['Salty', 'Sweet'];
  final List<String> categories = ['Food', 'Beverage'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.chevronLeft),
          onPressed: () {
            // Navigate back to the HomeScreen
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
          },
        ),
        title: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Hello User',
                style: TextStyle(
                  color: Color(0xFFF4B5A4),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Add a new dish to your menu',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF757575), // Gray color for the subtitle
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white70,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Dish Name
              const Text("Dish Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter the dish name',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(width: 2, color: Color(0xFFF18F73)),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    dishName = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Dish name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Flavor
              const Text("Flavor", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: flavor,
                decoration: InputDecoration(
                  hintText: 'Select flavor',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(width: 2, color: Color(0xFFF18F73)),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    flavor = value!;
                  });
                },
                items: flavors.map((flavor) {
                  return DropdownMenuItem<String>(
                    value: flavor,
                    child: Text(flavor),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              const Text("Category", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: category,
                decoration: InputDecoration(
                  hintText: 'Select category',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(width: 2, color: Color(0xFFF18F73)),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    category = value!;
                  });
                },
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Vendor Name
              const Text("Vendor's Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter the vendor name',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(width: 2, color: Color(0xFFF18F73)),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    vendorName = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Vendor Name
              const Text("Price", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter Price',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(width: 2, color: Color(0xFFF18F73)),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    price = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Map Link
              const Text("Map Link", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter the Map Link',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(width: 2, color: Color(0xFFF18F73)),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    mapLink = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Address
              const Text("Address", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter address',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(width: 2, color: Color(0xFFF18F73)),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    address = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Image URL
              const Text("Image URL", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter the URL for Image',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(width: 2, color: Color(0xFFF18F73)),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    imageUrl = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Handle submit logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Submitting Form')),
                    );
                  }
                },
                child: const Text('Save', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                  backgroundColor: Color(0xFFF18F73),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}