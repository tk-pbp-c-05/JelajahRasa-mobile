import 'package:flutter/material.dart';
import 'package:jelajah_rasa_mobile/add_dish/models/newdish_entry.dart';
import 'package:jelajah_rasa_mobile/main/screens/home.dart';
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
    const String apiUrl =
        'http://127.0.0.1:8000/module4/flutter-add-dish/'; // Ganti dengan URL Django Anda

    try {
      final response = await request.post(
        apiUrl,
        jsonEncode(newDish.toJson()),
      );

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response['message']}')),
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
        userUsername:
            'current_user', // Ganti dengan username pengguna yang sebenarnya
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
          'Add New Dish',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xfffffffff),
      ),
      body: Container(
        color: const Color(0xFFF4E7B2), // Background warna kuning
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildInputField(
                  'Name',
                  TextFormField(
                    decoration: inputDecoration(),
                    onChanged: (value) => dishName = value,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Name is required'
                        : null,
                  )),
              buildInputField(
                  'Flavor',
                  DropdownButtonFormField<String>(
                    value: flavor,
                    decoration: inputDecoration(),
                    items: flavors
                        .map((flavor) => DropdownMenuItem(
                            value: flavor, child: Text(flavor)))
                        .toList(),
                    onChanged: (value) => setState(() => flavor = value!),
                  )),
              buildInputField(
                  'Category',
                  DropdownButtonFormField<String>(
                    value: category,
                    decoration: inputDecoration(),
                    items: categories
                        .map((category) => DropdownMenuItem(
                            value: category, child: Text(category)))
                        .toList(),
                    onChanged: (value) => setState(() => category = value!),
                  )),
              buildInputField(
                  'Vendor Name',
                  TextFormField(
                    decoration: inputDecoration(),
                    onChanged: (value) => vendorName = value,
                  )),
              buildInputField(
                  'Price',
                  TextFormField(
                    decoration: inputDecoration(),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => price = int.tryParse(value) ?? 0,
                  )),
              buildInputField(
                  'Map Link',
                  TextFormField(
                    decoration: inputDecoration(),
                    onChanged: (value) => mapLink = value,
                  )),
              buildInputField(
                  'Address',
                  TextFormField(
                    decoration: inputDecoration(),
                    onChanged: (value) => address = value,
                  )),
              buildInputField(
                  'Image',
                  TextFormField(
                    decoration: inputDecoration(),
                    onChanged: (value) => imageUrl = value,
                  )),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tombol Add
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveDish,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE0A85E),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Add',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(
                      width:
                          16), // Memberikan jarak antara tombol Add dan Cancel
                  // Tombol Cancel
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyHomePage())),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAB4A2F),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancel',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(String label, Widget inputField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          inputField,
        ],
      ),
    );
  }

  InputDecoration inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFAB4A2F), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFAB4A2F), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFAB4A2F), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
