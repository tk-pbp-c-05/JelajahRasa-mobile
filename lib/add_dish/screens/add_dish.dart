import 'package:flutter/material.dart';
import 'package:jelajah_rasa_mobile/add_dish/models/newdish_entry.dart';
import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

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
  int price = 0;
  String mapLink = '';
  String address = '';
  String imageUrl = '';

  // Default values for Map Link and Image URL
  final String defaultMapLink = 'https://www.google.com/';
  final String defaultImageUrl = 'https://i.imgur.com/8j7wC8j.jpeg';

  // Dropdown options
  final List<String> flavors = ['Salty', 'Sweet'];
  final List<String> categories = ['Food', 'Beverage'];


Future<void> _submitDishToServer(NewDishEntry newDish) async {
  final request = context.read<CookieRequest>();
  const String apiUrl = 'http://127.0.0.1:8000/module4/flutter-add-dish/'; // Ganti dengan URL Django Anda

  try {
    final response = await request.post(
      apiUrl,
      jsonEncode(newDish.toJson()),
    );

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dish added successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response['message']}')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}

void _saveDish() {
  if (_formKey.currentState?.validate() ?? false) {
    NewDishEntry newDish = NewDishEntry(
      uuid: UniqueKey().toString(),
      name: dishName,
      flavor: flavor,
      category: category,
      vendorName: vendorName,
      price: price,
      mapLink: mapLink.isNotEmpty ? mapLink : defaultMapLink,
      address: address,
      image: imageUrl.isNotEmpty ? imageUrl : defaultImageUrl,
      isApproved: false,
      isRejected: false,
      status: 'Pending',
      userUsername: 'current_user', // Ganti dengan username pengguna yang sebenarnya
    );

    // Kirim data ke server Django
    _submitDishToServer(newDish);

    // Reset form setelah berhasil
    _formKey.currentState?.reset();
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Dish',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFF18F73),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Dish Name
              TextFormField(
                decoration: const InputDecoration(labelText: 'Dish Name'),
                onChanged: (value) => dishName = value,
                validator: (value) => value == null || value.isEmpty ? 'Dish name is required' : null,
              ),
              const SizedBox(height: 16),

              // Flavor
              DropdownButtonFormField<String>(
                value: flavor,
                decoration: const InputDecoration(labelText: 'Flavor'),
                items: flavors.map((flavor) => DropdownMenuItem(value: flavor, child: Text(flavor))).toList(),
                onChanged: (value) => setState(() => flavor = value!),
              ),
              const SizedBox(height: 16),

              // Category
              DropdownButtonFormField<String>(
                value: category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: categories.map((category) => DropdownMenuItem(value: category, child: Text(category))).toList(),
                onChanged: (value) => setState(() => category = value!),
              ),
              const SizedBox(height: 16),

              // Vendor Name
              TextFormField(
                decoration: const InputDecoration(labelText: 'Vendor Name'),
                onChanged: (value) => vendorName = value,
              ),
              const SizedBox(height: 16),

              // Price
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onChanged: (value) => price = int.tryParse(value) ?? 0,
              ),
              const SizedBox(height: 16),

              // Map Link
              TextFormField(
                decoration: const InputDecoration(labelText: 'Map Link'),
                onChanged: (value) => mapLink = value,
              ),
              const SizedBox(height: 16),

              // Address
              TextFormField(
                decoration: const InputDecoration(labelText: 'Address'),
                onChanged: (value) => address = value,
              ),
              const SizedBox(height: 16),

              // Image URL
              TextFormField(
                decoration: const InputDecoration(labelText: 'Image URL'),
                onChanged: (value) => imageUrl = value,
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _saveDish,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF18F73),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
